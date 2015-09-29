fs      = require('fs')
crypto  = require('crypto')
path    = require('path')



module.exports = do ->

  getHash = (infile) ->
    code = fs.readFileSync(infile)
    hash : crypto.createHash('md5').update(code).digest('hex')
    src  : code

  writeHash = (infile, customName) ->
    hashed = getHash(infile)
    filename = customName(hashed.hash)
    fs.writeFileSync(filename, hashed.src)

  {
    getHash
    writeHash
  }