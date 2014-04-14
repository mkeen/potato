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
      xhr.onload = (event) -> callbacks.load JSON.parse(this.responseText)

    if callbacks.progress
      xhr.onprogress = (event) =>
        response = event.target.responseText
        if response.substr(response.length) != '}'
          console.log response[response.length - 1]
        else
          console.log response[response.length - 1]

    xhr.open method, "http://#{@address}:#{@port}#{path}", true
    xhr.send()

  object_cluster_item_list: (cluster) ->
    console.log cluster.split '\n'
