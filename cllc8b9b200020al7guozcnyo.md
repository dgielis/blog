---
title: "Compare 2 Oracle APEX pages"
datePublished: 2023-08-15T11:37:11.390Z
cuid: cllc8b9b200020al7guozcnyo
slug: compare-2-oracle-apex-pages
cover: https://cdn.hashnode.com/res/hashnode/image/upload/v1692097985437/587ef65b-03c0-478d-a4f1-a1641b2994c6.png
tags: compare, oracle-apex

---

I wanted to know if a page was the same within the same application.

Two (+1 in Oracle APEX 22.1+) features in Oracle APEX help to compare pages, which you find under the tools menu: Checksum and Export:

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1692098515909/0dd40db4-ad7f-4a22-8b65-9eff2ad069ab.png align="center")

The checksum will show the **checksum** of the page. This feature works great when you want to compare the same pages in different applications. In case the page number is different, the checksum will be different, so this feature won't help to compare different pages within the same application.

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1692098544872/eee4ae7e-8803-4f3b-999f-3a269feb5668.png align="center")

The **page export** feature works better if you want to compare pages inside the same application.

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1692098554980/06192756-8b17-426c-a84e-02b666147e9f.png align="center")

Exporting a page generates a SQL file. I then compare both SQL files in Visual Studio Code. Some ids will be different, but you can ignore those. For me, this technique works well to quickly identify differences between the two pages.

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1692098563640/e90d3f61-4ac6-4889-aab8-e73a517b326e.png align="center")

It would have been even easier if the Oracle APEX team provided the option to export the page in a **readable format**, but this feature is only available when you export the entire application (Oracle APEX 22.1 and above).

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1692100818729/f1e02752-0d1f-4727-bbaa-7b79a7e2ac89.png align="center")

When exporting in a readable format, you will get a zip file that contains a readable folder. In there, you find the pages in a JSON format.

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1692101128980/22aba95c-be15-4d41-a153-abd71df06cff.png align="center")

Now you can **compare the JSON files** (just like we compared the SQL files before), but this time it's a bit more readable.

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1692101136919/fa5abc87-f107-4950-a20a-ae9c4bd90e90.png align="center")

In case you want to **compare entire applications**, you can use the application checksum feature which you find in the Utilities section of your Oracle APEX app.

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1692099357559/9aa5e9df-47c2-4be4-b91b-5f5cdcce60e9.png align="center")