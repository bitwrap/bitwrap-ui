module.exports = class Octothorpe

  constructor: ->
    @guid = '000000000'
    @turn = 'O'

    @template = Handlebars.compile """
      <div class="jumbotron">
        <div class="container">
          <p class="lead">
            Play Tic-Tac-Toe <br />
            Using a Bitwrap State-Machine <a href="https://github.com/bitwrap/bitwrap-machine/tree/master/bitwrap_machine/examples"
             target="_blank" >'octoe.xml'</a>
          </p>
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

  next_turn: =>
    if @turn == 'X'
      @turn = 'O'
    else
      @turn = 'X'

  widget: (oid, name, id, callback) =>
    res = App.templates[name]
    url = App.config.endpoint + '/stream/octoe/' + oid

    $.getJSON(url, (stream) =>
      res.render(window.Snap('#octothrope-widget'), stream)
      callback()
    )


  take_move: (id) =>
    target = @turn + id.split('-')[1]

    error = (e) => console.log 'move_error', e

    App.api.dispatch('octoe', @guid, target, {}, (data) =>
      @.next_turn()
      @refresh()
    , error
    )


  render: (container) =>

    container.html @template()

    @refresh = => @.render(container)

    $('#redraw-game').on('click', @refresh)

    $('#reset-game').on('click', =>
      @guid = App.guid()

      error = (e) => console.log 'octoe_error', e

      App.api.rpc('stream_create', ['octoe', @guid ], (data) =>
        App.api.dispatch('octoe', @guid, 'BEGIN', {}, (data) =>
          @.next_turn()
          @refresh()
        , error
        )
      , error
      )
    )

    @.widget(@guid, 'octothorpe', '#octothorpe-widget', =>
      $(".BG").on 'click', (obj) =>
        @.take_move(obj.target.id)
    )
