page_template = Handlebars.compile """
<div class="container">
  <br>
  <button class='btn-info' id='redraw-editor'>Redraw</button>
  <svg id="{{guid}}" width=600 height=600 ></svg>
</div>
"""

module.exports = class Editor

  constructor: ->
    @schema = 'octoe' # KLUDGE hardcoded for now
    @guid = 'bitwrap-editor'
    @id = "##{@guid}"
    @tpl = App.templates.editor

  widget: (element_id, callback) =>
    res = @tpl.resource(App.config.endpoint, { 'oid': @schema })

    $.getJSON res, (machine) =>
      
      @tpl.render({
        'config': App.config,
        'paper': Snap(element_id),
        'data': machine
      }, callback)

  render: (container) =>
    container.html page_template('guid': @guid)
    @.refresh = => @.render(container)
    $('#redraw-editor').on('click', @.refresh)

    @.widget(@id, (machine) =>
      $(@id).on 'click', (obj) => console.log(obj.target.id)

      $('edt-menu').on 'drag', (obj) =>
        console.log(obj.target.id)

      # TODO bind other events for drawing petri-nets
      
      console.log(machine)
    )
