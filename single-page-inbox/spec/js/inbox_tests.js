QUnit.module("Inbox#error");

QUnit.test("triggers error event", function(assert) {
  var inbox = new Inbox();
  $(inbox).on('error', function() { assert.ok(true); });
  inbox.error();
});

QUnit.module("Inbox#fatal");

QUnit.test("triggers fatal event", function(assert) {
  var inbox = new Inbox();
  $(inbox).on('fatal', function() { assert.ok(true); });
  inbox.fatal();
});

QUnit.module("Inbox#toEmail");

QUnit.test("returns an array of Email objects from data", function(assert) {
  var inbox = new Inbox();
  var response = { email: [{ id: 1 }] }
  var emails = inbox.toEmail(response);
  var empty = inbox.toEmail({ email: [] });
  assert.equal(emails[0].id, new Email(response.email[0]).id);
  assert.equal(empty.length, 0);
});

QUnit.module("Inbox#selectNew");

QUnit.test("returns an array of new emails", function(assert) {
  var inbox = new Inbox();
  var email = new Email({ id: 1 });
  inbox.emails = [email];
  var newEmails = inbox.selectNew(inbox.emails);
  assert.equal(newEmails.length, 0);

  var newEmail = new Email({ id: 2 });
  newEmails = inbox.selectNew([newEmail]);
  assert.equal(newEmails[0], newEmail);
});

QUnit.module("Inbox#updateInbox");

QUnit.test("adds new emails to existing collection", function(assert) {
  var inbox = new Inbox();
  var email = new Email({ id: 1 });
  inbox.emails = [email];
  var newEmail = new Email({ id: 2 });
  var newEmails = [newEmail];
  inbox.updateInbox(newEmails);
  assert.ok(inbox.emails.indexOf(email) > -1);
  assert.ok(inbox.emails.indexOf(newEmail) > -1);
});

QUnit.module("Inbox#handleResponseError");

QUnit.test("returns response if no error", function(assert) {
  var inbox = new Inbox();
  var response = { error: false };
  assert.equal(inbox.handleResponseError(response), response);
});

QUnit.test("returns rejected deferred object if error", function(assert) {
  var inbox = new Inbox();
  var response = { error: true };
  var deferred = $.Deferred();
  var returned = deferred.then(inbox.handleResponseError);
  deferred.reject(response);
  returned.fail(function() { assert.ok(true); });
});

QUnit.module("Inbox#setLabels");

QUnit.test("sets labels for and returns collection of emails", function(assert) {
  var inbox = new Inbox();
  var email = new Email({ id: 1 });
  var emails = [email];
  var labels = [1, 2];
  var response = { labels: { 1: labels } };
  var labeledEmails = inbox.setLabels(emails, response);
  assert.equal(labeledEmails[0].labels, labels);
});

QUnit.module("Inbox#isNew");

QUnit.test("returns true if email is new", function(assert) {
  var inbox = new Inbox();
  inbox.emails = [new Email({ id: 1 })];
  assert.equal(inbox.isNew(2), true);
});

QUnit.test("returns false if email is not new", function(assert) {
  var inbox = new Inbox();
  inbox.emails = [new Email({ id: 1 })];
  assert.equal(inbox.isNew(1), false);
});

QUnit.module("Inbox#updateEmail");

QUnit.test("updates and returns email based on data", function(assert) {
  var inbox = new Inbox();
  var email = new Email({ id: 1 });
  inbox.emails = [email];
  var response = { email: { id: 1, from: 'test' } };
  var updated = inbox.updateEmail(response);
  email.from = 'test';
  assert.equal(updated, email);
});
