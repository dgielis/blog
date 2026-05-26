---
title: "ORDS - SQL Developer Web: Fix Invalid credentials"
datePublished: 2023-11-22T18:42:03.994Z
cuid: clpa42ziy000308jx5kjz92l7
slug: ords-sql-developer-web-fix-invalid-credentials
cover: https://cdn.hashnode.com/res/hashnode/image/upload/v1700678434099/af6b3874-53e2-4bcc-a67a-c79269887b93.png
tags: ords

---

I had a weird issue with some Oracle database users I wanted to connect to in SQL Developer Web.

When I tried to log in at **https://hostname/ords/sql-developer**, I received the error: Invalid credentials: If your ORDS schema alias is different from your username, you can set it using the "Path" input in the "Advanced" options.

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1700668249944/37fea48d-7ae6-44b6-97c9-e5541f2d65e7.png align="center")

I also tried to log in at **https://hostname/ords/aop\_tst/sign-in/,** but then I got the error: Invalid credentials.

Finally, when I tried to log in at **https://hostname/ords/aop\_tst/\_sdw/?nav=worksheet** it worked for me.

In case it's still not working for you, it might help to close and re-open your browser, at least that worked for me.

Once I was successfully logged in, the next time I could log in directly at **https://hostname/ords/sql-developer** without any issues.

Note that this behavior was only for a couple of users. When I created a user like in the next script, it worked straight away.

```plaintext
create tablespace uc_dev datafile '/u01/oradata/CDB1/dev/uc_dev01.dbf' size 50M autoextend on next 50M maxsize unlimited default table compress for oltp index compress advanced high;

create user uc_dev identified by secret default tablespace uc_dev quota unlimited on uc_dev temporary tablespace temp;
  
grant connect to uc_dev;
grant create job to uc_dev;
grant create dimension to uc_dev;
grant create indextype to uc_dev;
grant create operator to uc_dev;
grant create type to uc_dev;
grant create materialized view to uc_dev;
grant create trigger to uc_dev;
grant create procedure to uc_dev;
grant create sequence to uc_dev;
grant create view to uc_dev;
grant create synonym to uc_dev;
grant create cluster to uc_dev;
grant create table to uc_dev;
grant create session to uc_dev;
grant execute on ctxsys.ctx_ddl to uc_dev;

begin
  ords_admin.enable_schema(p_schema => 'uc_dev');
end;
/
```

I couldn't identify a reason why for some database users it's not working straight away, but hope that this workaround helps you too, when you encounter the same error.