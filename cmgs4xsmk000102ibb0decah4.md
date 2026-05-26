---
title: "Oracle APEX 25.1 and beyond"
datePublished: 2025-10-15T15:17:55.628Z
cuid: cmgs4xsmk000102ibb0decah4
slug: oracle-apex-251-and-beyond
cover: https://cdn.hashnode.com/res/hashnode/image/upload/v1760537029896/d8e3b7ac-d010-414a-adae-e7317f0f10a2.png
tags: oracle, database, orclapex

---

Since Oracle has been quiet about the new release of [Oracle APEX](https://apex.oracle.com), the community has wondered what happened to the next release. I thought it would be helpful to write about what I know for [Joel Kallman Day](https://oracle-base.com/blog/2025/09/24/joel-kallman-day-2025-announcement/).

In recent years, Oracle has released two versions of APEX annually, typically in April and October. However, starting with Oracle APEX 24.2, the release schedule slipped slightly, and 24.2 was released early in 2025. There has been no new 25 release yet.

Why no release? From what I understand, the next version of Oracle APEX will introduce an entirely new way of developing Oracle APEX apps using AI, but that will take time. I expect that there won’t be a new release this year, but that Oracle will do the next release early next year. I even think it will be called Oracle APEX 26.1, in line with the new [Oracle AI Database 26ai](https://www.oracle.com/database/26ai/) version.

At the [KScope](https://www.odtug.com/kscope25) conference in June, Oracle provided us with insight into what is coming.

The next version of Oracle APEX is built around five key themes:

* Generative Development and Al
    
* User Experience
    
* Developer Experience
    
* Enterprise Readiness
    
* Community Ideas
    

## GenDev & AI

The use of AI is evident in all facets of Oracle APEX, from development to the features we offer to the users of the applications we build.

### APEX AI Application Generator

There will be an entirely new way of building your APEX apps, simply by describing how you want your APEX app to function. This is made possible by introducing a new open application specification, called APEXlang. Here’s a screenshot of the announcement by Juan Loaiza in his [keynote](https://x.com/i/broadcasts/1dRKZaVknrwxB) at Oracle AI World.

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1760537820579/e6039792-8381-480d-b6cb-156f8d53ef8e.png align="center")

### APEXlang

APEXlang looks like a combination of YAML and JSON. Your entire Oracle APEX app can be built using a text (APEXlang) file. For example, you can add a region name, title, type, and SQL, and everything else will use the default. If you define something in the text file, it will overwrite the default. This APEXlang file will be used to generate your APEX app.

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1760537914856/41f3ba29-8e04-4578-a9b3-100baef6fe55.png align="center")

The benefits of the APEXlang file extend far beyond AI. Martin D’Souza presented APEXlang at KScope and demonstrated what it can do. Here’s a screenshot of one of his slides:

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1760538219036/37e7c7c2-602f-4755-8fef-5d0b94f7af83.png align="center")

An APEX export file, in the APEXlang format, is human-readable and is easily version-controlled. It allows you to make bulk changes straight in the text file by easy search/replace. This will open a whole new way of doing development with APEX. I envision myself building the initial version of the app using AI and describing what I want. It will generate the text file, which will then be used to generate the APEX app (metadata). I can make changes in the browser (Low-Code) and continue this way. If I need to bulk update something at some point, I can export the app, modify the exported APEXlang file, and redeploy the new version. I might even develop primarily text-based solutions in VS Code and let APEX deploy the latest version repeatedly. Doing text-based development also allows merging multiple developers' changes, etc.

### AI Tools

We can also make our APEX apps smarter using AI tools (functions). Before, you would give all your data to the AI (LLM), and you could ask questions. This wasn’t particularly performant, as you had to send a large amount of data across. The better approach is to use AI Tools, letting AI know how to obtain the information it needs. Here’s an example:

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1760538746171/0672fd3c-8f29-43bf-87d2-123c1b41fd58.png align="center")

And a screenshot of how it is configured in the APEX builder:

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1760538853315/e789a4df-5f88-4ede-abed-01fe5570bfcc.png align="center")

Note that if you want to utilize AI today, we at United Codes have created a [UC AI package](https://www.united-codes.com/ai/) that can help you significantly.

### AI in Interactive Reports

Another notable feature in the next version of Oracle APEX is the integration of AI into Interactive Reports. You can ask questions in natural language to your Interactive Report, and it will add filters on the fly for you, perform breaks, etc.

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1760539131215/48680f0e-a622-4e6b-859d-425489ff3bcf.png align="center")

It can even create charts, or you can have a chat with your IR data, and a chat panel opens on the right where you can delve deeper into your data.

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1760538962150/a39c1ba7-7daf-4a21-a6cb-8101112a5a30.png align="center")

## User Experience

A new version of Universal Theme is currently in development. Not sure if it will make the next version of Oracle APEX, but I hope so :) A fresh new look & feel would be fantastic.

This new theme will also enable new mobile features.

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1760540984748/4ae055bf-ad03-4642-b1a8-f4b36e154b36.png align="center")

## Developer Experience

There are new features to make our lives as developers easier. There will be built-in live checks, much like what we offer with our QA Assistant in [APEX Project Eye](https://www.united-codes.com/products/apexprojecteye/) (APE).

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1760539924704/e5e0b424-5b92-4dcb-ad6c-79402ef04ee3.png align="center")

Here’s a screenshot of how the new Advisor looks when an error occurs:

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1760539908638/265dae57-573d-4be7-b06f-6339e03ca92e.png align="center")

Having errors and checks directly in the builder is beneficial; more importantly, you can mark exceptions for false positives.

At [United Codes](https://www.united-codes.com), we place a strong emphasis on developer experience. If you haven’t checked out [APEX Project Eye](https://www.united-codes.com/products/apexprojecteye/) yet, I strongly advise you to check it out! It provides significant insights into your APEX apps, while also aiding in their development, maintenance, and monitoring.

## Enterprise Readiness

Oracle is using APEX itself extensively to rebuild the Cerner healthcare applications. Huge teams are building now apps using Oracle APEX. To make the apps consistent and easy for developers to share and reuse, a new section has been added to APEX called Pattern Pages and a Global Repository.

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1760539495539/22f3628d-ff35-4570-8a46-4c7cdfe95d79.png align="center")

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1760539676366/aaf0a705-b2a5-4132-8bec-956b5343c311.png align="center")

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1760539679861/2bb0a2e2-5e6c-4732-9474-947808408a93.png align="center")

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1760539684597/56fb9793-f419-4623-92c7-7994f009aa6b.png align="center")

We will explore why more features are being developed for large teams, as Oracle also requires this functionality.

### Community Ideas

Finally, many new features were added that were submitted by the community through the [APEX Ideas](https://apexapps.oracle.com/pls/apex/r/apex_pm/ideas/home) app.

If you want APEX to do something, submit it there, and the APEX team might pick it up in the future!  
If you can’t wait till the next version of APEX, you can always let us know, too. With our Oracle APEX [Plug-ins Pro](https://www.united-codes.com/products/plug-ins-pro/) offering, we are extending APEX while supporting and maintaining it.

Hopefully, this post provides you with some insight into what's to come. Oracle mentioned these things at APEX conferences, but hasn’t been very public about it. You can also refer to the [APEX Roadmap](https://apex.oracle.com/roadmap/), which is the official Oracle page that outlines upcoming features.