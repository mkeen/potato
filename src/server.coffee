class Server
  constructor: (@address, @port) ->
  info: (callback) ->
    this.get '/', (responseJson) -> callback(responseJson)
      
  all_dbs: (callback) ->
    this.get '/_all_dbs', (responseJson) ->
      dbs = []
      dbs.push new Database(this, db) for db in responseJson
      callback(dbs)
      
  get: (path, callback) ->
    this.xhr 'GET', path, callback

  xhr: (method, path, callback) ->
    xhr = new XMLHttpRequest()
    xhr.open method, "http://#{@address}:#{@port}#{path}", true
    xhr.responseType = 'text'
    xhr.onload = (event) -> callback eval("(#{this.responseText})")
    xhr.send()

  stream: (method, path, callback) ->
    processed = []
    xhr = new XMLHttpRequest()
    xhr.open method, "http://#{@address}:#{@port}#{path}/_changes?feed=continuous", true
    xhr.responseType = 'text'
    tmpThis = this
    xhr.onprogress = (event) ->
      rawItems = this.responseText.split('\n')
      rawItems.pop()
      jsonItems = []
      jsonItems.push(eval("(#{rawItem})")) for rawItem in rawItems
      processed.push(jsonItem.seq) && tmpThis.get("#{path}/#{jsonItem.id}", (documentJson) -> callback(documentJson)) if processed.indexOf(jsonItems.seq) == -1 for jsonItem in jsonItems
    xhr.send()
