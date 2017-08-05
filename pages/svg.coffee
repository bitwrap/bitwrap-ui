template = Handlebars.compile """
  <div class="container">
    <br>
    <a href="{{wrapserver}}/{{template}}/{{oid}}.svg">
      <img src="{{wrapserver}}/{{template}}/{{oid}}.svg" height={{height}} width={{width}}></img>
    </a>
  </div>
"""

parse = (input) ->
  if input
    return parseInt(input)
  
  return ''

encode = (input) ->
  if input
    return encodeURIComponent(input)
  
  return ''

module.exports = class

  render: (container) ->

    inputs = getUrlVars()

    delay = 2000

    container.html """
    <div class="container">
      <br>
      <p> delay: #{delay/1000}s</p>
    </div>
    """
    draw = =>
      container.html template({
        'wrapserver': App.config.wrapserver,
        'template': encode(inputs.template),
        'oid': encode(inputs.oid),
        'height': parse(inputs.height),
        'width': parse(inputs.width)
      })

    console.log('delay': delay)
    setTimeout(draw, delay)
