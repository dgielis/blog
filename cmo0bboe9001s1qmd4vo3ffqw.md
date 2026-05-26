---
title: "Setting Up Your APEX Developer Environment for the AI Era"
datePublished: 2026-04-15T17:16:46.787Z
cuid: cmo0bboe9001s1qmd4vo3ffqw
slug: setting-up-your-apex-developer-environment-for-the-ai-era
cover: https://cdn.hashnode.com/uploads/covers/62cf5116466c6ad9ff5d7d6e/1ebab7dd-7dc8-4eac-93fa-6f929a0a8680.png

---

In the [previous post](https://dgielis.com/the-apex-developer-reinvented) I talked about how the role of the Oracle APEX developer is changing. AI is changing how we write code, how we think about problems, and how fast we can move. But before we can show any of that in action, we need a proper setup.

My mentor in my early career, [Tom Kyte's, mantra](https://www.rittmanmead.com/blog/2005/04/tom-kyte-in-search-of-the-truth/) was, don't just believe what "experts" say, ask for proof. As things change so fast, especially with AI, it's important to test if things are still valid when you read this article.

So in this post I want to walk through the development environment I use today, which you can 100% reproduce and follow along on your own machine. It is a bit different than what I had back [in 2017](https://dgielis.blogspot.com/2017/08/from-idea-to-app-or-how-i-do-oracle.html), but it is also way more powerful.

Let me go through it step by step.

## The Editor: VS Code

I use **Visual Studio Code** as my main editor. It is free, fast, and has a huge ecosystem of extensions. For [Oracle APEX](https://apex.oracle.com) development, these are the extensions I have installed:

*   **Oracle SQL Developer Extension for VS Code** is the one I start with. It gives you database connections, SQL execution, object browsing, and a lot more, all from inside VS Code.
    
*   **dbLinter** helps you keep your SQL and PL/SQL clean. It catches issues early and helps you stay consistent across a project.
    
*   **QuickSQL Preview** is one of my favorites. If you have never heard of QuickSQL, it is a shorthand language developed by Oracle that lets you describe your data model in plain text and generate ready-to-run SQL from it. We at United Codes [forked it](https://github.com/United-Codes/quicksql) and made many enhancements to it. The VS Code extension gives you a live preview as you type and even a visual ERD. You can [download](https://github.com/dgielis/apex-developer-reinvented/blob/main/quicksql-preview-0.1.5.vsix) the open source version.
    
*   **Claude Code** and **Codex** as AI coding assistant. Both Claude and Codex are super good, and within [United Codes](https://www.united-codes.com) we use both (and even others). Pick one and continue.
    

## The Terminal

I use **iTerm2** on macOS. It supports split panes, profiles, and a lot of shortcuts that make life easier when you are switching between the AI Assistant, SQLcl, and Git all day.

## Claude Code CLI (or app)

**Claude Code** runs as a CLI and works directly in your terminal, in your project directory, with your files. It understands context, it can read your codebase, and it can take real actions.

You install it via npm:

```shell
npm install -g @anthropic-ai/claude-code
```

This is more than autocomplete. Claude Code can browse your files, run commands, write SQL, generate PL/SQL packages, create APEX export scripts, update GitLab issues, and a lot more. We will use it heavily throughout this series.

The most important file for Claude Code in any project is the **CLAUDE.md** file. I will do a dedicated post on that, but in short: it is a markdown file you put at the root of your project repo. It tells Claude Code what the project is about, what conventions to follow, what tools to use, and what not to do. Without a good CLAUDE.md, Claude Code is just a smart tool. With a good one, it becomes a real team member that knows your project. We will also add skills, basically other .md files, to Claude, which will give it specific knowledge about the Oracle database, APEX and our way of working.

## Codex CLI (or app)

An alternative to Claude is **Codex**. Similarly, Codex runs as a CLI and works directly in your terminal, in your project directory, with your files. It understands context, it can read your codebase, and it can take real actions.

You install it via npm:

```shell
npm install -g @openai/codex
```

Similary to Claude, you also have a file to define everything, in Codex this is the **AGENTS.md** file. Skills are also used to give Codex more specific knowledge.

## AI Skills for the Oracle Database and APEX

One thing I find really useful is the **oracle-db-skills** project by Kris Rice, which you find [here](https://github.com/krisrice/oracle-db-skills).

This is a curated library of 100+ practical guides covering Oracle Database topics, from SQL and PL/SQL development to security, migrations, and DevOps, organized into skill files by domain.

Another one not released yet, but foreseen by Oracle, are the APEXLang skills. APEXLang is the new format of an Oracle APEX app, which makes it much easier for any AI Assistant to produce APEX apps (APEXLang files).

With United Codes we also developed our own skills, for example we define our conventions, to always use utPLSQL to create PL/SQL tests, use the [dbLinter](https://github.com/Grisselbav/dbLinter/releases) CLI to check the code etc.

## Source Control

Use **GitLab** or **GitHub** for source control.

**GitHub Desktop** gives me a visual view of what has changed in my local repos. Even though I use GitLab/GitHub for the actual remote, GitHub Desktop works fine as a local Git GUI.

The **glab** CLI tool lets you interact with GitLab from the terminal: create issues, link commits, open merge requests, and more. This matters because the AI Assistant can use [glab](https://gitlab.com/gitlab-org/cli) to manage your project as part of its workflow. It creates issues when it finds something to fix, it links commits to issues, and it keeps your project board up to date.

## SQLcl

**SQLcl** is Oracle's command-line interface for the database. It is lightweight, scriptable, and supports Liquibase-based database change management out of the box through **SQLcl Projects**. I use it for everything from quick queries to deploying schema changes. Download [here](https://www.oracle.com/database/sqldeveloper/technologies/sqlcl/).

SQLcl Projects is how we manage database changes in a structured way. It tracks what has been applied, keeps your DDL in version control, and integrates nicely with CI/CD pipelines. Our AI assistant knows how to work with SQLcl, which makes this combination really powerful.

## Local Development Environment

For local development I run everything in **Docker**. My stack consists of two containers:

**Oracle Database 26ai** as I still believe this is the best database in the world, now with a lot of AI capabilities built in. Oracle provides a free Docker image. This local database syncs with the main DEV database (in the cloud).

**Oracle APEX + ORDS**. Having APEX local means I can develop (together with my AI agents) and test without depending on any shared environment. Fast feedback loop and no interference.

## Automation

**Jenkins** for automation. I use a Jenkins instance to run pipelines: schema deployments, test suites, etc. Jenkins connects to Git and triggers on push.

## Node.js and Playwright

**Node.js** is needed for a few things: installing the AI Assistant, running some tooling, and running **Playwright** for automated browser testing. Playwright lets you write tests that actually open a browser and interact with your APEX application. We will use this later in the series for end-to-end testing.

Install Node.js via: [https://nodejs.org](https://nodejs.org) or with Homebrew on macOS (`brew install node`).

## Browser

I use **Google Chrome** for testing APEX applications. A few extensions that help: a REST client for testing APIs, and the standard Chrome DevTools are already built in. Nothing exotic needed here.

## Voice

I really believe English is the new programming language.

I use **SuperWhisper**, which is a macOS app that lets you use your voice to type anywhere on your computer. It runs speech-to-text locally using AI models, so your audio stays private. I use it to dictate prompts for the AI Assistant, write commit messages, or talk through ideas without having to type everything out. It sits in the menu bar and activates with a keyboard shortcut, making it fast to switch between typing and speaking.

## Putting It All Together

I wanted to make it easy to setup your own environment, so on my [personal GitHub repo](https://github.com/dgielis/apex-developer-reinvented) I'm sharing quick starts.

If you have everything above installed and running, you are ready to follow along with the rest of this series, incase you wanted to experience this too.

## Note

I expect things will keep changing over the coming months, as the world of AI is changing fast. Either I will update this post or create follow-up posts and link to them once available.