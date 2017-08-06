template = Handlebars.compile """
<div class="jumbotron">
  <p> Add login w/ cognito api</p>
</div>

"""

module.exports = class

  render: (container) ->

    container.html template()
