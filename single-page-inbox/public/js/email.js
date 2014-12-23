function Email(data) {
  this.updateProperties(data);
}

Email.prototype.formatDate = function(date) {
  var months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  return months[date.getMonth()] + ' ' + date.getDate();
};

Email.prototype.updateProperties = function(data) {
  this.id = data.id;
  this.read = data.read ? 'Read' : 'Unread';
  this.from = data.from;
  this.subject = data.subject;
  this.date = new Date(data.created_at);
  this.formattedDate = this.formatDate(this.date);
  this.body = data.body || null;
  return this;
};
