Kuzzle = __non_webpack_require__ 'kuzzle-sdk'

#connect to the Kuzzle server
options =
  defaultIndex: 'playground'

kuzzle = new Kuzzle 'localhost', options

#get a reference to the a collection
collection = kuzzle.collection('mycollection')

#define the document itself
document =
  message: 'Hello, world!'

#persist the document into the collection
collection.createDocument document

filter =
  exists:
    field: 'message'

collection.subscribe filter, (error, result) ->
  console.log 'message received from kuzzle:', result

exports.kuzzle = Kuzzle