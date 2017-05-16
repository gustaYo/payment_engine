
{Rabbit,BaseQueueHandler} = __non_webpack_require__ 'rabbit-queue'
fs = __non_webpack_require__ 'fs'
{config} = require '../../../config.coffee'
opts =
  #cert: fs.readFileSync '../etc/client/cert.pem'
  #key: fs.readFileSync '../etc/client/key.pem'
  passphrase: 'MySecretPassword'
  #ca: [fs.readFileSync('../etc/testca/cacert.pem')]

options =
  prefetch: 1
  replyPattern: true
  scheduledPublish: false
  prefix: ''
  socketOptions: opts
  
rabbit = new Rabbit config.rabbitMQ.uri, options

rabbit.on 'connected', () ->
  console.log 'conectado correctamente'

rabbit.on 'disconnected', (err = new Error('Rabbitmq Disconnected')) =>    
  console.error err
  timeTimeout = setTimeout () =>
    rabbit.reconnect()
  , 2000  
  
exports.rabbit = rabbit  