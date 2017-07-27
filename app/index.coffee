window.Handlebars = require('handlebars')
window.Controller = require('./controller.coffee')
window.Api = require('./api.coffee')

window.getUrlVars = ->
  vars = []
  hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&')
  for i in [0...hashes.length]
    hash = hashes[i].split('=')
    vars[hash[0]] = hash[1]

  return vars

$(document).ready =>
  window.App = new Application()
  window.App.start()

class Application

  constructor: () ->
    @events = {}
    @dsl = require('./dsl.coffee')
    @guid= require('uuid/v1')

    @templates = require('wrapserver')

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

