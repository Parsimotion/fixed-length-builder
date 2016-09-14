_ = require("lodash")

module.exports =

class FixedLengthBuilder
  constructor: (@format, @delimiter = "\r\n") ->

  build: (objects, deburr) ->
    transform =
      if deburr then _.deburr
      else (d) => d

    transform objects.map(@_buildOne).join(@delimiter)

  _buildOne: (obj) =>
    mapColumn = (column) =>
      if column.repeat?
        return _.repeat column.repeat, column.length
        
      value = try eval "obj.#{column.name}"

      value = @
        ._padValue value, column
        .substr 0, column.length

    @format.map(mapColumn).join ""

  _padValue: (value, column) =>
    if not value? or value is ""
      return _.padStart " ", column.length

    if column.decimals? and _.isNumber(value)
      fillWithZeros = (val) -> _.padStart(val, column.length, "0")
      formattedNumber = fillWithZeros value.toFixed(column.decimals)

      if column.withDot is false
        fillWithZeros formattedNumber.replace(".", "")
      else formattedNumber
    else
      _.padEnd value, column.length