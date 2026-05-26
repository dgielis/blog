---
title: "Oracle Database 26ai Assertions in a World Cup Betting App"
datePublished: 2026-03-14T08:00:00.000Z
cuid: cmms9bnzc016c2ehde3yz9tgz
slug: oracle-database-26ai-assertions-in-a-world-cup-betting-app
cover: https://cdn.hashnode.com/uploads/covers/62cf5116466c6ad9ff5d7d6e/9b9358e7-e67e-4138-b0d3-30e69f3c736d.jpg

---

Recently I was playing again with my World Cup betting application, originally built in 2006 with Oracle APEX. Yes… almost 20 years ago already! 😅

Back then the database enforced some constraints, but many rules lived in the application layer (read APEX validation, processes, and PL/SQL). That was normal at the time.

But with Oracle Database 26ai and Assertions (introduced in 23.26.1) we can finally do something really nice:

**Write complex business rules directly in the database using SQL.**

No triggers.  
No application checks.  
Just declarative SQL.

I absolutely love this direction.

If you are new to assertions, check the official docs here:

*   [https://docs.oracle.com/en/database/oracle/oracle-database/26/sqlrf/create-assertion.html](https://docs.oracle.com/en/database/oracle/oracle-database/26/sqlrf/create-assertion.html)
    
*   [https://docs.oracle.com/en/database/oracle/oracle-database/26/cncpt/data-integrity.html#GUID-F87D5640-EACA-43EA-9ACA-8BFAA5C6E8B0](https://docs.oracle.com/en/database/oracle/oracle-database/26/cncpt/data-integrity.html#GUID-F87D5640-EACA-43EA-9ACA-8BFAA5C6E8B0)
    

And a great blog post from the Oracle SQL team:  
[https://blogs.oracle.com/sql/how-to-define-cross-table-constraints-with-assertions-in-oracle-ai-database](https://blogs.oracle.com/sql/how-to-define-cross-table-constraints-with-assertions-in-oracle-ai-database)

But instead of theory, I like **real problems**.

So let's look at a fun one.

## The Problem: Prevent “Impossible Bets”

In the World Cup betting app, users predict match results.

The tables look like this:

`W14_MATCH` contains the official match info.  
`W14_BET` contains the user's prediction.

Example:

| Match | Prediction |
| --- | --- |
| Brazil vs Germany | 2-1 |
| Spain vs France | 0-0 |

Pretty simple.

But knockout matches introduce an interesting problem. A knockout match cannot end in a draw. If the regular score is equal, the winner is decided by extra penalties.

Our table supports this:

```plaintext
HOME_SCORE
VISIT_SCORE
HOME_EXTRA_PENALTIES
VISIT_EXTRA_PENALTIES
```

So a valid knockout bet could be:

```plaintext
2 - 2
Penalties: 5 - 4
```

But what should never happen is this:

```plaintext
2 - 2
Penalties: NULL - NULL
```

That means no winner.

And even worse:

```plaintext
2 - 2
Penalties: 3 - 3
```

Also impossible.

Until now this kind of rule normally lived in:

*   application validations
    
*   triggers
    
*   complex PL/SQL
    

But now we can express it **as a single SQL rule**.

## The Assertion Solution

Let's define the rule:

> If a bet predicts a draw, then the penalties must exist and produce a winner.

This involves **multiple columns and conditional logic**.

Perfect use case for an **assertion**.

### Step 1. Create the Assertion

```plaintext
CREATE ASSERTION bet_knockout_must_have_winner
CHECK (
  ALL (
    SELECT b.home_score, b.visit_score,
           b.home_extra_penalties, b.visit_extra_penalties
    FROM w14_bet b
    WHERE b.home_score = b.visit_score
  ) b
  SATISFY (
    b.home_extra_penalties IS NOT NULL
    AND b.visit_extra_penalties IS NOT NULL
    AND b.home_extra_penalties <> b.visit_extra_penalties
  )
);
```

What does this do?

The assertion ensures that no row exists where:

1.  The predicted score is a draw
    
2.  AND penalties are missing or tied
    

If such a row appears, the database rejects the transaction.

Simple. Clear. Declarative.

### Step 2. Let's Test It

Valid Bet

```plaintext
INSERT INTO w14_bet
(ID, USER_ID, MATCH_ID, HOME_SCORE, VISIT_SCORE,
 HOME_EXTRA_PENALTIES, VISIT_EXTRA_PENALTIES,
 CREATED_BY, CREATED_DATE)
VALUES
(1, 10, 5, 2, 2, 5, 4, 'DIMITRI', SYSDATE);
```

Result:

```plaintext
1 row inserted.
```

Good.

Now an invalid bet.

```plaintext
INSERT INTO w14_bet
(ID, USER_ID, MATCH_ID, HOME_SCORE, VISIT_SCORE,
 HOME_EXTRA_PENALTIES, VISIT_EXTRA_PENALTIES,
 CREATED_BY, CREATED_DATE)
VALUES
(2, 10, 5, 2, 2, NULL, NULL, 'DIMITRI', SYSDATE);
```

Result:

```plaintext
SQL Error: ORA-08601: SQL assertion (BET_KNOCKOUT_MUST_HAVE_WINNER) violated.
Help: https://docs.oracle.com/error-help/db/ora-08601/

More Details :
https://docs.oracle.com/error-help/db/ora-08601/
```

Exactly what we want. The **database protects the integrity of the data**.

## Why This Matters

This might look like a small rule, but in real systems things get complicated quickly.

Think about rules like:

*   A building cannot consume more power than the grid supplies
    
*   A hospital cannot schedule more patients than rooms available
    
*   A betting pool must have exactly one winner per match
    
*   A smart city cannot exceed environmental limits
    

These rules often span **multiple tables or conditional logic**.

Before assertions we had to rely on:

*   triggers
    
*   application validations
    
*   batch data cleanup
    

Now we can express them as **true data integrity rules**.

Readable SQL. Centralized. Guaranteed.

I really like that.

## Why I Love This Feature

Assertions make the database smarter.

And honestly, the **Oracle Database has always been the best place for business rules**.

We are just getting better tools to express them.

When I look back at the APEX app I built in 2006, many rules were in PL/SQL and page validations. If I would rebuild it today, a lot of that logic would move to assertions.

Cleaner architecture. Safer data. Less code. And that is always a good thing.

If you haven't played with Assertions in Oracle Database 26ai, go and try them out.  
If you don't have a local DB and you want to try it, [Oracle FreeSQL](https://freesql.com/) is very cool:

(note: at the time of writing the environment of FreeSQL was still 23.26, while you need 23.26.1 to get assertions to work)