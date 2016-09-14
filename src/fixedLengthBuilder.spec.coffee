require "should"
FixedLengthBuilder = require("./fixedLengthBuilder")

describe "FixedLengthBuilder", ->
  it "can build a fixed length string from a specific format", ->
    builder = new FixedLengthBuilder [
      { name: "name", length: 3 }
      { name: "dogs[0].description", length: 8 }
      { name: "balance", length: 10, decimals: 2 },
      { repeat: "-", length: 2 }
      { name: "energy", length: 7, decimals: 4, withDot: false }
    ], "\n"

    people = [
      { name: "Rodrigo", dogs: [{ description: "Willy", happyness: 10.5 }], balance: 123.246, energy: 101.3 }
      { name: "Charly", dogs: [{ description: "Octocat", happyness: 99 }], balance: 22323.1, energy: 300 }
    ]

    builder.build(people).should
      .eql "RodWilly   0000123.25--1013000\nChaOctocat 0022323.10--3000000"

  it "uses \r\n as default delimiter", ->
    builder = new FixedLengthBuilder [
      { name: "a", length: 1 }
    ]

    input = [
      { a: "H" }
      { a: "O" }
      { a: "L" }
      { a: "A" }
    ]

    builder.build(input).should.eql "H\r\nO\r\nL\r\nA"

  it "puts an empty string if a field is null or empty", ->
    builder = new FixedLengthBuilder [
      { name: "fruit_property", length: 4, decimals: 20 }
      { name: "fruit_property.deep", length: 3 }
      { name: "empty", length: 2 }
    ]

    input = [ { name: "Juan Carlos", empty: "" }]

    builder.build(input).should.eql "         "

  it "truncates the string if the length isn't big enough", ->
    builder = new FixedLengthBuilder [
      { name: "name", length: 3 }
    ], ""

    input = [
      { name: "Ayukawa" }
      { name: "Kinomoto" }
    ]

    builder.build(input).should.eql "AyuKin"

  it "truncates the number if the length isn't big enough", ->
    builder = new FixedLengthBuilder [
      { name: "price", length: 5, decimals: 2 }
    ], "\n"

    input = [
      { price: 130.451 }
      { price: 13132.5 }
    ]

    builder.build(input).should.eql "130.4\n13132"

  it "rounds the number to fix the decimals", ->
    builder = new FixedLengthBuilder [
      { name: "amount", length: 9, decimals: 3 }
    ]

    input = [{ amount: 130.4577 }]

    builder.build(input).should.eql "00130.458"