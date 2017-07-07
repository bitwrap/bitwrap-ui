template = Handlebars.compile """
<div id='terminal-holder' style="height: {{ height }}px"></div>
"""

greeting = Handlebars.compile """
Connected to {{ endpoint }}
# type 'help' to list available commands
"""

module.exports = class

  render: (container) ->
    container.html template({
      'height': window.innerHeight - 80
    })

    $('#terminal-holder').terminal((command, term) ->
      if (command != '')
        result = window.App.dsl(command, term)()
        if (result != undefined)
          if typeof(result) == 'function'
            out = '<function>'
          else
            try
              out = JSON.stringify(result, null, 2)
            catch
              out = String(result)
          out += '\n'
          term.echo(out)
    ,{
        greetings: greeting({
          endpoint: App.config.endpoint
        }),
        name: 'bitwrap-ui',
        prompt: '-> '
    })
