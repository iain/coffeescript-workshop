class @Game

  rolls = null

  constructor: ->
    rolls = []

  roll: (pins) ->
    rolls.push(pins)

  score: ->
    score = 0
    frameIndex = 0
    for frame in [0...10]
      switch
        when isStrike(frameIndex)
          score += 10 + strikeBonus(frameIndex)
          frameIndex += 1
        when isSpare(frameIndex)
          score += 10 + spareBonus(frameIndex)
          frameIndex += 2
        else
          score += sumOfBallsInFrame(frameIndex)
          frameIndex += 2
    score

  isStrike = (frameIndex) ->
    rolls[frameIndex] == 10

  sumOfBallsInFrame = (frameIndex) ->
    rolls[frameIndex] + rolls[frameIndex + 1]

  spareBonus = (frameIndex) ->
    rolls[frameIndex + 2]

  strikeBonus = (frameIndex) ->
    rolls[frameIndex + 1] + rolls[frameIndex + 2]

  isSpare = (frameIndex) ->
    sumOfBallsInFrame(frameIndex) == 10
