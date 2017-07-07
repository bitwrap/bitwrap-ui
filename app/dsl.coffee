module.exports = (cmd, term) ->
  window.__term = term
  return -> window.CoffeeScript.eval("dsl.#{cmd}")

rpc = (method, params) ->
  App.api.rpc(
    method,
    params,
    (res) ->
      pp(res, 2)
    ,
    (err) ->
      pp err
  )
  return

get = (path, space) ->
  $.getJSON( App.api.endpoint + path,
    (res) -> pp(res, space)
  )
  return

dispatch = (schema, oid, action, payload={}) ->
  App.api.dispatch(
    schema,
    oid,
    action,
    payload,
    (res) ->
      pp(res, 2)
    ,
    (err) ->
      pp err
  )
  return

pp = (t, space) ->
  window.__term.echo(JSON.stringify(t, null, space))
  return

# top level context for eval-ing code from coffeescript terminal
window.dsl = {

  help: {
    commands: {
      App: 'window.App'

      echo: '(obj) print to terminal'
      pp: '(obj) dump object to terminal'
      _: '(obj) alias for pp'

      dispatch: '(schema, oid, action, payload) dispatch an event'
      tx: '(schema, oid, aciton, payload) alias for dispatch'

      schema_create: '(machine_name, schema_name) load machine as db schema'
      schema_exists: '(schema) test that schema is loaded into db'
      schema_destroy: '(schema) destroy schema and all associated data'

      stream_exists: '(schmea, oid) test that stream is initalized'
      stream_create: '(schema, oid) create a new stream with default state'

      get_schemata: 'list all defined schemata'
      get_machine: '(schema, space=2) get machine definition json'
      
      get_stream: '(schema, oid) get all the events from a stream'
      get_state: '(schema, oid) get the current state of a sream'
    }
  }

  App: window.App

  echo: (t) ->
    window.__term.echo(t)
    return

  pp: pp
  _: pp

  dispatch: dispatch
  tx: dispatch

  schema_create: (machine_name, schema_name) -> rpc('schema_create', [machine_name, schema_name])
  schema_exists: (schema) -> rpc('schema_exists', [schema])
  schema_destroy: (schema) -> rpc('schema_destroy', [schema])

  stream_exists: (schema, oid) -> rpc('stream_exists', [schema, oid])
  stream_create: (schema, oid) -> rpc('stream_create', [schema, oid])

  get_schemata: () -> get("/schemata", 0)
  get_machine: (schema, space=2) -> get("/machine/#{schema}", space)
  
  get_stream: (schema, oid) -> get("/stream/#{schema}/#{oid}", 2)
  get_state: (schema, oid) -> get("/state/#{schema}/#{oid}", 2)

}
