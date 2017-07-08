module.exports = (cmd, term) ->
  window.__term = term
  return -> window.CoffeeScript.eval("__dsl.#{cmd}")

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

exists = (schema, oid) ->
  if ! oid
    rpc('schema_exists', [schema])
  else
    rpc('stream_exists', [schema, oid])

create = (schema, oid) ->
  if ! oid
    rpc('schema_create', [schema])
  else
    rpc('stream_create', [schema, oid])

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

# context for eval-ing coffeescript terminal
window.__dsl = {

  help: {
    commands: {
      echo: '(obj) print to terminal'
      pp: '(obj) dump object to terminal'
      _: 'alias for pp'

      event: '(schema, oid, action, payload) dispatch an event'
      get: '(schema, eventid) get event by id'

      load: '(machine, schema) load machine as db schema'
      create: '(schema, oid) create a new stream with default state'
      destroy: '(schema) destroy schema and all associated data'

      schemata: 'list defined machine schemata'
      machine: '(schema, space=2) get machine definition json'
      
      stream: '(schema, oid) get all the events from a stream'
      state: '(schema, oid) get the HEAD event & state of a stream'
    }
  }

  echo: (t) ->
    window.__term.echo(t)
    return

  pp: pp
  _: pp

  schemata: () -> get("/schemata", 0)

  state: (schema, oid) -> get("/state/#{schema}/#{oid}", 2)
  machine: (schema, space=2) -> get("/machine/#{schema}", space)

  event: dispatch
  stream: (schema, oid) -> get("/stream/#{schema}/#{oid}", 2)
  get: (schema, eventid) -> get("/event/#{schema}/#{eventid}", 2)

  exists: exists
  load: (machine_name, schema_name) -> rpc('schema_create', [machine_name, schema_name])

  create: (schema, oid) -> rpc('stream_create', [schema, oid])
  destroy: (schema) -> rpc('schema_destroy', [schema])
  
}
