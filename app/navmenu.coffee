template = Handlebars.compile """
<nav class="navbar navbar-default">
  <div class="container-fluid">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="/#"><img src="https://bitwrap.github.io/image/bw-logo3.svg" height=40 style=" margin-top: -11px;" ></a>
    </div>

    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
      <ul class="nav navbar-nav">
        <li><a href="#terminal">Terminal</a></li>
        <li><a href="#editor">PNML Editor</a></li>
        <li><a href="#octothorpe">TicTacToe</a></li>
      </ul>
      <ul class="nav navbar-nav navbar-right">
        <li><a href="https://github.com/stackdump/txbitwrap/wiki" target="_blank" >Wiki</a></li>
        <li>
          <a href="https://twitter.com/bitwrapio" target="_blank">
          <span class="fa fa-twitter"></span> bitwrapio
          </a>
        </li>

        <li>
          <a href="https://github.com/stackdump/txbitwrap" target="_blank">
          <span class="fa fa-github"></span> code 
          </a>
        </li>
        <li><a href="{{profile_link}}">{{profile_label}}</a></li>
      </ul>
    </div><!-- /.navbar-collapse -->
  </div><!-- /.container-fluid -->
</nav>
"""

module.exports = {
  render: (container) ->

    if App.session
      link = '?logout'
      label = 'Logout'
    else
      link = '#login'
      label = 'Login'

    container.html template(
      'profile_link': link,
      'profile_label': label
    )
}
