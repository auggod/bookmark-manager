require! {
  "gulp"
  "gulp-jade": jade
  "gulp-stylus": stylus
  "gulp-livereload": livereload
  "autoprefixer-stylus": autoprefixer
  "gulp-minify-css": minifyCSS
  "gulp-uglify": uglify
  "nib"
}

gulp.task 'templates', ->
  gulp.src('./**/*.jade')
    .pipe jade do
      pretty: true
    .pipe gulp.dest '.'

gulp.task 'stylus', ->
  gulp.src(['./app/styles/stylus/app.styl', './public/styles/stylus/login.styl']).pipe(stylus(use: [
    nib()
    autoprefixer(browsers: [
      'iOS >= 7'
      'Chrome >= 36'
      'Firefox >= 30'
    ]) 
  ])).pipe(gulp.dest('./app/styles/css'))

# Minify CSS
gulp.task 'minify-css', ->
  gulp.src './src/css/app.css'
    .pipe minifyCSS!
    .pipe gulp.dest './app/dist/css'

# Minify javascripts
gulp.task 'uglify', ->
  gulp.src './app/scripts/app.js'
    .pipe uglify({mangle:false})
    .pipe gulp.dest './app/dist'

gulp.task 'watch', ->
  gulp.watch('./**/*.jade', ['templates'])
  gulp.watch('./app/styles/**/*.styl', ['stylus'])
  gulp.watch './app/styles/css/*.css', ['minify-css']
  gulp.watch './app/scripts/app.js', ['uglify']

gulp.task 'default', [
  'uglify'
  'stylus'
  'templates'
  'watch'
]
