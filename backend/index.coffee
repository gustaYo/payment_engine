express = __non_webpack_require__ 'express'
socket_io = __non_webpack_require__ 'socket.io'
fs = __non_webpack_require__ 'fs'
morgan = __non_webpack_require__ 'morgan'
bodyParser = __non_webpack_require__ 'body-parser'
ejs = __non_webpack_require__ 'ejs'
mongoose = __non_webpack_require__ 'mongoose'
http = __non_webpack_require__ 'http'
https = __non_webpack_require__ 'https'
path = __non_webpack_require__ 'path'
ip = __non_webpack_require__ 'ip'
socket_redis = __non_webpack_require__ 'socket.io-redis'

{config} = require './src/config.coffee'
{ process } = global
projectRoot = __dirname or path.resolve(process.argv[1], '../')
console.log ip.address(),'root -> ',projectRoot
app = express()
app.use bodyParser.json {limit: '50mb'}
app.use bodyParser.urlencoded
  limit: '50mb',
  extended: true,
  parameterLimit:50000

app.set('views', "#{projectRoot}/views")
app.engine 'html', ejs.renderFile
app.set 'view engine', 'html' 
oneYear = 365 * 86400000
app.use express.static "#{projectRoot}/public", {maxAge: oneYear}

express_session = __non_webpack_require__ 'express-session'
sharedsession = __non_webpack_require__ 'express-socket.io-session'
connect_redis = __non_webpack_require__ 'connect-redis'

RedisStore = connect_redis(express_session);

session_options =
  store: new RedisStore config.redis
  secret: "banckendSecret"
  resave: true
  saveUninitialized: true

session = express_session session_options

app.use session

ssl_options = {}
if config.useHttps
  ssl_options = 
    key: fs.readFileSync __dirname+'/ssl/private.key'
    cert: fs.readFileSync __dirname+'/ssl/certificate.pem'

webServer = if config.useHttps then https.createServer ssl_options, app else http.createServer app
io = socket_io webServer
io.use sharedsession session
io.adapter socket_redis config.redis

require('./src/app.coffee') app, express, io, config

mongoose.connect config.db.uri, config.db.options
db = mongoose.connection

db.on 'error', ({ name, message }) ->
  console.log 'Failed to connect:', name
  console.log message

db.once 'open', ->
  console.log "we're connected! Let's get started\n"
  start ->
    console.log "server express run"

start = (done) ->  
  webServer.listen config.port, '0.0.0.0'
  webServer.on 'listening', () =>
    done()


    


