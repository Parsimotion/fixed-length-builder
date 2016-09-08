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
      value = try eval "obj.#{column.name}"

      value = @
        ._padValue value, column
        .substr 0, column.length

    @format.map(mapColumn).join ""

  _padValue: (value, column) =>
    if not value? or value is ""
      return _.padStart " ", column.length

    if column.decimals? and _.isNumber(value)
      _.padStart(
        value.toFixed(column.decimals),
        column.length,
        "0"
      )
    else
      _.padEnd value, column.length