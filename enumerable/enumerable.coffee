stopSignal = { message: "This should trigger a break call" }

@stopSignal = stopSignal

@include = (klass) ->

  stop = -> throw stopSignal

  klass::map = (callback) ->
    result = []
    @each (item) ->
      result.push(callback(item))
    result

  klass::find = (callback) ->
    result = null
    @each (item) ->
      if result == null && callback(item)
        result = item
        stop()
    result

  klass::select = (callback) ->
    result = []
    @each (item) ->
      result.push(item) if callback(item)
    result

  klass::reduce = (initial, callback) ->
    @each (item) ->
      initial = callback(initial, item)
    initial

  klass::maxBy = (callback) ->
    max = null
    maxValue = null
    @each (item) ->
      value = callback(item)
      if maxValue == null || value > maxValue
        max = item
        maxValue = value
    max

  klass::eachWithIndex = (callback) ->
    index = 0
    @each (item) ->
      callback(item, index++)

  klass::groupBy = (callback) ->
    result = {}
    @each (item) ->
      value = callback(item)
      result[value] ||= []
      result[value].push(item)
    result

  klass::eachCons = (size, callback) ->
    part = []
    @eachWithIndex (item, index) ->
      part.push(item)
      if (index + 1) % size == 0
        callback(part.slice(0))
        part = []
    callback(part)

  klass::first = (size) ->
    result = null
    if arguments.length == 0
      @each (item) ->
        result = item
        stop()
    else
      result = []
      @eachWithIndex (item, index) ->
        stop() if index >= size
        result.push(item)

    result
