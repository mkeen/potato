class Database
  constructor: (@server, @name) ->
  info: (callback) ->
    @server.get "/#{@name}", callback

  document: (doc_id, callback) ->
    @server.get "/#{@name}/#{doc_id}", callback

  changes: (callback) ->
    database = this
    @server.xhr 'get',
                "/#{@name}/_changes?feed=continuous",
                 progress: (doc) => this.document doc.id, (doc) -> callback doc
