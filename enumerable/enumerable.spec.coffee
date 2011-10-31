# One of my favorite parts of Ruby is the Enumerable mixin. The Enumerable mixin provides collection
# classes with several traversal and searching methods, and with the ability to sort. The class must
# provide a method each, which yields successive members of the collection.
#
# See more: http://www.ruby-doc.org/core-1.9.2/Enumerable.html
#
# This exercise is a way to mimic Ruby's Enumerable. To test it, we use a simple TestCollection
# class, which is just a tight wrapper around an array. In real life you could imagine it to be some
# sort of lazy loading collection.
#
# There is one tiny difference between Ruby blocks and JavaScript functions: You cannot abort the
# callback calling by calling return. So in Ruby, this loop will only execute once:
#
#     collection.each { return }
#
# In JavaScript/CoffeeScript, this will not work, it will only shortcircuit the callback. That's why
# I've used an exception to stop the each function from looping. In real life, this might signal it
# to stop fetching records from the server.

Enumerable = require('./enumerable')

class TestCollection
  Enumerable.include(this)

  my = {}

  constructor: (collection) ->
    my.collection = collection

  each: (callback) =>
    for item in my.collection
      try
        callback(item)
      catch error
        break if error == Enumerable.stopSignal



describe "Enumerable", ->

  describe "map", ->

    it "changes the values", ->
      subject = collection([1, 2, 3, 4]).map((i)-> i + 1)
      expect(subject).toBeSameArrayAs([2, 3, 4, 5])

  describe "find", ->

    it "returns the first value that matches", ->
      result = collection([1, 2, 3, 4, 5, 6]).find((i) -> i % 3 == 0)
      expect(result).toBe(3)

  describe 'select', ->

    it "keeps values when the function returns truethy", ->
      subject = collection([1, 2, 3, 4]).select((i) -> i % 2 == 0)
      expect(subject).toBeSameArrayAs([2, 4])

  describe "reduce", ->

    it "reduces the collection to one outcome with an inital value", ->
      result = collection([1, 2, 3]).reduce(5, (sum, i) -> sum += i)
      expect(result).toBe(11)

  describe "maxBy", ->

    it "finds the maximum value given the function", ->
      result = collection([ 0, 1, 2, 3, 4, 5 ]).maxBy((i) -> Math.sin(i))
      expect(result).toBe(2)


  describe "eachWithIndex", ->

    it "runs the callbacks with an index", ->
      result = {}
      collection([ "a", "b", "c" ]).eachWithIndex (item, index) ->
        result[item] = index
      expect(result["a"]).toBe(0)
      expect(result["b"]).toBe(1)
      expect(result["c"]).toBe(2)

  describe "first", ->

    it "will get the first item", ->
      expect(collection([1,2,3]).first()).toBe(1)

    it "will get an array of items", ->
      expect(collection([1,2,3]).first(2)).toBeSameArrayAs([1,2])

    it "will return an array of one", ->
      expect(collection([1,2,3]).first(1)).toBeSameArrayAs([1])


  describe "groupBy", ->

    it "groups by the result of the function", ->
      result = collection([1,2,3]).groupBy((i) -> i % 2 == 0)
      expect(result[true]).toBeSameArrayAs([2])
      expect(result[false]).toBeSameArrayAs([1,3])

  describe "eachCons", ->

    it "calls the callback in groups of consecutive items", ->
      result = []
      collection([ 0, 1, 2, 3, 4, 5, 6 ]).eachCons(3, (i) -> result.push(i))
      expect(result.length).toBe(3)
      expect(result[0]).toBeSameArrayAs([0,1,2])
      expect(result[1]).toBeSameArrayAs([3,4,5])
      expect(result[2]).toBeSameArrayAs([6])


  collection = (args) ->
    new TestCollection(args)


  beforeEach ->
    @addMatchers
      toBeSameArrayAs: (expected) ->
        return false unless @actual?
        return false unless expected.length == @actual.length
        result = true
        for item in @actual
          result = false unless expected[_i] == item
        result
