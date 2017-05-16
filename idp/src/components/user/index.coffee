
module.exports = (app, express) ->
  require('./routers/user.coffee')(app, express)
