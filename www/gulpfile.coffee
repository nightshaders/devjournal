# Tools needed by or for gulp tasks
gulp       = require('gulp')
plugins    = require('gulp-load-plugins')()
stylus     = require('gulp-stylus')
jade       = require('gulp-jade')
data       = require('gulp-data')
tap        = require('gulp-tap')
rename     = require('gulp-rename')
run        = require('gulp-run')
plumber    = require('gulp-plumber')
concat     = require('gulp-concat')
merge      = require('merge2')
del        = require('del')
runSeq     = require('run-sequence')
path       = require('path')
fs         = require('fs')
crypto     = require('crypto')
_          = require('lodash')
glob       = require('glob')
karma      = require('karma')
sorted     = require('./sh/build/sorted')
hasher     = require('./sh/build/hasher')
fontHasher = require('./sh/build/font-hasher')


# Helpers to Orchestrate each task
dest      = gulp.dest
cwdbase   = false
bower     = -> { cwdbase: cwdbase, cwd: './bower_components' }
site      = -> { cwdbase: cwdbase, cwd: './src/site/' }
html      = -> { cwdbase: cwdbase, cwd: './src/site/html' }
styles    = -> { cwdbase: cwdbase, cwd: './src/site/styles' }
scripts   = -> { cwdbase: cwdbase, cwd: './src/site/scripts' }
images    = -> { cwdbase: cwdbase, cwd: './src/site/images' }
component = -> { cwdbase: cwdbase, cwd: './src/site/components' }
fonts     = -> { cwdbase: cwdbase, cwd: './src/site/fonts' }
temp      = -> dest('./dest/_temp/')
seq       = (args...) -> (cb) -> runSeq.apply(null, args.concat(cb))


# Used to organize generated assets
model     = require('./src/data/file-changes.coffee')
vals      = { hash:'not-hashed' }
all       = (ext...) -> ("**/*.#{e}" for e in ext)
libs      = ['angular/angular.min.js', 'lodash/lodash.min.js']
hashName  = (md5, ext='ttf') -> path.join(process.cwd(), './dest/_site', md5 + "." + ext)


# Tasks/Targets
gulp.task 'build', seq('dir:_temp','build:assets')
gulp.task 'dir:_temp', (cb) -> run('mkdir -p dest/_temp').exec(cb)
gulp.task 'build:assets', ->
  merge(
    gulp.src(libs                 , bower()).pipe(temp())
    gulp.src('combined.styl'      , styles()).pipe(stylus()).pipe(temp())
    gulp.src(all('coffee', 'js')  , scripts()).pipe(plugins.coffee()).pipe(temp())
    gulp.src(all('coffee', 'js')  , component()).pipe(plugins.coffee()).pipe(temp())
    gulp.src('**/*.html'          , site()).pipe(temp())
    gulp.src('**/*.ico'           , images()).pipe(temp())
    gulp.src('**/*.css'           , component()).pipe(temp())
    gulp.src('**/*.ttf'           , fonts()).pipe(temp())
  )


gulp.task 'build:jade', ->
  gulp.src('**/*.jade', html())
    .pipe(plumber())
    .pipe(data(->
      vals = _.defaults({}, model, vals)
      vals
    ))
    .pipe(jade({ pretty: true }))
    .pipe(temp())


gulp.task 'site:js:cat', ->
  jsOrder   = ['angular.min.js','lodash.min.js', 'App.js']
  files = glob.sync('./dest/_temp/**/*.js')
  nowSorted = sorted(files, jsOrder)
  console.log(nowSorted)
  gulp.src(nowSorted)
    .pipe(plumber())
    .pipe(concat('all.cjs'))
    .pipe(dest('./dest/_temp'))


gulp.task 'site:css:cat', ->
  cssOrder  = ['fonts.css','combined.css']
  files     = glob.sync('./dest/_temp/**/*.css')
  files     = _.without(files, "./dest/_temp/all.combined.css")
  nowSorted = sorted(files, cssOrder)
  console.log(nowSorted)
  gulp.src(nowSorted)
    .pipe(plumber())
    .pipe(concat('all.combined.css'))
    .pipe(dest('./dest/_temp'))


gulp.task 'site:js:hash', ->
  hasher.writeHash('./dest/_temp/all.cjs', (md5) ->
    hash = "all-#{md5}.js"
    vals.js = hash: '/' + hash
    path.join(process.cwd(), './dest/_site', hash))

gulp.task 'site:css:hash', ->
  hasher.writeHash('./dest/_temp/all.combined.css', (md5) ->
    hash = "combined-#{md5}.css"
    vals.css = hash: '/' + hash
    path.join(process.cwd(), './dest/_site', hash))


gulp.task 'font:hash', ->
  siteFile = path.join("./dest/_temp/", "fonts.css")  
  fontHasher(model.fonts, siteFile)


gulp.task 'dir:_site', (cb) -> run('mkdir -p dest/_site').exec(cb)
gulp.task 'site', seq(
    'dir:_site',      # make _site
    'build',          # make _temp, copy assets, compile stylus
    'site:js:cat',    # cat _temp/*.js
    'site:js:hash',   # hash cat of _temp/*.js
    'font:hash',      # create .css of fonts with md5 fingerprints
    'site:css:cat',   # cat .css with newly created font css
    'site:css:hash',  # hash fingerprint of css for html
    'build:jade',     # build html using fingerprints
    'site:assets'     # move html to _site
  )


gulp.task 'site:assets', ->
  buildAssets = ['dest/_temp/index.html']
  gulp.src(buildAssets).pipe(dest('./dest/_site'))


gulp.task 'watch', ->
  ext = 'coffee styl js html jade css'.split(' ')
  gulp.watch(("src/**/*.#{e}" for e in ext), ['site'])


gulp.task 'default', ['site', 'watch'], ->
