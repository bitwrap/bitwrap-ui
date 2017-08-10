template = Handlebars.compile """
<div class="jumbotron">
  <div class="container">
    <p class="lead">
      Login with:
    </p>
    <p>
      <a class="btn btn-lg btn-default" href="{{oauth_uri}}?redirect_uri={{redirect_uri}}&client_id={{client_id}}">
        <span class="fa fa-github"> GitHub </span>
      </a>
    </p>
  </div>
</div>
"""

_disabled = Handlebars.compile """
<div class="container">
</div>
<div class="jumbotron">
  <div class="container">
    <p class="lead">
     Login is currently disabled.
    </p>
  </div>
</div>

"""

module.exports = class

  render: (container) ->

    if App.config.auth
      key = App.config.auth['provider']
      container.html template(App.config.auth[key])
    else
      container.html _disabled()
