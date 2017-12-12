declare
  l_prefix varchar2(15) := 'EBA_DBTOOLS';
  l_spaces varchar2(10) := '  '; -- use '&nbsp;' in web
  l_enter  varchar2(10) := CHR(10); -- use '<br/>' in web
  l_constraint varchar2(500);
begin
  for t in (select t.table_name, 
                   case when m.comments is not null then ' [' || replace(replace(replace(m.comments,'[','{'),']','}'),CHR(10)) ||']' end as comments
              from user_tables t, user_tab_comments m,                                       
                   (select max(lvl) as lvl, table_name
                      from 
                      (select level as lvl, table_name, rpad('_', (level-1)*2, '_') || table_name as tbl 
                        from (
                          select a.table_name, a.constraint_name pkey_constraint, b.constraint_name fkey_constraint, b.r_constraint_name 
                            from user_constraints a, user_constraints b 
                          where a.table_name = b.table_name (+)
                            and a.constraint_type = 'P' 
                            and b.constraint_type (+) = 'R' 
                            and a.table_name like l_prefix || '%'
                        )
                        start with fkey_constraint is null 
                        connect by prior pkey_constraint = r_constraint_name 
                      )
                     group by table_name  
                   ) o 
             where t.table_name = m.table_name (+)
               and t.table_name = o.table_name (+)
               and t.table_name like l_prefix || '%'
             order by o.lvl, t.table_name 
           )
  loop
    sys.htp.prn(l_enter || l_enter || lower(replace(t.table_name,l_prefix||'_')) || t.comments );
    for c in (select c.column_name, c.data_type, c.data_length, c.data_precision, c.data_scale, 
                     c.nullable, c.default_length, c.data_default,
                     case when to_char(c.data_length) is not null
                          then c.data_type || '(' || to_char(c.data_length) ||')'
                          else c.data_type
                     end as data_type_length,
                     case when m.comments is not null then ' [' || replace(replace(replace(m.comments,'[','{'),']','}'),CHR(10))  ||']' end as comments
                from user_tab_columns c, user_col_comments m
               where c.table_name = t.table_name               
                 and c.column_name not in ('ID', 'CREATED_BY', 'CREATION_DATE', 'UPDATED_BY', 'UPDATE_DATE')
                 and c.table_name = m.table_name (+)
                 and c.column_name = m.column_name (+)
               order by c.column_id
             )
    loop
      l_constraint := '';
      for u in (select b.table_name, b.column_name, a.constraint_type, a.search_condition, replace(a.r_constraint_name,'_PK') as r_constraint_name
                  from user_constraints a, user_cons_columns b
                 where a.constraint_name = b.constraint_name
                   and b.table_name = t.table_name 
                   and b.column_name = c.column_name
                   and a.constraint_type in ('U','R','C')
               )
      loop
        if u.constraint_type = 'U'
        then
          l_constraint := l_constraint || ' /unique';
        elsif u.constraint_type = 'R'
        then
          l_constraint := l_constraint || ' /fk ' || u.r_constraint_name;
        elsif u.constraint_type = 'C' and u.search_condition like '%NOT NULL%'
        then
          l_constraint := l_constraint || ' /nn';
        elsif u.constraint_type = 'C' 
        then
          l_constraint := l_constraint || ' /check ' || replace(replace(replace(u.search_condition,CHR(10)),CHR(13)),' ');
        end if;          
      end loop;         
      sys.htp.prn(l_enter || l_spaces || rpad(lower(c.column_name),30, ' ') || ' ' || lower(c.data_type_length) || ' ' || l_constraint || c.comments);         
    end loop;  
  end loop;          
end;