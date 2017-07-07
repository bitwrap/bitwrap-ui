Controller = require('./controller.coffee')
Api = require('./api.coffee')

module.exports = class

  constructor: () ->
    @events = {}
    @dsl = require('./dsl.coffee')

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


  configure: (callback) =>
    $.ajax( Bitwrap.config, {
      dataType: 'json'
      type: 'GET'
      success: (c, textStatus) ->
        callback(c)
      error: (e) ->
        console.log('__APP_CONFIG_FAILED__', e)
    })

  connect: (callback) =>
    @.configure (cfg) =>
      @config = cfg
      callback(Api.open(@config.endpoint))


  render: =>
    App.nav.render($('#nav-menu'))
    $(@events).trigger('App.render')

  init: =>
    @controller = new Controller(@)
    $(@events).trigger('App.init')
    App.nav = require('./navmenu.coffee')

    App.connect (api) =>
      @api = api
      App.render()

  bind_events: ->

    $(@events).on 'App.init', -> return
    $(@events).on 'App.render', -> return
    $(window).resize -> App.render()
