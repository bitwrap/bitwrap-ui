template = Handlebars.compile """
<div class="jumbotron">
  <p> Add logout w/ cognito api</p>
</div>

"""

module.exports = class

  render: (container) ->

    container.html template()
