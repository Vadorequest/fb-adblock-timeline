gulp = require 'gulp'
coffee = require 'gulp-coffee'
sass = require 'gulp-sass'
minifyCss = require 'gulp-minify-css'
plumber = require 'gulp-plumber'
inject = require 'gulp-inject'
rename = require 'gulp-rename'
cleaning = require 'gulp-initial-cleaning'
coffeelint = require 'gulp-coffeelint'
notifier = require 'node-notifier'
htmlmin = require 'gulp-htmlmin'
uglify = require 'gulp-uglify'
concat = require 'gulp-concat'
sassLint = require 'gulp-sass-lint'
cache = require 'gulp-cached'

try
    pkg = require('./package.json')
catch e
    console.log e
    throw 'package.json could not be read. Abort.'

# Delete the folder "dist" before running the "default" and "look" tasks.
cleaning(
    tasks: [
        'default'
        'look'
    ]
    folders: ['dist']
)

gulp.task 'coffee-userscript', ->
    gulp.src('src/**/*.coffee')
    .pipe(plumber())
    .pipe(cache('userscript'))
    .pipe(coffeelint('coffeelint.json'))
    .pipe(coffeelint.reporter())
    .pipe(coffee(bare: true))
    .pipe(uglify(preserveComments: (node, comment) ->
        if comment.value.startsWith '// @' or
        comment.value.startsWith '// =='
            return false
        return true
    ))
    .pipe(rename("userscript/#{pkg.name}.user.js"))
    .pipe(gulp.dest('dist/'))

gulp.task 'coffee', ->
    gulp.src('src/**/*.coffee')
    .pipe(plumber())
    .pipe(cache('coffee'))
    .pipe(coffeelint('coffeelint.json'))
    .pipe(coffeelint.reporter())
    .pipe(coffee(bare: true))
    .pipe(gulp.dest('dist/src/'))

gulp.task 'assets', ->
    gulp.src 'assets/**/*'
    .pipe(cache('assets'))
    .pipe(gulp.dest('dist/assets/'))

gulp.task 'html', ['coffee'], ->
    gulp.src('src/*.html')
    .pipe(plumber())
    .pipe(cache('html'))
    .pipe(gulp.dest('dist/src/'))

gulp.task 'sass-lint', ->
    gulp.src('src/**/*.sass')
    .pipe(plumber())
    .pipe(cache('sass-lint'))
    .pipe(sassLint())
    .pipe(sassLint.format())
    .pipe(sassLint.failOnError())

gulp.task 'sass', ['sass-lint'], ->
    gulp.src([
        'src/vars.sass'
        'src/**/*.sass'
    ])
    .pipe(concat('index.sass'))
    .pipe(plumber())
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest('dist/src/'))

finished = ->
    notifier.notify(
        title: 'Gulp'
        message: 'Finished'
    )

# Usable tasks.
gulp.task 'default', [
    'coffee'
    'sass'
    'html'
    'assets'
    'coffee-userscript'
], finished

gulp.task 'look', ['default'], ->
    gulp.watch 'src/**/*.*', ['default']
