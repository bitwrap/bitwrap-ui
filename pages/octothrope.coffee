module.exports = class Octothorpe

  constructor: ->
    @turn = 'O'

    @template = Handlebars.compile """
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
          <a href="{{wrapserver}}/octoe/{{guid}}.svg">image: octoe.svg</a>
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

  widget: (oid, name, id, callback) =>
    res = App.templates[name]
    url = App.config.endpoint + '/stream/octoe/' + oid

    $.getJSON(url, (stream) =>
      res.render(window.Snap('#octothrope-widget'), stream)
      callback(stream)
    )


  take_move: (id) =>
    target = @turn + id.split('-')[1]

    error = (e) => console.log 'move_error', e

    App.api.dispatch('octoe', @guid, target, {}, (data) =>
      return
    , error
    )

  subscribe:  =>

    url = App.api.endpoint.replace(/^http/, 'ws') + '/websocket'

    @ws = new WebSocket(url)

    @ws.onopen = () =>
      @ws.send(JSON.stringify({'bind': ['octoe', @guid]}))

    @ws.onmessage = (evt) =>
      @refresh()

  render: (container) =>

    @game_id = window.getUrlVars().session
    if not @guid
      if @game_id
        @guid = @game_id
      else
        @guid = '000000000'

    console.log App.config.wrapserver
    container.html @template('guid': @guid, 'wrapserver': App.config.wrapserver)

    @refresh = => @.render(container)

    @.subscribe() unless @ws

    $('#redraw-game').on('click', @refresh)

    $('#reset-game').on('click', =>
      @ws.send(JSON.stringify({'unbind': ['octoe', @guid]}))
      # REVIEW: consider removing 'game' from querystring
      # when resetting
      if @game_id
        @guid = @game_id
      else
        @guid = App.guid()
      @ws.send(JSON.stringify({'bind': ['octoe', @guid]}))

      error = (e) => console.log 'octoe_error', e

      App.api.rpc('stream_create', ['octoe', @guid ], (data) =>
        App.api.dispatch('octoe', @guid, 'BEGIN', {}, (data) =>
          return
        , error
        )
      , error
      )
    )

    @.widget(@guid, 'octothorpe', '#octothorpe-widget', (stream) =>
      if stream[0]
        if 'X' == stream[0]['action'][0]
          @turn = 'O'
        else
          @turn = 'X'

      $(".BG").on 'click', (obj) =>
        @.take_move(obj.target.id)
    )
