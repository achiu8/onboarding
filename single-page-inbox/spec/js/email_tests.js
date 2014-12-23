QUnit.module("Email#updateProperties");

QUnit.test("sets id, from, and subject from raw data", function(assert) {
  var emailData = {
    id: 1,
    from: 'sender',
    subject: 'subject'
  };

  var email = new Email(emailData);
  assert.equal(email.id, emailData.id);
  assert.equal(email.from, emailData.from);
  assert.equal(email.subject, emailData.subject);
});

QUnit.test("sets read status based on read boolean", function(assert) {
  var emailData = { read: true };
  var email = new Email(emailData);
  assert.equal(email.read, "Read");
});

QUnit.test("creates new date from string", function(assert) {
  var emailData = { created_at: '2014-12-17T22:03:19.282Z' };
  var email = new Email(emailData);
  assert.equal(email.date.toString(), new Date(emailData.created_at).toString());
});

QUnit.test("creates formatted date property from string", function(assert) {
  var emailData = { created_at: '2014-12-17T22:03:19.282Z' };
  var email = new Email(emailData);
  assert.equal(email.formattedDate, "December 17");
});

QUnit.test("sets body to null on instantiation", function(assert) {
  var email = new Email({});
  assert.equal(email.body, null);
});

QUnit.test("sets body to body on update", function(assert) {
  var email = new Email({});
  var emailData = { body: 'body' };
  email.updateProperties(emailData);
  assert.equal(email.body, emailData.body);
});

QUnit.module("Email#formatDate");

QUnit.test("formats date to show month and date", function(assert) {
  var email = new Email({});
  var date = new Date("December 17, 2014");
  assert.equal(email.formatDate(date), "December 17");
});
