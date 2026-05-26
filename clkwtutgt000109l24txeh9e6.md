---
title: "The application alias "X" can not be converted to a unique application ID."
datePublished: 2023-08-04T16:55:57.101Z
cuid: clkwtutgt000109l24txeh9e6
slug: the-application-alias-x-can-not-be-converted-to-a-unique-application-id
tags: oracle-apex

---

You get this error when two or more Oracle APEX applications have the same alias.

When you import the sample application in the same workspace and give it a different ID, the alias is changed automatically so it's unique. However when you import an application in a different workspace, the alias is not being replaced by a unique value, which might result in the error: "The application alias "X" can not be converted to a unique application ID."

There's an easy way to find where those applications are with the same alias by running the following query (as a DBA or a user with the APEX\_ADMINISTRATOR\_ROLE):

```sql
select workspace, application_id, application_name
  from apex_applications
 where alias = 'X'
```

This will give you the workspace, application id, and application name with the specific alias.