path    = require 'path'
fs      = require 'fs'
hasher  = require './hasher'
_       = require 'lodash'

tpl = """
@font-face {
  font-family: '<%= family %>';
  src: url('/<%= siteName %>') format('<%= format %>');
  font-weight: <%= weight %>;
  font-style: <%= style %>;
}

"""


module.exports = (fonts, siteFile, from='./dest/_temp/', to='./dest/_site/') ->
  code = ""
  for f in fonts
    tempName = path.join(from, "#{f.filename}.#{f.ext}")
    hashed = hasher.getHash(tempName)
    siteName = "#{f.filename}-#{hashed.hash}.#{f.ext}"

    f.siteName = siteName
    code += _.template(tpl)(f)

    newName = path.join(to, siteName)
    fs.writeFileSync(newName, hashed.src)

  fs.writeFileSync(siteFile, code)

