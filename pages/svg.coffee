template = Handlebars.compile """
  <div class="container">
    <br>
    <a href="{{wrapserver}}/{{template}}/{{oid}}.svg">
      <img src="{{wrapserver}}/{{template}}/{{oid}}.svg" height={{height}} width={{width}}></img>
      <br>
      {{wrapserver}}/{{template}}/{{oid}}.svg
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

    inputs = App.request

    container.html template({
      'wrapserver': App.config.wrapserver,
      'template': encode(inputs.template),
      'oid': encode(inputs.oid),
      'height': parse(inputs.height),
      'width': parse(inputs.width)
    })
