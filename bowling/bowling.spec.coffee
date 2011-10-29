# Bowling Game specs converted from Java to CoffeeScript from Uncle Bob's CodeKata
# http://butunclebob.com/ArticleS.UncleBob.TheBowlingGameKata

bowling = require('./bowling')

describe "Bowling", ->

  describe 'a gutter game', ->

    it 'has score of 0', ->
      rollMany(20, 0)
      expectScoreToBe(0)

  describe 'all ones', ->

    it 'has score of 20', ->
      rollMany(20, 1)
      expectScoreToBe(20)

  describe 'a spare', ->

    it 'doubles the score of the next role', ->
      rollSpare()
      roll(3)
      rollMany(17, 0)
      expectScoreToBe(16)

  describe 'a strike', ->

    it 'doubles the score of the next two rolls', ->
      rollStrike()
      roll(3)
      roll(4)
      rollMany(16, 0)
      expectScoreToBe(24)

  describe 'a perfect game', ->

    it 'has score of 300', ->
      rollMany(12, 10)
      expectScoreToBe(300)

  game = null

  beforeEach ->
    game = new bowling.Game()

  rollMany = (amount, pins) ->
    roll(pins) for i in [1..amount]

  rollSpare = ->
    roll(5)
    roll(5)

  rollStrike = ->
    roll(10)

  roll = (pins) ->
    game.roll(pins)

  expectScoreToBe = (score) ->
    expect(game.score()).toBe(score)
