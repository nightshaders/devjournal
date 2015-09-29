_     = require('lodash')
path  = require('path')


module.exports = (files, order) ->
  order = [null].concat(order)
  files.sort((a1,b1) ->
    a = path.basename(a1)
    b = path.basename(b1)
    an = _.indexOf(order, path.basename(a), 0)
    bn = _.indexOf(order, path.basename(b), 0)

    if an < 0 && bn < 0 then files.length
    else if an < 0 then files.length
    else if bn < 0 then -files.length
    else an - bn
  )
