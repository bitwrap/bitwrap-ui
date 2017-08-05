_template = Handlebars.compile """
  <div class="jumbotron">
    <div class="container">
      <p class="lead">
        Play Tic-Tac-Toe <br />
        Using a Bitwrap State-Machine <a href="https://github.com/bitwrap/bitwrap-machine/tree/master/bitwrap_machine/examples"
         target="_blank" >'octoe.xml'</a>
      </p>
      <a href="?session={{guid}}&#octothorpe">permlink: {{guid}}</a>
      {{#if wrapserver}}
      <br>
      <a href="?template=octoe&oid={{guid}}&#svg">image: octoe.svg</a>
      {{/if}}
      <br>
      <br>
      <button class='btn-info' id='redraw-game'>Redraw</button>
      <button class='btn-primary' id='reset-game'>Reset</button>
    </div>
  </div>
  <div class="container">
  <svg id="octothrope-widget" width=600 height=600 ></svg>
  </div>
    <div class="container">
      <p>Each click event on the board is submitted as a transform event.</p>
    </div>
  """

module.exports = class Octothorpe

  constructor: ->
    @turn = 'O'

  widget: (oid, name, id, callback) =>
    res = App.templates[name]
    url = App.config.endpoint + '/stream/octoe/' + oid

    $.getJSON(url, (stream) =>
      res.render {
        'config': App.config,
        'paper': window.Snap('#octothrope-widget'),
        'data': stream}, callback
    )


  take_move: (id) =>
    target = @turn + id.split('-')[1]

    error = (e) => console.log 'move_error', e

    App.api.dispatch('octoe', @guid, target, {}, (data) =>
      @.await_or_refresh()
    , error
    )

  subscribe:  =>

    url = App.api.endpoint.replace(/^http/, 'ws') + '/websocket'

    return if @.ws_ready()

    @ws = new WebSocket(url)

    @ws.onopen = () =>
      @ws.send(JSON.stringify({'bind': ['octoe', @guid]}))

    @ws.onclose = () =>
      console.log '__CLOSE__'

    @ws.onmessage = (msg) =>
      # TODO: save event in localStorage
      @refresh()

    @ws.onerror = (evt) =>
      console.log '__WEBSOCKET_ERR__'
      
  ws_ready: =>
    return @ws && @ws.readyState == @ws.OPEN
      
  await_or_refresh: =>
    unless App.config.use_websocket && @.ws_ready()
      @refresh()

  render: (container) =>

    @game_id = window.getUrlVars().session
    if not @guid
      if @game_id
        @guid = @game_id
      else
        @guid = '000000000'

    container.html _template('guid': @guid, 'wrapserver': App.config.wrapserver)

    @refresh = => @.render(container)

    @.subscribe() if App.config.use_websocket

    $('#redraw-game').on('click', @refresh)

    $('#reset-game').on('click', =>

      newguid = App.guid()

      if @.ws_ready()
        @ws.send(JSON.stringify({'unbind': ['octoe', @guid]}))
        @ws.send(JSON.stringify({'bind': ['octoe', newguid]}))

      if @game_id
        @guid = @game_id
      else
        @guid = newguid

      error = (e) => console.log 'octoe_error', e

      App.api.rpc('stream_create', ['octoe', @guid ], (data) =>
        App.api.dispatch('octoe', @guid, 'BEGIN', {}, (data) =>
          @.await_or_refresh()
        , error
        )
      , error
      )
    )

    @.widget(@guid, 'octoe', '#octothorpe-widget', (w) =>

      if w.data && w.data[0]
        if 'X' == w.data[0]['action'][0]
          @turn = 'O'
        else
          @turn = 'X'

      $(".BG").on 'click', (obj) =>
        @.take_move(obj.target.id)
    )
