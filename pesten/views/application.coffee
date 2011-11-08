app = { }

socket = io.connect()

chooseName = ->
  app.name = window.location.search.substring(1)
  app.name = prompt "Pick a nickname!" until hasName()
  socket.emit 'join room', name: app.name

hasName = ->
  app.name? && app.name.replace(/^\s+|\s+$/g, '') != ""

focus = ->
  $('#box').focus()

handleChatClick = (event) ->
  event.preventDefault()
  box = $('#box')
  socket.emit 'say', box.val()
  box.val('').focus()

handleCardClick = (event) ->
  cardId = event.target.id.replace('card_', '')
  socket.emit 'play card', cardId: +cardId

handleJoinClick = (event) =>
  event.preventDefault()
  $(event.target).remove()
  socket.emit 'join game'

handleResetClick = (event) =>
  event.preventDefault()
  if confirm("Are you sure you want to reset the game?")
    socket.emit "reset game"

findPlayer = (player) ->
  $("#players li#player_#{player.id}")

addPlayer = (player) ->
  $('#players').append "<li id='player_#{player.id}'>#{player.name}</li>"

notice = (message, type="normal") ->
  $('#panel').append("<p class='#{type}'>#{message.replace(/</g, '&lt;')}</p>")
  $('#panel').scrollTop(1000000)

putOnStack = (card) ->
  $('#stack img').remove()
  $('#stack').append("<img class='card' src='/images/#{card.image}'>")

socket.on 'welcome', (data) ->
  notice "Welcome, #{data.player.name}"
  addPlayer(player) for player in data.others
  findPlayer(data.player).addClass('me')
  app.player = data.player

socket.on 'player joined', (data) ->
  notice "Player #{data.player.name} has joined the room"
  addPlayer(data.player)

socket.on 'player left', (data) ->
  notice "Player #{data.player.name} has left the room"
  findPlayer(data.player).remove()

socket.on 'you said', (data) ->
  notice "You said: #{data.message}", 'youSaid'

socket.on 'player said', (data) ->
  notice "#{data.player.name} said: #{data.message}", 'playerSaid'

socket.on 'recieve cards', (data) ->
  notice "You got #{data.cards.length} cards"
  for card in data.cards
    image = $("<img id='card_#{card.id}' class='card' src='/images/#{card.image}'>")
    image.click(handleCardClick)
    $("#cards").append(image)

socket.on 'joined game', (data) ->
  notice "Player #{data.player.name} joined the game"

socket.on 'card played', (data) ->
  notice "Player #{data.player.name} played #{data.card.name}"
  putOnStack(data.card)

socket.on 'card accepted', (data) ->
  notice "You played the #{data.card.name}"
  $("#cards #card_#{data.card.id}").remove()
  putOnStack(data.card)

socket.on 'card rejected', ->
  notice "That card is not allowed to be played"

socket.on 'reset', (data) ->
  notice "Player #{data.player.name} has reset the game"
  $("#stack img").remove()
  $("#cards img").remove()
  $("#cards button").remove()
  button = $("<button id='join' class='btn primary'>Join Game!</button>")
  $("#cards").append(button)
  button.click(handleJoinClick)


jQuery ->
  $('#chat').click(handleChatClick)
  $('#join').click(handleJoinClick)
  $('#reset').click(handleResetClick)
  $(window).click(focus)
  focus()
  chooseName()
