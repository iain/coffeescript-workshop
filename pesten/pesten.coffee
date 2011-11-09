class @Game

  constructor: ->
    @players = {}
    @lastPlayerId = 0

  joinRoom: (name) ->
    player = new Player(@lastPlayerId++, name)
    @players[player.id] = player
    player

  leaveRoom: (player) ->
    delete @players[player.id]

  playersInRoom: ->
    { id: id, name: player.name } for own id, player of @players

class Player

  constructor: (@id, @name) ->
