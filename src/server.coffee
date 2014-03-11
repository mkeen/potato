class Server
  constructor: (@address, @port) ->
    this.databases = {}

  info: (callback) ->
    this.get '/', (responseJson) -> callback(responseJson)

  all_dbs: (callback) ->
    this.get '/_all_dbs', (responseJson) ->
      dbs = []
      dbs.push new Database(this, db) for db in responseJson
      callback(dbs)

  database: (name, callback) ->
    this.databases[name] ||= new Database(this, name)

  get: (path, callback) ->
    this.xhr 'GET', path,
      load: callback

  xhr: (method, path, callbacks) ->
    xhr = new XMLHttpRequest()
    xhr.responseType = 'text'
    if callbacks.load
      xhr.onload = (event) -> callbacks.load eval("(#{this.responseText})")

    if callbacks.progress
      lastbytes = 0
      xhr.onprogress = (event) ->
        current_data = event.target.responseText.substr(lastbytes, event.loaded)
        lastbytes = event.loaded
        callbacks.progress eval("(#{current_data})")

    xhr.open method, "http://#{@address}:#{@port}#{path}", true
    xhr.send()
