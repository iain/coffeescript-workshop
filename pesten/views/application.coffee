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
  alert("You clicked this button")

findPlayer = (player) ->
  $("#players li#player_#{player.id}")

addPlayer = (player) ->
  $('#players').append "<li id='player_#{player.id}'>#{player.name}</li>"

notice = (message, type="normal") ->
  $('#panel').append("<p class='#{type}'>#{message.replace(/</g, '&lt;')}</p>")
  $('#panel').scrollTop(1000000)
  focus()

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

jQuery ->
  $('#chat').click(handleChatClick)
  $('#join').click(handleJoinClick)
  $(window).click(focus)
  focus()
  chooseName()
