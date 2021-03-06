class Client

  constructor: (endpoint) ->
    @seq = 0
    @endpoint = endpoint
    @last = undefined

    if window.App.config['encoding'] == 'form'
      @prefix = 'json='
      @content_encoding = "application/x-www-form-urlencoded; charset=UTF-8"
    else
      @content_encoding = "application/json"
      @prefix = ''

  rpc: (method, params=[], callback, errback) =>
    url = "#{@endpoint}/api"

 
    $.ajax( url, {
      type: 'POST'
      data: @prefix+JSON.stringify({ 'id': (@seq += 1), 'method': method, 'params': params })
      processData: false,
      contentType: @content_encoding,
      success: (e, textStatus) ->
        if e['error'] == undefined or e['error'] == null
          callback(e.result) if callback
        else
          errback(e) if errback
 
      error: (jqXHR, textStatus, errorThrown ) ->
        errback() if errback
        console.error('__RPC_REQUEST_FAILED__', JSON.stringify([jqXHR, textStatus, errorThrown]))
    })
 

  dispatch: (schema, oid, action, payload={}, callback, errback) =>
    url = "#{@endpoint}/dispatch/#{schema}/#{oid}/#{action}"

    args = {
      schema: schema,
      oid: oid,
      action: action,
      payload: payload
    }

    $.ajax( url, {
      type: 'POST'
      data: @prefix+JSON.stringify(payload),
      processData: false,
      contentType: @content_encoding,
      success: (e, textStatus) ->
        if e.rev
          callback(e) if callback
        else
          errback(e) if errback

      error: (jqXHR, textStatus, errorThrown ) ->
        errback() if errback
        console.error('__EVENT_DISPATCH_FAILED__', JSON.stringify([jqXHR, textStatus, errorThrown]))
    })

  broadcast: (schema, key, payload={}, callback, errback) =>
    url = "#{@endpoint}/broadcast/#{schema}/#{key}"

    $.ajax( url, {
      type: 'POST'
      data: @prefix+JSON.stringify(payload),
      processData: false,
      contentType: @content_encoding,
      success: (e, textStatus) ->
        if e.seq
          callback(e) if callback
        else
          errback(e) if errback

      error: (jqXHR, textStatus, errorThrown ) ->
        errback() if errback
        console.error('__MESSAGE_BROADCAST_FAILED__', JSON.stringify([jqXHR, textStatus, errorThrown]))
    })


module.exports.open = (endpoint) -> new Client(endpoint)
