module.exports = class

  constructor: (app) ->
    @app = app
    @app.layout = require('./layout.coffee')
    @app.view = window.location.hash

    $(@app.events).on 'App.render', ->
      App.layout.render(App.view)

    $(window).on 'hashchange', ->
      App.view = window.location.hash
      $(App.events).trigger('App.render')
