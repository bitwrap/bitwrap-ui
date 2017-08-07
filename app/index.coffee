window.Handlebars = require('handlebars')
window.Controller = require('./controller.coffee')
window.Api = require('./api.coffee')
window.AWS = AWSCognito

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
    @build = '20170805'
    @events = {}
    @dsl = require('./dsl.coffee')
    @guid= require('uuid/v1')

    @templates = require('wrapserver')

    @pages = {
      '': require('../pages/index.coffee')
      '#login': require('../pages/login.coffee')
      '#logout': require('../pages/logout.coffee')
      '#octothorpe': require('../pages/octothrope.coffee')
      '#terminal': require('../pages/terminal.coffee')
      '#editor': require('../pages/editor.coffee')
      '#svg': require('../pages/svg.coffee')
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

      AWS.config.region = @config.AWS.region
      AWS.config.credentials = new AWS.CognitoIdentityCredentials(@config.AWS.cognito)
      
      AWS.config.credentials.get (err) =>
        if (err)
          console.log("Error: "+err)
          return
      
        console.log("Cognito Identity Id: " + AWS.config.credentials.identityId)
        console.log(AWS.config)
      
        # Other service clients will automatically use the Cognito Credentials provider
        # configured in the JavaScript SDK.
        #cognitoSyncClient = new AWS.CognitoSync()

        #_err = (err, data) =>
        #  if ( !err )
        #    console.log(JSON.stringify(data))
        #
        #cognitoSyncClient.listDatasets({
        #    IdentityId: AWS.config.credentials.identityId,
        #    IdentityPoolId: @config.AWS.cognito.IdentityPoolId
        #}, _err)
  
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

