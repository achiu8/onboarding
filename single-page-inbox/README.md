# DBC Inbox

In this challenge you'll build the first few features of a simple client-side inbox. You'll have to invest time in code organization and testing, as well as handle some less trivial asynchronous situations.

Your Javascript should follow a rough MVC pattern.

## The API Server

You'll find that this Sinatra application provides several API endpoints in the controller. This is your API. You cannot alter the server-side code, we want to simulate being stuck with a not-always-ideal API design.

## Chaos Monkey

Like any service-oriented backend, there's always the potential for failure.

All service calls in the backend can fail randomly, so you'll need to have good error handling. Make sure errors are well communicated to the user. In some cases, you may need to account for failures and respond (for example, retrying).

## Testing

Once again, we'll use QUnit to test our code. The server-side should be well tested already.

## Higher-order Functions

Use [higher order functions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array) (e.g. functions that take functions) whenever possible.

## Release 1, Inbox

Build a page for the user's inbox (`/inbox/matt.baker@example.com`). On page load, your code should provide a listing of all emails in the user's inbox with a proper "read" status, subject and well formatted date.

What should happen if the query fails?

## Release 2, Labels

You have your inbox displaying, but it should also include the labels attached to each email.

Update your code to include the color-coded labels for each email you display. The emails should display _with_ the labels. In other words, the labels should not appear after the initial rendering.

How will you ensure that your emails aren't rendered before the labels are attached?

What should happen if the email list query succeeds, but the labels do not?

## Release 3, Polling

Your users are receiving new emails all the time (every 5 seconds to be precise). Make sure your inbox displays new emails as they come in.

## Release 3, Read an Email

Users can see their inbox, but they can't actually read their email. Create a way for users to click on a subject and see the message. This action will also need to mark the email as read.

What should happen if the "fetch email" query fails?

What should happen if the "mark read" query fails?

## Release 4, Add and Remove Labels

Add the ability to add or remove a label from an email. Again, you'll need to consider error handling.

## Release 5, Promises, Promises

Deferreds are a powerful pattern that can be applied to asynchronous code.

First, [Read up](deferreds.md) on jQuery's implementation of the Deferred pattern.

Eliminate any use of the old `$.get(url, callback)` (or similar) form in favor of deferreds in your code. This should be a simple refactor.

Apply what you've learned about Deferreds, including the proper use of `then()`, to aggressively refactor and simplify your client-side code.
