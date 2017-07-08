window.Handlebars = require('handlebars')
window.Controller = require('./controller.coffee')
window.Api = require('./api.coffee')

$(document).ready =>
  window.App = new Application()
  window.App.start()

class Application

  constructor: () ->
    @events = {}
    @dsl = require('./dsl.coffee')
    @guid= require('uuid/v1')

    @templates = {
      machine: require('../templates/machine.js')
      counter: require('../templates/counter.js')
      octothorpe: require('../templates/octothorpe.js')
    }

    @pages = {
      '': require('../pages/index.coffee')
      '#octothorpe': require('../pages/octothrope.coffee')
      '#terminal': require('../pages/terminal.coffee')
    }

    @.bind_events()

  start: =>
    @controller = new Controller(@)
    $(@events).trigger('App.init')
    App.nav = require('./navmenu.coffee')

    App.connect (api) =>
      @api = api
      App.render()

  connect: (callback) =>
    @.configure (cfg) =>
      @config = cfg
      callback(Api.open(@config.endpoint))

  configure: (callback) =>
    $.ajax( Bitwrap.config, {
      dataType: 'json'
      type: 'GET'
      success: (c, textStatus) ->
        callback(c)
      error: (e) ->
        console.error('__APP_CONFIG_FAILED__', e)
    })

  render: =>
    App.nav.render($('#nav-menu'))
    $(@events).trigger('App.render')

  bind_events: ->

    $(@events).on 'App.init', -> return
    $(@events).on 'App.render', -> return
    $(window).resize -> App.render()
