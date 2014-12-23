var app = app || {};
app.view = app.view || new InboxView();
app.inbox = app.inbox || new Inbox(app.view);
app.controller = app.controller || new InboxController(app.inbox, app.view);
