class Database
  constructor: (@server, @name) ->
  info: (callback) ->
    @server.get "/#{@name}", callback
  changes: (callback) ->
    @server.stream 'GET', "/#{@name}", (jsonDocument) ->
      callback(jsonDocument)
  
