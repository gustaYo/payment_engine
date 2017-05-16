{Consumer} = require './base.coffee'
class BPAProvider extends Consumer
  constructor: ->
    super

  testConnect: () ->
    console.log 'Conectado al BPA'

  getClient: (parms...) ->
    new Promise (resolve, reject) ->
      console.log 'obteniendo cliente del bpa'
      success = true
      if success
        console.log parms[0]
        timeTimeout = setTimeout () =>
          resolve parms[0]
        , 100
        #resolve parms[0]
      else
        reject new Error('test Error')


exports.BPAProvider = BPAProvider    