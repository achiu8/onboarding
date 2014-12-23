function Inbox() {
  this.user = window.location.pathname.split('/')[2];
  this.emails = [];
  this.startEmailStream();
}

Inbox.prototype.startEmailStream = function() {
  var emailStream = new Stream('/user/' + this.user + '/emails', 1000).stream;

  emailStream
    .then(null, null, this.toEmail.bind(this))
    .then(null, null, this.selectNew.bind(this))
    .then(null, null, this.attachLabels.bind(this))
    .progress(this.updateInbox.bind(this))
    .progress(this.broadcastUpdate.bind(this))
    .fail(this.fatal.bind(this));
};

Inbox.prototype.toEmail = function(response) {
  return response.email.map(function(e) { return new Email(e) });
};

Inbox.prototype.selectNew = function(emails) {
  return emails.filter(function(e) { return this.isNew(e.id); }.bind(this));
};

Inbox.prototype.attachLabels = function(emails) {
  var emailIds = emails.map(function(e) { return e.id; });
  var defGet = $.Deferred();
  $.get('/emails/labels', { emails: emailIds.join(",") })
    .then(this.handleResponseError)
    .then(this.setLabels.bind(this, emails))
    .fail(this.error.bind(this))
    .done(defGet.notify);
  return defGet;
};

Inbox.prototype.updateInbox = function(newEmails) {
  $.merge(this.emails, newEmails);
}

Inbox.prototype.broadcastUpdate = function(response) {
  $(this).trigger('update', [response]);
};

Inbox.prototype.fatal = function() {
  $(this).trigger('fatal');
}

Inbox.prototype.error = function() {
  $(this).trigger('error');
}

Inbox.prototype.handleResponseError = function(response) {
  return response.error ? $.Deferred().reject(response) : response;
}

Inbox.prototype.setLabels = function(emails, response) {
  emails.forEach(function(e) { e.labels = response.labels[e.id]; });
  return emails;
};

Inbox.prototype.isNew = function(id) {
  var emailIds = this.emails.map(function(e) { return e.id; });
  return emailIds.indexOf(id) == -1;
};

Inbox.prototype.markRead = function(id) {
  return $.post('/emails/' + id + '/read')
    .then(this.handleResponseError)
    .then(this.updateEmail.bind(this))
    .fail(this.error.bind(this))
    .done(this.broadcastUpdate.bind(this));
};

Inbox.prototype.updateEmail = function(response) {
  var oldEmail = this.emails.filter(function(e) {
    return e.id == response.email.id;
  })[0];
  return oldEmail.updateProperties(response.email);
};
