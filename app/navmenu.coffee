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
        <li><a href="#octothorpe">TicTacToe</a></li>
        <!--
        <li class="dropdown">
          <a href="#projects" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Demo Projects<span class="caret"></span></a>
          <ul class="dropdown-menu">
          </ul>
        </li>
        -->
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
      </ul>
    </div><!-- /.navbar-collapse -->
  </div><!-- /.container-fluid -->
</nav>
"""

module.exports = {
  render: (container) ->

    container.html template()
}
