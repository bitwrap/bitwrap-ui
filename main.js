window.Handlebars = require('handlebars');
window.Guid = require('guid');

$( function() {
  var AppModule = require('./app/main.coffee');
  window.App = new AppModule();
  window.App.init();
});
