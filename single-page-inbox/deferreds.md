# Deferreds

jQuery's [implementation](http://api.jquery.com/category/deferred-object/) of the "Deferred" or [Promise](http://en.wikipedia.org/wiki/Futures_and_promises) pattern is a powerful tool for dealing with asynchronous code.

The "Deferred" pattern describes an object which represents some unit of computation that _may or may not_ have completed. An AJAX request is just such an example of a "unit of delayed computation", we know something _will_ happen but we don't know _when_. A deferred object lets us represent this idea in code.

In their simplest form, Deferreds allow you to specify what will occur when a computation completes or fails. jQuery's specific implementation allows you to register callback functions that will run if a Deferred resolves successfully, or if it is rejected with errors.

```js
var df = new $.Deferred;

df.done(function(){ console.log("Success") });
df.fail(function(){ console.log("Failure") });

//df.resolve() would trigger the "Success" callback
//df.reject() would trigger the "Failure" callback
```

You've probably been using deferreds already. jQuery's AJAX methods return a deferred. They resolve when the AJAX request succeeds, and are rejected if the HTTP request fails.

## A Timeless Pattern

An AJAX call, because it is asynchronous, can't just "return a value".

```js
//Nope :(
var myEmails = $.get('/inbox/matt@devbootcamp.com');
```

We have to wait for the response to come back and access the value in some other way, like a callback.

```js
var myEmails;

$.get('/inbox/matt@devbootcamp.com', function(emails) {
  myEmails = emails;
});

```

That means we don't get the luxury of passing variables from an AJAX call around, or accepting them as arguments. For example, this won't work:

```js
function getEmails() {
  return $.get('/inbox/matt@devbootcamp.com');
}

function printEmails(emails) {
  emails.forEach(function(email) {
    console.log(email)
  })
}

function renderEmails(emails) {
  emails.forEach(function(email) {
    $("body").append("<p>"+email.body+"</p>")
  })
}

//Nope, not even close :(
emails = getEmails()
printEmails(emails);
renderEmails(emails);
```

We have to use callbacks there instead

```js
function getEmails(callback) {
  return $.get('/inbox/matt@devbootcamp.com', callback);
}

function printEmails(emails) {
  emails.forEach(function(email) {
    console.log(email)
  })
}

function renderEmails(emails) {
  emails.forEach(function(email) {
    $("body").append("<p>"+email.body+"</p>")
  })
}

getEmails(function(emails) {
  /* This could get pretty long */
  printEmails(emails);
  renderEmails(emails);
})
```

Deferreds can help. They allow you to pass some concept of a "future result" around like its the value itself. Consider this:

```js
function getEmails() {
  return $.get('/inbox/matt@devbootcamp.com';
}

function printEmails(response) {
  response.done(function(emails) {
    emails.forEach(function(email) {
      console.log(email);
    })
  })
}

function renderEmails(response) {
  response.done(function(emails) {
    emails.forEach(function(email) {
      $("body").append("<p>"+email.body+"</p>")
    })
  })
}

var response = getEmails(); //emails is a deferred object
printEmails(response);
renderEmails(response);
```

See? We're nearly back to our old synchronous, imperative style of programming. True, we don't know _when_ the email response will come back, but we can pass around an object that keeps track of a list of things that should happen when it _does_. Deferreds help abstract away the "when" of your asynchronous processes.


### What if it's already resolved?

Callbacks registered with a deferred that is already resolved or rejected will run immediately. You don't need to worry if the asynchronous unit of computation (e.g. an AJAX request) is finished or not. Simply bind a callback to the deferred and it will either run if the deferred is already resolved, or run when the deferred is resolved in the future.


## Transformations with .then()

jQuery's Deferred API offers a method called "`then()`", and it's one of the more powerful tools available to you

`then()` allows you to apply a transformation (jQuery calls them "filters") to the result of a deferred. `then()` will produce a _new_ deferred whose `done` and `fail` callbacks will receive data filtered through the functions you provide to `then`.

You can use `then` to transform values:

```js
var df = $.Deferred();
var triple = df.then(function(num) { return num * 3 })

df.done(function(num) { console.log(num)})
triple.done(function(num) { console.log(num)})

df.resolve(2);
//Logs "2"
triple.resolve(2);
//Logs "6"
```

You can also use `then()` to return new deferreds, or change a Deferred's resolved/rejected status:

```js
var df = $.Deferred();
var failOnOdds = df.then(function(num) {
  if num % 2 != 0 {
    return $.Deferred().reject(num); //return a rejected deferred
  } else {
    return num;
  }
})

df.done(function(num){console.log(num)})
df.fail(function(num){console.log("failure")})

failOnOdds.done(function(num){console.log(num)})
failOnOdds.fail(function(num){console.log("failure")})

df.resolve(3);
//Logs "3"

failOnOdds.reject(3);
//Logs "Failure"

```

Chaining together successive calls to `then` allow you to form pipelines through which asynchronous data should flow. This can be an incredibly effective tool for organizing your async code.

## Synchronizing asynchronous events with when()

It's not uncommon to require data from two separate AJAX requests, our client-side app might need the data from both requests before it can render itself.

In the example below, a user's data and a user's picture are pulled via two different requests.

```js
$.get('/people/matt').done(function(person) {
  $.get('/pictures/matt').done(function(picture) {
    person.picture = picture;
    console.log(person);
  })
  .fail(function() {
    console.log("error!")
  })

})
.fail(function() {
  console.log("error!")
})
```

We're forced to nest callbacks to ensure both requests have finished before rendering. Furthermore, we have two different places to specify error handling since either request could fail. Is there a better way?

### $.when

`$.when()` is a utility provided by jQuery that accepts one or more deferreds and produces a new deferred that will only resolve when all the original deferreds have resolved individually. This allows you to combine multiple asynchronous events into one.

```js
var person = $.post('/people/matt');
var picture = $.post('/pictures/matt');

$.when(person, picture)
  .done(function (personResponse, pictureResponse) {
    var p = personResponse[0];
    p.picture = pictureResponse[0];
    console.log(p);
  })
  .fail(function () {
    console.log("Failure")
  });

```

## More Resources

 * [Using Deferreds in caching](http://msdn.microsoft.com/en-us/magazine/gg723713.aspx)
 * [A More Expressive setTimeout()](http://www.intridea.com/blog/2011/2/8/fun-with-jquery-deferred)
 * [Additional examples of jQuery's Deferred API](http://joseoncode.com/2011/09/26/a-walkthrough-jquery-deferred-and-promise/) (_Note: pipe() was deprecated in favor of then())_
 * [The jQuery Deferred Object API reference](http://api.jquery.com/category/deferred-object/)
