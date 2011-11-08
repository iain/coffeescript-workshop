class @Game

  constructor: ->
    @players = {}
    @lastPlayerId = 0
    @init()

  init: ->
    @deck = new Deck()
    @stack = new Stack()

  joinRoom: (name) ->
    player = new Player(@lastPlayerId++, name)
    @players[player.id] = player
    player

  leaveRoom: (player) ->
    delete @players[player.id]

  playersInRoom: ->
    { id: id, name: player.name } for own id, player of @players

  joinGame: (player) ->
    player.giveCards @deck.getCards(7)

  playCard: (player, card) ->
    @stack.push(card)

  getCard: (id) ->
    new Card(id)

  reset: ->
    for own id, player in @players
      player.takeBackCards()
    @init()

class Card

  constructor: (@id) ->
    @image = @getImage()
    @name = @getName()

  getImage: ->
    "200px-Playing_card_#{@form()}_#{@symbol()}.png"

  getName: ->
    symbol = { A: "ace", J: "jack", Q: "queen", K: "king" }[@symbol()]
    symbol ||= @symbol()
    "#{symbol} of #{@form()}s"

  form: ->
    forms = [ "heart", "diamond", "spade", "club" ]
    forms[@id % 4]

  symbol: ->
    value = (@id % 13) + 1
    switch value
      when 1 then "A"
      when 11 then "J"
      when 12 then "Q"
      when 13 then "K"
      else value


class Deck

  constructor: ->
    @_cards = [1..52]

  getCards: (num) ->
    results = []
    for i in [0...num]
      idx = Math.floor(Math.random() * @_cards.length)
      results.push(new Card(@_cards[idx]))
      @_cards.splice(idx, 1)
    results

class Stack

  constructor: ->
    @_stack = []

  isValid: (card) ->
    @_stack.length == 0 || @sameSymbolOrFormAsLast(card)

  push: (card) ->
    return false if not @isValid(card)
    @_stack.push(card.id)
    true

  sameSymbolOrFormAsLast: (card) ->
    last = new Card(@_stack[@_stack.length - 1])
    now = new Card(card.id)
    last.symbol() == now.symbol() || last.form() == now.form()

class Player

  constructor: (@id, @name) ->
    @cards = []

  giveCards: (cards) ->
    for card in cards
      @cards.push(card)

  takeBackCards: ->
    @cards.splice(0, @cards.length)
