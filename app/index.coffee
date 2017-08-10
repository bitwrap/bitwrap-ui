window.Handlebars = require('handlebars')
Controller = require('./controller.coffee')
Api = require('./api.coffee')

$(document).ready =>
  window.App = new Application()
  App.start()

class Application

  constructor: () ->
    @build = '20170808'
    @events = {}
    @dsl = require('./dsl.coffee')
    @guid= require('uuid/v1')
    @templates = require('wrapserver')
    @session = false
    @request = []

    @pages = {
      '': require('../pages/index.coffee')
      '#login': require('../pages/login.coffee')
      '#logout': require('../pages/logout.coffee')
      '#octothorpe': require('../pages/octothrope.coffee')
      '#terminal': require('../pages/terminal.coffee')
      '#editor': require('../pages/editor.coffee')
      '#svg': require('../pages/svg.coffee')
    }

  start: =>
    @controller = new Controller(@)
    App.nav = require('./navmenu.coffee')

    @.configure (cfg) =>
      @config = cfg
      @api = Api.open(@config.endpoint)
      App.render()

    $(window).resize -> App.render()

    $(App.events).on 'App.render', ->
      App.nav.render($('#nav-menu'))

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
    $(@events).trigger('App.render')
