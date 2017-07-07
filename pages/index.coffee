template = Handlebars.compile """
<div class="jumbotron">
  <div class="container">
    <h1>
      <img src="https://bitwrap.github.io/image/bw-logo3.svg" height=60 width=60 style=" margin-top: -11px;" ></a> Bitwrap
    </h1>
    <p class="lead">
      A blockchain style eventstore that validates sequences of events.
    </p>
    <p>
      Read our <a href="https://github.com/bitwrap/bitwrap-io/blob/master/whitepaper.md" target="_blank">whitepaper</a>
      : "Solving State Explosion with Petri-Nets and Vector Clocks"
    </p>
  </div>
</div>

<div class="container light-text">
  <p class="lead"> ~ How it works ~ </p>
  <p>
    Bitwrap indexes your events by tracking application state independent of event message structure.<br>
    This allows an event sequence to be validated without having access to the content of each event payload.<br>
  </p>
  <p class="lead">
    ~ A Layer of Abstraction ~
  </p>
  <p>
   Composing event schemata using PNML and Bitwrap provides a functional layer of abstraction between the <br>
   parts of an application that affect state and the parts that store data.
  </p>
  <p>
   This separation makes complex systems easier to design, and the interaction between multiple systems easier to reason about.
  </p>
  <p class="lead">
    ~ Open Source ~
  </p>

  <p>
    This project is made available under the MIT license on <a href="https://github.com/bitwrap/" target="_blank">github</a>
    and makes use of several other open source software and standards:
  </p>
  <p>
    <a href="https://en.wikipedia.org/wiki/Petri_Net_Markup_Language" target="_blank" >PNML</a> is used as a domain specific language
    to describe events in the form of a state-machine, its rules, and its predefined transformations.<br>
  </p>
  <p>
    A compatible java based PNML editor is found on github:
    <a href="https://github.com/sarahtattersall/PIPE/releases" target="_blank">PIPE: Platform Independent Petri-Net Editor</a>.
  </p>
  <p>
    Events are stored using a <a href="https://www.postgresql.org/" target="_blank"> PostgreSQL </a> database --
    Which has excellent support for working with
    <a href="https://www.postgresql.org/docs/current/static/functions-json.html" target="_blank"> JSON </a> data.
  </p>
</div>


"""

module.exports = class

  render: (container) ->

    container.html template()
