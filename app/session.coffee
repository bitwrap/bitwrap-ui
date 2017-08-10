window.onbeforeunload = =>

  if App.session
    return 'logout?'

  console.log "__LOGOUT__"

class Session

  constructor: (request) ->
    @id = App.guid()
    @request = request
    console.log '__SESSION__'
    console.log request

module.exports = Session
