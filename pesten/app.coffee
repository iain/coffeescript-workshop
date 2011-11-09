express = require('express')
app = express.createServer()
io = require('socket.io').listen(app)
pesten = require('./pesten')
Game = new pesten.Game()
restarted = true

app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(__dirname + '/public')

app.configure 'development', ->
  app.use express.errorHandler({ dumpExceptions: true, showStack: true })

app.configure 'production', ->
  app.use express.errorHandler()

io.sockets.on 'connection', (socket) ->

  socket.on 'disconnect', () ->
    socket.get 'player', (err, player) ->
      if player?
        io.sockets.emit('player left', player: player)
        Game.leaveRoom(player)

  socket.on 'join room', (data) ->
    player = Game.joinRoom(data.name)
    socket.set 'player', player, ->
      socket.emit 'welcome', player: player, others: Game.playersInRoom()
      socket.broadcast.emit 'player joined', player: player

  socket.on 'say', (message) ->
    socket.get 'player', (err, player) ->
      socket.broadcast.emit 'player said', player: player, message: message
      socket.emit 'you said', message: message

app.listen(3000)
console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env)
