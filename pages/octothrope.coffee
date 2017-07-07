module.exports = class Octothorpe

  constructor: ->
    @guid = '000000000'
    @valid_actions = []
    @record = {}
    @seq = 0
    @turn = 'O'

    @template = Handlebars.compile """
      <div class="jumbotron">
        <div class="container">
          <p class="lead">
            Play Tic-Tac-Toe <br />
            Using a Bitwrap State-Machine called <a href="https://github.com/bitwrap/bitwrap-io/blob/master/bitwrap_io/schemata/octothorpe.json"
             target="_blank" >#octothorpe</a>
          </p>
          <button class='btn-info' id='redraw-game'>Redraw</button>
          <button class='btn-primary' id='reset-game'>Reset</button>
        </div>
      </div>
      <div class="container">
      <svg id="octothrope-widget" width=300 height=300 ></svg>
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
    console.log('widget', res)
    url = App.config.endpoint + '/stream/octoe/' + oid

    $.getJSON(url, (stream) =>
      res.render(window.Snap('#octothrope-widget'), stream)
      callback()
    )


  take_move: (id, callback) =>
    target = id.split('-')[1]

    console.log('take move', id)
    # FIXME 
    #@.tx("#{@turn}#{target}",
    #  {"msg": id },
    #  (data) =>
    #    @.next_turn()
    #    console.log("TX/RX(octotothorpe, #{data.event.oid}, #{data.event.action})", data)
    #    callback(data)
    #  (err) => console.log('__ERR__', err)
    #)


  render: (container) =>

    container.html @template()

    @refresh = => @.render(container)

    $('#redraw-game').on('click', @refresh)

    $('#reset-game').on('click', =>
      @guid = window.Guid.raw()

      # TODO: create a new stream
      #  @.tx('BEGIN',
      #    {"msg": "ResetGame"}
      #    (data) =>
      #      @.next_turn()
      #      refresh()
      #      console.log("TX/RX(octotothorpe, #{data.event.oid}, #{data.event.action})", data)
      #    (err) => console.log('__ERR__', err)
      #  )
    )

    @.widget(@guid, 'octothorpe', '#octothorpe-widget', =>
      $(".BG").on 'click', (obj) =>
        @.take_move(obj.target.id, @refresh)
    )
