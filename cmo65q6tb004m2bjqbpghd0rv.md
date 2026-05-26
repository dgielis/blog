---
title: "Gathering requirements"
datePublished: 2026-04-19T19:26:43.202Z
cuid: cmo65q6tb004m2bjqbpghd0rv
slug: gathering-requirements
cover: https://cdn.hashnode.com/uploads/covers/62cf5116466c6ad9ff5d7d6e/22ab83d2-89e6-40fb-8b61-30293e21b151.png
tags: orclapex

---

I had a conversation with AI about the World Cup 2026 app.

I didn't type. I used my voice. Six conversations later, I had a requirements document with features I would never have thought of alone.

That's the short version of this post.

## Why requirements are the hard part

As developers, we can only design great systems that give real business value when we truly understand the business.

As a consultant I read documents, review schemas, and do interviews to understand where technology can help. If you're not familiar with the industry, it takes time to see where you can add value.

This is where AI really helps.

Even without prior knowledge, you can ask AI to brainstorm with you. Feed it all your documents and let it challenge the requirements. You can even give it drawings, pictures, anything really.

Then have a conversation, just using your voice.

I also try to look at it from different angles. Who are the stakeholders? The business, the end users, sometimes management. They all want different things. What the business wants is not always what the end user expects.

And I ask AI to think about edge cases too. What can go wrong? What happens with bad or missing data?

## The World Cup 2026 app

In my case I already knew what I wanted. My friends and I want to predict the scores of the games. We want to see who's leading, be part of a team, and see how our team compares to others.

But I still decided to talk to AI, to see what else it would suggest.

I started with Claude. It came up with many ideas. Then I kept asking **"what else are we missing?"** which made the AI think harder and come up with improvements I hadn't thought about.

A good tip: also think about what success looks like. Describe the **intent** (an app to predict games), the **constraints** (100 USD budget), and how you will **validate** the result.

When I had a first version of the requirements document, I gave it to ChatGPT with the following prompt:

> *"Review the requirements document of an application where my friends and I can predict the games of the World Cup 2026. Check if something was forgotten. Tell me which other features are interesting to add. Note that only features can be added that an AI can code and where the system is 100% autonomous. Create the final requirements document in markdown format."*

This is a nice trick. You let two different AIs ping-pong on the requirements. ChatGPT and Claude each see different things.

## Six rounds of refinement

I refined the requirements six times. AI came up with features I didn't have on my list at all. A few that stuck:

*   **Rival Mode**: every user can nominate one rival per group and see a mini head-to-head leaderboard. Much more fun than just a global ranking.
    
*   **What-If Simulator**: enter hypothetical results for the remaining matches and see where you would end up.
    
*   **AI Coach**: a weekly summary of each user's prediction patterns (team bias, risk profile, notable misses).
    
*   **Joker Recommendation**: once per stage the AI suggests which match to double up on, based on your accuracy history.
    

None of these were in my original brain-dump. Some I would probably not think about myself.

AI gives a lot of ideas, but not everything is needed. I try to keep it simple and focus on what brings the most value first.

Remember, you don't have to define everything in the spec. Whatever you leave out, the AI will guess. If you prefer to know up-front what you will get, spend a bit more time on the spec. Otherwise the AI will ask you later, or build something it thinks is good, but you actually don't like.

The look and feel of the app is also part of the requirements. In a company you typically have a brand book or design guidelines. I don't really have that, so I asked AI to add a design section to the requirements document too: fonts, colours, tone, component style.

While defining requirements, I already start thinking about the data behind it. What do we need to store? What is the source of truth? That's for the next post.

## Freeze the requirements

At some point you stop. The requirements document becomes the contract. No coding yet, maybe just a final pass to find ambiguities or contradictions.

You can find my final requirements document for the World Cup 2026 app here: [worldcup2026\_prediction\_app\_requirements\_6.md](https://github.com/dgielis/apex-developer-reinvented/blob/main/worldcup2026_prediction_app_requirements_6.md).

## From requirements to shipping

Once the requirements are frozen, the actual building starts. Here's the pattern I use for everything that follows, and you'll see it in every post in this series.

Instead of letting AI build everything in one go, we break the process into clear steps. AI does the heavy lifting, and I validate at every stage.

![](https://cdn.hashnode.com/uploads/covers/62cf5116466c6ad9ff5d7d6e/9a953ebb-b787-4999-8813-0295d06f848b.png align="center")

Every AI step is followed by a human review. That is the key.

I call this keeping the human in the loop. Instead of trusting AI blindly, you guide it, correct it, and make decisions at every important step.

In practice, it also makes development faster, not slower. Because mistakes are caught early, not at the end.

In the next post we'll go from these requirements to the data model 😁