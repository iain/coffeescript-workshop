# These are just to test if you've setup your environment properly
# Run it with the following command:
#
#   jasmine-node --coffee example
#
# You should get the following output:
#
#     Started
#     .F
#
#     test
#       it fails
#       Error: Expected 3 to be 4.
#         at [object Object].<anonymous> (/example/example.spec.coffee:9:45)
#
#     Finished in 0.003 seconds
#     1 test, 2 assertions, 1 failure
#

subject = require './example'

describe "incrementer", ->

  it "passes", ->
    expect(subject.incrementer(1)).toBe(2)

  it "fails", ->
    expect(subject.incrementer(2)).toBe(4)
