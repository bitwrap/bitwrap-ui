# bitwrap-ui

[![Build Status](https://travis-ci.org/stackdump/bitwrap-ui.svg?branch=master)](https://travis-ci.org/stackdump/bitwrap-ui)

An interactive web console for bitwrap.io

### Project Status

Preparing to release getbitwrap.com:

A way to use bitwrap.io eventstore to generate SVG images by aggregating eventstream data.

New Features:

Render a visual aggregation of an event stream as an SVG image.
* login w/ github to create streams
* embed in Markdown or as "<img/>"
* interactive JS widgets

#### Roadmap: 

Triggers & Crons
* upon actions out in the world CI etc..
  * automatically trigger an event

Allow users to add customized JavaScript Templates
* merge into front end UI
* and SVG backend codebase

### Development
Start dev server with live-reload

    npm run dev


### Using provided in-browser terminal

The coffeescript terminal provides a set of commands
that are translated into HTTP requests

This is an easy way to to prototype and test state machine definitions.
See an example of basic usage below:


    Connected to http://127.0.0.1:8080
    # type 'help' to list available commands
    -> exists 'myproject'
    false
    -> load 'counter', 'myproject'
    true
    -> exists 'myproject'
    true
    -> exists 'myproject', 'foo'
    false
    -> create 'myproject', 'foo'
    true
    -> exists 'myproject', 'foo'
    true
    -> event 'myproject', 'foo', 'INC_0', { 'hello': 'world' }
    {
      "oid": "foo",
      "rev": 1,
      "id": "1a976d31dcc98118782fc314bd59dfda"
    }
    -> event 'myproject', 'foo', 'INC_0', { 'very': 'yiss' }
    {
      "oid": "foo",
      "rev": 2,
      "id": "d58bac164897b380fbea21027ad03e60"
    }

    -> state 'myproject', 'foo'
    {
      "created": "2017-07-07T13:48:16.354077",
      "oid": "foo",
      "rev": 2,
      "modified": "2017-07-07T13:49:15.222088",
      "payload": {
        "very": "yiss"
      },
      "state": {
        "p0": 2,
        "p1": 0
      },
      "action": "INC_0",
      "id": "d58bac164897b380fbea21027ad03e60"
    }

    -> stream 'myproject', 'foo'
    {
      "timestamp": "2017-07-07T13:49:15.222088",
      "oid": "foo",
      "id": "d58bac164897b380fbea21027ad03e60",
      "seq": 2,
      "payload": {
        "very": "yiss"
      }
    },
    {
      "timestamp": "2017-07-07T13:48:42.198708",
      "oid": "foo",
      "id": "1a976d31dcc98118782fc314bd59dfda",
      "seq": 1,
      "payload": {
        "hello": "world"
      }
    }
