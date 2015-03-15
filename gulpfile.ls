gulp = require('gulp')
jade = require('gulp-jade')
stylus = require('gulp-stylus')
autoprefixer = require('autoprefixer-stylus')
nib = require('nib')

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

gulp.task 'compress', ->
  gulp.src(['./app/styles/stylus/app.styl', './public/styles/stylus/login.styl']).pipe(stylus(
    use: [
      nib()
      autoprefixer(browsers: [
        'iOS >= 7'
        'Chrome >= 36'
        'Firefox >= 30'
      ])   
    ]
    compress: true)).pipe gulp.dest('./app/dist')

gulp.task 'watch', ->
  gulp.watch('./**/*.jade',['templates']);
  gulp.watch('./app/styles/**/*.styl',['stylus', 'compress'])

# Default Task
gulp.task 'default', [
  'stylus'
  'compress'
  'templates'
  'watch'
]
