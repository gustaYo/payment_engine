  
 const server = require('rabbit-queue');
 const Rabbit = server.Rabbit
 const BaseQueueHandler = server.BaseQueueHandler

var fs = require('fs');

// Options for full client and server verification:
var opts = {
  //cert: fs.readFileSync('../etc/client/cert.pem'),
  //key: fs.readFileSync('../etc/client/key.pem'),
  // cert and key or
  // pfx: fs.readFileSync('../etc/client/keycert.p12'),
  //passphrase: 'MySecretPassword',
  //ca: [fs.readFileSync('../etc/testca/cacert.pem')]
};

    const rabbit = new Rabbit(process.env.RABBIT_URL || 'amqp://guest:guest@localhost:5672', {
    prefetch: 1, //default prefetch from queue
    replyPattern: true, //if reply pattern is enabled an exclusive queue is created    
    scheduledPublish: false,
    prefix: '', //prefix all queues with an application name
    socketOptions: opts // socketOptions will be passed as a second param to amqp.connect and from ther to the socket library (net or tls)
  });

  rabbit.on('connected', () => {
    console.log('conectado correctamente')
  });

  rabbit.on('disconnected', (err = new Error('Rabbitmq Disconnected')) => {
    //handle disconnections and try to reconnect
    console.error(err);
    setTimeout(() => rabbit.reconnect(), 100);
  });

  class DemoHandler extends BaseQueueHandler {
    handle({msg, event, correlationId, startTime}) {
      console.log('Received: ', event);
      console.log('With correlation id: ' + correlationId);
      if(true){
			return Promise.resolve(event); // could be return 'reply';
      }else{
      	return Promise.reject(new Error('test Error'));
      }      
    }

    afterDlq({msg, event}) {
      // Something to do after added to dlq
    }
  }

  new DemoHandler('demoQueue', rabbit,
    {
      retries: 3,
      retryDelay: 1000,
      scope: 'SINGLETON'
    });