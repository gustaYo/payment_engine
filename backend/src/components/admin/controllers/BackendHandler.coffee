{BaseQueueHandler} = __non_webpack_require__ 'rabbit-queue'
{FactoryProvider} = require '../services/factory.coffee'

`
    class DemoHandler extends BaseQueueHandler {
        handle({msg, event, correlationId, startTime}) {
            console.log('Received: ', event);
            console.log('With correlation id: ' + correlationId);
`
parms =
    office: 'bpa'
    method: 'getClient'
    parms: event

    
return new FactoryProvider().factory(parms).run()

`
        }

        afterDlq({msg, event}) {
            // Something to do after added to dlq
        }
    }

`
###

class DemoHandler extends BaseQueueHandler
  constructor: () ->

  this::handle({msg, event, correlationId, startTime}) ->
    console.log('Received: ', event);
    return Promise.resolve(event)

###


exports.BackendHandler = DemoHandler