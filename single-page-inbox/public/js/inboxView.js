function InboxView() {
  this.$container = $('.inbox');
  this.$errorContainer = $('.errors');
  this.emailListTemplate = [
    '<div id="email-{{id}}" class="row gutters email-list-item {{read}}">',
      '<div class="row gutters email-summary">',
        '<div class="col span_1 email-detail read">{{read}}</div>',
        '<div class="col span_4 email-detail from">{{from}}</div>',
        '<div class="col span_4 email-detail subject">{{subject}}</div>',
        '<div class="col span_2 email-detail date">{{date}}</div>',
        '<div class="col span_1 email-detail labels row"></div>',
      '</div>',
      '<div class="email-body" style="display: none"></div>',
    '</div>'
  ].join('\n');
  this.labelTemplate = '<div class="{{label}} col span_4 email-label" {{style}}></div>';
}


InboxView.prototype.displayEmails = function(emails) {
  var that = this;
  emails.forEach(function(email) {
    var $emailItem = $(that.emailListTemplate
      .replace('{{id}}', email.id)
      .replace(/{{read}}/g, email.read)
      .replace('{{from}}', email.from)
      .replace('{{subject}}', email.subject)
      .replace('{{date}}', email.formattedDate));

    if (email.labels) {
      email.labels.forEach(function(label) {
        var labelItem = that.labelTemplate
          .replace('{{label}}', label.name)
          .replace('{{style}}', 'style="background-color: #' + label.color + '"');
        $emailItem.find('.labels').append(labelItem);
      });
    }

    that.$container.prepend($emailItem);
  });
};

InboxView.prototype.displayEmail = function($el) {
  $el.find('.email-body').toggle();
};

InboxView.prototype.updateEmail = function(email) {
  var id = email.id;
  var $emailItem = $('#email-' + id);
  $emailItem.find('.email-body').text(email.body).toggle();
  $emailItem.removeClass('Read');
  $emailItem.removeClass('Unread');
  $emailItem.addClass(email.read);
  $emailItem.find('.read').text(email.read);
};

