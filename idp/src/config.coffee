{process} = global
config =
  useHttps: false
  debug: true
  port: 3340
  secret: 'gustayooo'
  db:
    uri: process.env.MONGO_URL or 'mongodb://127.0.0.1/payment'
    options:
      db:
        native_parser: true
      server:
        poolSize: 5
  redis:
    host: 'localhost'
    port: 6379
  rabbitMQ: 
    uri: process.env.RABBIT_URL || 'amqp://guest:guest@localhost:5672'
  useProxy: false      
  proxy: process.env.SERVER_PROXY or 'http://127.0.0.1:3340'
  esClient:
    useElastic: true
    indexName: 'someindex'
    type: 'file'
    config:   
      host: '127.0.0.1:9200'
      #log: 'trace'

exports.config = config
