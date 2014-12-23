function Stream(url, interval) {
  this.url = url;
  this.interval = interval;
  this.stream = $.Deferred();
  this.failures = 0;
  this.start();
}

Stream.prototype.start = function() {
  setTimeout(this.fetch.bind(this), this.interval);
};

Stream.prototype.fetch = function() {
  $.ajax({url: this.url, type: 'get', context: this})
    .done(this.checkResponse)
    .fail(this.stream.reject)
    .always(this.start);
};

Stream.prototype.checkResponse = function(response) {
  if (response.error) {
    this.retry();
  } else {
    this.stream.notify(response);
    this.failures = 0;
  }
};

Stream.prototype.retry = function() {
  if (this.failures >= 5) {
    this.stream.reject();
  } else {
    this.failures++;
  }
};
