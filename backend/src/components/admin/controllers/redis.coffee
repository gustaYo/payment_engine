redis = __non_webpack_require__ 'redis'
monitoring = false
client = redis.createClient()

if monitoring
  client.monitor  (err, res) ->
    console.log "Entering monitoring mode."

  client.on "monitor", (time, args, raw_reply) ->
    console.log time + ": " + args

client
.on "connect", () ->
  client.get "foo_rand000000000000", redis.print
.on "error", (err) ->
  console.log "Error " + err


exports.redisClient = client