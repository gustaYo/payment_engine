async = __non_webpack_require__ 'async'
fs = __non_webpack_require__ 'fs'
mongoose = __non_webpack_require__ 'mongoose'
path = __non_webpack_require__ 'path'

class Consumer
  constructor: (@consumer = null) ->
    @testConnect()

  testConnect: () ->
    console.log 'prueba connexion'

  run: () ->
    @[@consumer.method] @consumer.parms

  getClient: (parms...) ->
    console.log parms

  setClient: (parms...) ->
    console.log parms

  getMatrixCells: (parms...) ->
    console.log parms

  validateMatrix: (parms...) ->
    console.log parms

  validateCardHolder: (parms...) ->
    console.log parms

  setUserCard: (parms...) ->
    console.log parms


exports.Consumer = Consumer
