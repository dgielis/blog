create or replace PACKAGE MTL_ERD_PKG is
--******************************************************************************
--  project:  MTL
--  description:
--    package to facilitate the creation of the database objects
--  note:
--    you should create the tables and primary and unique keys before using this package
--    table names should be prefixed with 3 characters e.g. MTL_TABLE
--    every table needs to have the ID column as primary key
--    all foreign keys should be table_name (without prefix) underscore primary key
--    e.g. TABLE_ID, this means there will be a foreign key against the id column of table
--    enable dbms_output as errors will be thrown in that pipe
--  known restrictions:
--    none
--  supported apex versions:
--    4.x and higher
--  authors:
--    dg: Dimitri Gielis (http://dgielis.blogspot.com) - APEX RnD (https://www.apexrnd.be)
--  svn header:
--    $$
--******************************************************************************
--
--
--==============================================================================
-- add created_by, created_date, modified_by, modified_date to one or more tables
--==============================================================================
  procedure add_audit_columns (p_table_name varchar2 default 'all');
--
--==============================================================================
-- drop created_by, created_date, modified_by, modified_date from one or more tables
--==============================================================================
  procedure drop_audit_columns (p_table_name varchar2 default 'all');
--
--==============================================================================
-- add foreign keys to one or more tables based on id as PK and table name _id as FK
--==============================================================================
  procedure add_fk_constraints (p_table_name varchar2 default 'all');
--
--==============================================================================
-- drop foreign keys from one or more tables
--==============================================================================
  procedure drop_fk_constraints (p_table_name varchar2 default 'all');
--
--==============================================================================
-- add sequences for one or more tables
--==============================================================================
  procedure add_sequences (p_table_name varchar2 default 'all');
--
--==============================================================================
-- drop sequences for one or more tables
--==============================================================================
  procedure drop_sequences (p_table_name varchar2 default 'all');
--
--==============================================================================
-- add triggers to one or more tables, which fills the id (pk) and audit columns
--==============================================================================
  procedure add_triggers (p_table_name varchar2 default 'all');
--
--==============================================================================
-- drop triggers from one or more tables
--==============================================================================
  procedure drop_triggers (p_table_name varchar2 default 'all');
--
--==============================================================================
-- drop all database objects with prefix
--==============================================================================
  procedure drop_db_objects;
--
--==============================================================================
-- truncate one or more tables, based on the name (like)
--==============================================================================
  procedure truncate_tables (p_table_name varchar2 default 'all');
--
--==============================================================================
-- delete all dropped objects forever (empty recyclebin)
--==============================================================================
  procedure purge_recyclebin;
--
--==============================================================================
-- to use the APEX 4.1 Error handling a constraint lookup table needs to exist
-- this procedure will create the table and add all the unique keys
--==============================================================================
  procedure create_constraint_lookup;
  
  
  procedure create_index_fks;
--
--
end mtl_erd_pkg;
/


create or replace PACKAGE BODY MTL_ERD_PKG
as
--******************************************************************************
--  project:  MTL
--  description:
--    package to facilitate the creation of the database objects
--  note:
--    you should create the tables and primary and unique keys before using this package
--    table names should be prefixed with 3 characters e.g. MTL_TABLE
--    every table needs to have the ID column as primary key
--    all foreign keys should be table_name (without prefix) underscore primary key
--    e.g. TABLE_ID, this means there will be a foreign key against the id column of table
--    enable dbms_output as errors will be thrown in that pipe
--  known restrictions:
--    none
--  supported apex versions:
--    4.x and higher
--  authors:
--    dg: Dimitri Gielis (http://dgielis.blogspot.com) - APEX RnD (https://www.apexrnd.be)
--  svn header:
--    $$
--******************************************************************************
--
  c_prefix VARCHAR2(4) := 'MTL_';
  c_crlf   VARCHAR2(4) := CHR(10);
--
--==============================================================================
-- add created_by, created_date, modified_by, modified_date to one or more tables
--==============================================================================
  procedure add_audit_columns (p_table_name varchar2 default 'all')
  as
  begin
    for r in (select 'alter table ' || a.table_name
                  || ' add (created_by varchar2(250), created_date date, modified_by varchar2(250), modified_date date )' as create_audit_cols
                from user_tables a
               where a.table_name = DECODE(p_table_name, 'all', a.table_name, p_table_name)
                 and a.table_name like c_prefix || '%'
             )
    loop
      begin
        execute immediate r.create_audit_cols;
      exception
      when others then
        dbms_output.put_line('Error in add_audit_columns: ' || r.create_audit_cols);
      end;
    end loop;
  end add_audit_columns;
--
--==============================================================================
-- drop created_by, created_date, modified_by, modified_date from one or more tables
--==============================================================================
  procedure drop_audit_columns (p_table_name varchar2 default 'all')
  as
  begin
    for r in (select 'alter table ' || a.table_name
                  || ' drop ' || a.column_name as drop_audit_col
                from user_tab_columns a
               where a.table_name = DECODE(p_table_name, 'all', a.table_name, p_table_name)
                 and a.table_name like c_prefix || '%'
                 and a.column_name in ('CREATED_BY', 'CREATED_DATE', 'MODIFIED_BY', 'MODIFIED_DATE')
             )
    loop
      begin
        execute immediate r.drop_audit_col;
      exception
      when others then
        dbms_output.put_line('Error in drop_audit_columns: ' || r.drop_audit_col);
      end;
    end loop;
  end drop_audit_columns;
--
--==============================================================================
-- add foreign keys to one or more tables based on id as PK and table name _id as FK
--==============================================================================
  procedure add_fk_constraints (p_table_name varchar2 default 'all')
  as
  begin
    for r in (select 'alter table ' || a.table_name
                  || ' add constraint ' || a.table_name || substr(substr(b.table_name,4),
                  case
                  when (length(substr(b.table_name,4))-(26-length(a.table_name))) < 0
                  then 1
                  else length(substr(b.table_name,4))-(26-length(a.table_name))
                  end, 26-length(a.table_name))
                  ||'_fk foreign key (' || a.column_name ||') references '
                  || b.table_name ||' (' ||b.column_name ||') enable validate' as create_fk
                from user_tab_columns a, user_tab_columns b
               where a.column_name like '%_ID'
                 and b.column_name = 'ID'
                 and a.table_name like c_prefix || '%'
                 and b.table_name like c_prefix || '%'
                 and b.table_name = c_prefix || substr(a.column_name,1,instr(a.column_name,'_ID')-1)
                 and a.table_name = DECODE(p_table_name, 'all', a.table_name, p_table_name)
             )
    loop
      begin
        execute immediate r.create_fk;
      exception
      when others then
        dbms_output.put_line('Error in add_fk_constraints: ' || r.create_fk);
      end;
    end loop;
  end add_fk_constraints;
--
--==============================================================================
-- drop foreign keys from one or more tables
--==============================================================================
  procedure drop_fk_constraints (p_table_name varchar2 default 'all')
  as
  begin
    for r in (select 'alter table ' || a.table_name
                  || ' drop constraint ' || a.constraint_name || '' as drop_constr
                from user_constraints a
               where a.table_name = DECODE(p_table_name, 'all', a.table_name, p_table_name)
                 and a.table_name like c_prefix || '%'
                 and a.constraint_type = 'R'
             )
    loop
      begin
        execute immediate r.drop_constr;
      exception
      when others then
        dbms_output.put_line('Error in drop_fk_constraints: ' || r.drop_constr);
      end;
    end loop;
  end drop_fk_constraints;
--
--==============================================================================
-- add sequences for one or more tables
--==============================================================================
  procedure add_sequences (p_table_name varchar2 default 'all')
  as
  begin
    for r in (select 'create sequence ' || a.table_name || '_seq start with 1'
                  || ' increment by 1 nocache nocycle' as create_seq
                from user_tables a
               where a.table_name = DECODE(p_table_name, 'all', a.table_name, p_table_name)
                 and a.table_name like c_prefix || '%'
             )
    loop
      begin
        execute immediate r.create_seq;
      exception
      when others then
        dbms_output.put_line('Error in add_sequences: ' || r.create_seq);
      end;
    end loop;
  end add_sequences;
--
--==============================================================================
-- drop sequences for one or more tables
--==============================================================================
  procedure drop_sequences (p_table_name varchar2 default 'all')
  as
  begin
    for r in (select 'drop sequence ' || a.sequence_name || '' as drop_seq
                from user_sequences a
               where a.sequence_name like c_prefix || '%'
                 and SUBSTR(a.sequence_name,1,LENGTH(a.sequence_name)-4) = DECODE(p_table_name, 'all', SUBSTR(a.sequence_name,1,LENGTH(a.sequence_name)-4), p_table_name)
             )
    loop
      begin
        execute immediate r.drop_seq;
      exception
      when others then
        dbms_output.put_line('Error in drop_sequences: ' || r.drop_seq);
      end;
    end loop;
  end drop_sequences;
--
--==============================================================================
-- add triggers to one or more tables, which fills the id (pk) and audit columns
--==============================================================================
  procedure add_triggers (p_table_name varchar2 default 'all')
  as
  begin
    for r in (select 'create or replace trigger ' || c_crlf
                  || a.table_name || '_iutrg ' || c_crlf
                  || 'before insert or update on ' || a.table_name || c_crlf
                  || ' for each row begin  ' || c_crlf
                  || '   if inserting  ' || c_crlf
                  || '   then  ' || c_crlf
                  || '     if :new.id is null ' || c_crlf
                  || '     then ' || c_crlf
                  || '       select ' || a.table_name || '_seq.nextval into :new.id from dual; ' || c_crlf
                  || '     end if; ' || c_crlf
                  || '     :new.created_by := nvl(v(''app_user''),user); ' || c_crlf
                  || '     :new.created_date := sysdate; ' || c_crlf
                  || '   end if;  ' || c_crlf
                  || '   if updating ' || c_crlf
                  || '   then  ' || c_crlf
                  || '     :new.modified_by := nvl(v(''app_user''),user); ' || c_crlf
                  || '     :new.modified_date := sysdate; ' || c_crlf
                  || '   end if;  ' || c_crlf
                  || ' end; ' as create_trigger
                from user_tables a
               where a.table_name = DECODE(p_table_name, 'all', a.table_name, p_table_name)
                 and a.table_name like c_prefix || '%'
            )
    loop
      begin
        execute immediate r.create_trigger;
      exception
      when others then
        dbms_output.put_line('Error in add_triggers: ' || r.create_trigger);
      end;
    end loop;
  end add_triggers;
--
--==============================================================================
-- drop triggers from one or more tables
--==============================================================================
  procedure drop_triggers (p_table_name varchar2 default 'all')
  as
  begin
    null;
  end drop_triggers;
--
--==============================================================================
-- drop all database objects with prefix
--==============================================================================
  procedure drop_db_objects
  as
  begin
    for r in (select 'drop ' || object_type || ' ' || object_name ||
                     case when object_type = 'TABLE' then ' cascade constraints ' end as drop_object
                from user_objects
               where object_name like c_prefix || '%'
                 and object_name <> c_prefix || 'ERD_PKG'
             )
    loop
      begin
        execute immediate r.drop_object;
      exception
      when others then
        dbms_output.put_line('Error in drop_db_objects: ' || r.drop_object);
      end;      
    end loop;
  end drop_db_objects;
--
--==============================================================================
-- truncate one or more tables, based on the name (like)
--==============================================================================
  procedure truncate_tables (p_table_name varchar2 default 'all')
  as
  begin
    for r in (select 'truncate table ' || a.table_name as truncate_table
                from user_tables a
               where a.table_name = DECODE(p_table_name, 'all', a.table_name, p_table_name)
                 and a.table_name like c_prefix || '%'
             )
    loop
      begin
        execute immediate r.truncate_table;
      exception
      when others then
        dbms_output.put_line('Error in truncate_tables: ' || r.truncate_table);
      end;
    end loop;
  end truncate_tables;
--
--==============================================================================
-- delete all dropped objects forever (empty recyclebin)
--==============================================================================
  procedure purge_recyclebin
  as
  begin
    execute immediate 'purge recyclebin';
  end purge_recyclebin;
--
--==============================================================================
-- to use the APEX 4.1 Error handling a constraint lookup table needs to exist
-- this procedure will create the table and add all the unique keys
--==============================================================================
  procedure create_constraint_lookup
  as
  begin
    execute immediate 'CREATE TABLE '||c_prefix||'_CONSTRAINT_LOOKUP ( CONSTRAINT_NAME VARCHAR2(30), MESSAGE VARCHAR2(4000) NOT NULL ENABLE, PRIMARY KEY (CONSTRAINT_NAME) )';
    insert into OPP_db_constraint (constraint_name, message)
    select constraint_name, ' '
      from user_constraints
     where constraint_name like c_prefix || '%UK%';
  end create_constraint_lookup;
--
--

 procedure create_index_fks
 is
begin
for r in (
select	'CREATE INDEX '  || replace(CONSTRAINT_NAME,'FK_','IX_') || 
	' ON ' || table_name || ' (' || col_list ||') ;' Indx from 
 	(select  cc.TABLE_NAME, cc.CONSTRAINT_NAME,
           max(decode(position, 1,     '"' ||
                  substr(column_name,1,30) ||'"',NULL)) ||
           max(decode(position, 2,', '||'"'||
                  substr(column_name,1,30) ||'"',NULL)) ||
           max(decode(position, 3,', '||'"'||
                  substr(column_name,1,30) ||'"',NULL)) ||
           max(decode(position, 4,', '||'"'||
                  substr(column_name,1,30) ||'"',NULL)) ||
           max(decode(position, 5,', '||'"'||
                  substr(column_name,1,30) ||'"',NULL)) ||
           max(decode(position, 6,', '||'"'||
                  substr(column_name,1,30) ||'"',NULL)) ||
           max(decode(position, 7,', '||'"'||
                  substr(column_name,1,30) ||'"',NULL)) ||
           max(decode(position, 8,', '||'"'||
                  substr(column_name,1,30) ||'"',NULL)) ||
           max(decode(position, 9,', '||'"'||
                  substr(column_name,1,30) ||'"',NULL)) ||
           max(decode(position, 10,', '||'"'||
                  substr(column_name,1,30) ||'"',NULL)) col_list
           from user_constraints dc, user_cons_columns cc
           where dc.CONSTRAINT_NAME = cc.CONSTRAINT_NAME
           and dc.CONSTRAINT_type = 'R'
           group by  cc.TABLE_NAME, cc.CONSTRAINT_NAME 
 	) con
  	where not exists (
		select 1 from
          		( select table_name,   
           			max(decode(column_position, 1,     '"'||
                  			substr(column_name,1,30)  ||'"',NULL)) ||
           			max(decode(column_position, 2,', '||'"'||
                  			substr(column_name,1,30)  ||'"',NULL)) ||
           			max(decode(column_position, 3,', '||'"'||
                  			substr(column_name,1,30)  ||'"',NULL)) ||
           			max(decode(column_position, 4,', '||'"'||
                  			substr(column_name,1,30)  ||'"',NULL)) ||
           			max(decode(column_position, 5,', '||'"'||
                  			substr(column_name,1,30)  ||'"',NULL)) ||
           			max(decode(column_position, 6,', '||'"'||
                  			substr(column_name,1,30)  ||'"',NULL)) ||
           			max(decode(column_position, 7,', '||'"'||
                  			substr(column_name,1,30)  ||'"',NULL)) ||
           			max(decode(column_position, 8,', '||'"'||
                  			substr(column_name,1,30)  ||'"',NULL)) ||
           			max(decode(column_position, 9,', '||'"'||
                  			substr(column_name,1,30)  ||'"',NULL)) ||
           			max(decode(column_position, 10,', '||'"'||
                  			substr(column_name,1,30)  ||'"',NULL)) col_list
           			from user_ind_columns 
           		group by  table_name, index_name ) col
	where  con.table_name = col.table_name  
	and con.col_list = substr(col.col_list, 1, length(con.col_list) ) ) )
  loop
  null;
  end loop;
end;

end mtl_erd_pkg;
/
