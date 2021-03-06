// Generated by LiveScript 1.3.1
(function(){
  var gulp, jade, stylus, livereload, autoprefixer, minifyCSS, uglify, nib;
  gulp = require('gulp');
  jade = require('gulp-jade');
  stylus = require('gulp-stylus');
  livereload = require('gulp-livereload');
  autoprefixer = require('autoprefixer-stylus');
  minifyCSS = require('gulp-minify-css');
  uglify = require('gulp-uglify');
  nib = require('nib');
  gulp.task('templates', function(){
    return gulp.src('./**/*.jade').pipe(jade({
      pretty: true
    })).pipe(gulp.dest('.'));
  });
  gulp.task('stylus', function(){
    return gulp.src(['./app/styles/stylus/app.styl', './public/styles/stylus/login.styl']).pipe(stylus({
      use: [
        nib(), autoprefixer({
          browsers: ['iOS >= 7', 'Chrome >= 36', 'Firefox >= 30']
        })
      ]
    })).pipe(gulp.dest('./app/styles/css'));
  });
  gulp.task('minify-css', function(){
    return gulp.src('./src/css/app.css').pipe(minifyCSS()).pipe(gulp.dest('./app/dist/css'));
  });
  gulp.task('uglify', function(){
    return gulp.src('./app/scripts/app.js').pipe(uglify({
      mangle: false
    })).pipe(gulp.dest('./app/dist'));
  });
  gulp.task('watch', function(){
    gulp.watch('./**/*.jade', ['templates']);
    gulp.watch('./app/styles/**/*.styl', ['stylus']);
    gulp.watch('./app/styles/css/*.css', ['minify-css']);
    return gulp.watch('./app/scripts/app.js', ['uglify']);
  });
  gulp.task('default', ['uglify', 'stylus', 'templates', 'watch']);
}).call(this);
