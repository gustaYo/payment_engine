module.exports = (app, express, io, config) =>
  moment = __non_webpack_require__ 'moment'
  morgan = __non_webpack_require__ 'morgan'

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
  {BackendHandler} = require './components/admin/controllers/BackendHandler.coffee'

  new BackendHandler(tail, rabbit, config.rabbitMQ.handler.options) for tail in config.rabbitMQ.handler.tails
      

  require('./components/user/index.coffee')(app, express)