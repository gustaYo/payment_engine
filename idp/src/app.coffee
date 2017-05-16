module.exports = (app, express, io) =>
  moment = __non_webpack_require__ 'moment'
  morgan = __non_webpack_require__ 'morgan'
  fs = __non_webpack_require__ 'fs'

  app.all('*', (req, res, next) ->
    res.header "Access-Control-Allow-Origin", "*"
    res.header 'Access-Control-Allow-Methods', 'OPTIONS,GET,POST,PUT,DELETE'
    res.header "Access-Control-Allow-Headers", "Content-Type, Authorization, X-Requested-With"
    if 'OPTIONS' is req.method
      return res.sendStatus 200
    next()
  )
 
  #app.use morgan "dev"  

  app.use (req, res, next) ->
    console.log 'session',req.session.id
    console.log moment().format('HH:MM'), req.method, req.url
    next()

  app.route('/').get (req, res) ->
    res.render('vue')     

  {rabbit} = require './components/admin/controllers/rabbitMQ.coffee'
  {redisClient} = require './components/admin/controllers/redis.coffee'
  #{kuzzle} = require './components/admin/controllers/kuzzle.coffee'

  eventLoop =
    sendMessage: (socket, session, message) ->
      datasend =
        data: message
      rabbit.getReply 'demoQueue', datasend,  correlationId: session
      .then (reply) ->
        console.log 'received reply', reply
        try
          redisClient.get session,  (err, value) ->
            if value
              try
                console.log 'session encontrada'
                io.sockets.connected[value].emit 'message', reply
              catch error
                console.log 'usuario desconectado'
                redisClient.set session + 'inWait', JSON.stringify(reply), 'EX', 10000
            else
              console.log 'session no encontrada'
              socket.emit 'message', reply
        catch error
          console.log error
          socket.emit 'message', reply
        # ya llego la replica del mensaje eliminamos/modificamos datos o estado en la session de este usuario
        delete socket.handshake.session.userdata;
        socket.handshake.session.save();

      .catch (error) -> console.log 'error', error
    sendMessageLost: (socket, session) ->
      redisClient.get session + 'inWait',  (err, value) ->
        if value
          try
            console.log 'encontrado mensaje perdido'
            socket.emit 'message', JSON.parse(value)
            redisClient.del session + 'inWait',  (err, response) ->
              if response is 1
                console.log 'eliminado correctamente'
              else
                console.log 'no se puedo eliminar'
        else
          console.log 'no tiene mensajes perdidos'


  io.on 'connection', (socket) =>
    idSession = socket.handshake.session.id
    console.log 'user connect', idSession, 'session'
    redisClient.set idSession, socket.id, 'EX', 1000
    eventLoop.sendMessageLost socket, idSession
    socket.on 'message', (message) =>
      socket.handshake.session.userdata = 'datos del mensaje'
      socket.handshake.session.save()
      console.log message
      eventLoop.sendMessage socket, idSession, message

    socket.on 'disconnect', () ->
      console.log 'user disconnect'
      
  # aviso de que hubo algun problema user el connector de socket.io con redis para la clusterizacion
  io.of('/')
  .adapter.on 'error', () ->
    console.log 'el socket no se puedo conectar a redis'

  # repasando el listado de componentes
  console.log 'Loading components'
  fs.readdirSync(__dirname + '/src/components').forEach (file) ->
    newPath = __dirname + '/src/components' + '/' + file
    stat = fs.statSync newPath
    if stat.isDirectory()
      console.log 'component -> ' + file
  console.log '-----------------'

  # aqui se registran cada componente manualmente
  require('./components/user/index.coffee')(app, express)