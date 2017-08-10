# control query params, view rendering, & page loading

Session = require('./session.coffee')

class Controller

  constructor: (app) ->
    App.view = window.location.hash

    @.parse_query_string()

    @.clear_query_params()
    if App.request['code']
      @.start_session()
    else
      console.log '__no_request__'

    $(App.events).on 'App.render', =>
      @.render(App.view)

    $(window).on 'hashchange', =>
      App.view = window.location.hash
      $(App.events).trigger('App.render')

  start_session: =>
    App.session = new Session(App.request)

  parse_query_string: =>
    if window.location.search != ""
      hashes = window.location.search.slice(1).split('&')

      for i of hashes
        hash = hashes[i].split('=')
        App.request[hash[0]] = hash[1]

      delete(App.request['']) #KLUDGE clean up bad parsing

  clear_query_params: =>
    window.history.pushState('request', document.title, '/' + App.view)

  blank_page: (replace) =>
    $('#app-layout').empty()

  render: (view) =>
    App.view = view
    $(App.events).off('View')
    Page = App.pages[view]

    if Page == undefined
      @.blank_page()
      console.log 'View.missing', view
    else
      App.page = new Page
      App.page.render(@.blank_page())

module.exports = Controller
