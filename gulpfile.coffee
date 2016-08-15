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

# -------------- Misc --------------

try
    pkg = require('./package.json')
catch e
    console.log e
    throw 'package.json could not be read. Abort.'

finished = (message = 'Finished') ->
    notifier.notify(
        title: 'Gulp'
        message: message
    )

# Delete the folder "dist" before running the "default" and "look" tasks.
cleaning(
    tasks: [
        'default'
        'look'
    ]
    folders: ['dist']
)

gulp.task 'sass-lint', ->
    gulp.src('src/**/*.sass')
    .pipe(plumber())
    .pipe(cache('sass-lint'))
    .pipe(sassLint())
    .pipe(sassLint.format())
    .pipe(sassLint.failOnError())

# -------------- Userscript --------------

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

# -------------- Chrome extension --------------

gulp.task 'coffee-chrome', ->
    gulp.src('src/**/*.coffee')
    .pipe(plumber())
    .pipe(cache('coffee'))
    .pipe(coffeelint('coffeelint.json'))
    .pipe(coffeelint.reporter())
    .pipe(coffee(bare: true))
    .pipe(uglify())
    .pipe(gulp.dest('dist/chrome/'))

gulp.task 'assets-chrome', ->
    gulp.src 'src/assets/**/*'
    .pipe(cache('assets'))
    .pipe(gulp.dest('dist/chrome/assets/'))

gulp.task 'manifest-chrome', ->
    gulp.src 'src/manifest.json'
    .pipe(cache('manifest-chrome'))
    .pipe(gulp.dest('dist/chrome/'))

gulp.task 'sass-chrome', ['sass-lint'], ->
    gulp.src([
        'src/vars.sass'
        'src/**/*.sass'
    ])
    .pipe(concat('index.sass'))
    .pipe(plumber())
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest('dist/chrome/'))

gulp.task 'html-chrome', ['coffee-chrome'], ->
    gulp.src('src/*.html')
    .pipe(plumber())
    .pipe(cache('html'))
    .pipe(gulp.dest('dist/chrome/'))

gulp.task 'locales-chrome', ['coffee-chrome'], ->
    gulp.src('src/_locales/**/*.json')
    .pipe(plumber())
    .pipe(cache('html'))
    .pipe(gulp.dest('dist/chrome/_locales/'))

# ----------------- Tasks to use ------------------ #

# Chrome extension.
gulp.task 'chrome', [
    'coffee-chrome'
    'assets-chrome'
    'manifest-chrome'
    'sass-chrome'
    'html-chrome'
    'locales-chrome'
]

# Userscript
gulp.task 'userscript', [
    'coffee-userscript'
]

# Default task: build everything.
gulp.task 'default', [
    'chrome'
    'userscript'
], finished.bind(this, 'Chrome and userscript ready.')

# Look for any change and rebuild everything.
gulp.task 'look', ['default'], ->
    gulp.watch 'src/**/*.*', ['default']
