{BPAProvider} = require './bpa.coffee'

class FactoryProvider
  constructor: () ->
    console.log 'loading provider'

  factory: (parms) =>
    switch parms.office
      when "bpa" then new BPAProvider parms
      when "other" then new BPAProvider parms
      else console.log 'not found'

exports.FactoryProvider = FactoryProvider




