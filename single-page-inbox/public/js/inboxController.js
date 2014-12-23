function InboxController(inbox, view) {
  this.inbox = inbox;
  this.view = view;
  this.bindListeners();
}

InboxController.prototype.bindListeners = function() {
  $('body').on('click', '.email-list-item', this.displayEmail.bind(this));
  $(this.inbox).on('update', this.handleInboxUpdate.bind(this));
  $(this.inbox).on('error', this.displayError.bind(this));
  $(this.inbox).on('fatal', this.displayFatal.bind(this));
};


InboxController.prototype.displayEmail = function(e) {
  var $emailEl = $(e.currentTarget);
  var emailId = $emailEl.attr('id').split('-')[1];
  var email = this.inbox.emails.filter(function(email) {
    return email.id == emailId;
  })[0];

  email.body ? this.view.displayEmail($emailEl) : this.inbox.markRead(email.id);
};

InboxController.prototype.handleInboxUpdate = function(e, content) {
  this.clearError();
  if (content.length) {
    this.view.displayEmails(content);
  } else {
    this.view.updateEmail(content);
  }
};

InboxController.prototype.clearError = function() {
  this.view.$errorContainer.hide();
};

InboxController.prototype.displayError = function() {
  this.view.$errorContainer.text('Error fetching message(s).').show();
};

InboxController.prototype.displayFatal = function() {
  this.view.$errorContainer.text('Fatal error.').show();
};
