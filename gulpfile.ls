require! <[gulp webpack]>
gutil = require 'gulp-util'
mocha = require 'gulp-mocha'
Webpack-dev-server = require 'webpack-dev-server'
webpack-config = require './webpack.config.ls'

# The development server (the recommended option for development)
gulp.task 'default', ['webpack-dev-server']

gulp.task 'test', (callback) ->
  gulp.src './tests/*.spec.ls'
  .pipe mocha reporter: 'dot'

# Build and watch cycle (another option for development)
# Advantage: No server required, can run app from filesystem
# Disadvantage: Requests are not blocked until bundle is available,
#               can serve an old app on refresh
gulp.task 'build-dev' ['webpack:build-dev'] ->
  gulp.watch <[
                src/**/*
                tests/**/*
              ]> ['webpack:build-dev']

# Production build
gulp.task 'build' ['webpack:build']
gulp.task 'webpack:build' (callback) ->
  # modify some webpack config options
  my-config = Object.create webpack-config
  my-config.plugins = my-config.plugins or []
  my-config.plugins =
    # This has effect on the react lib size
    my-config.plugins ++
      new webpack.Define-plugin 'process.env': NODE_ENV: JSON.stringify 'production'
      new webpack.optimize.Dedupe-plugin!
      new webpack.optimize.Uglify-js-plugin!

  # run webpack
  webpack my-config (err, stats) ->
    throw new gutil.Plugin-error('webpack:build', err) if err
    gutil.log '[webpack:build]', stats.to-string colors: true
    callback!

# modify some webpack config options
my-dev-config = Object.create webpack-config
my-dev-config.devtool = 'sourcemap'
my-dev-config.debug = true

# create a single instance of the compiler to allow caching
dev-compiler = webpack my-dev-config

gulp.task 'webpack-build-dev' <[ test webpack:build-dev ]>

gulp.task 'webpack:build-dev' ['test'] (callback) ->
  # run webpack
  dev-compiler.run (err, stats) ->
    throw new gutil.Plugin-error('webpack:build-dev', err) if err
    gutil.log '[webpack:build-dev]' stats.to-string colors: tru
    callback!

gulp.task 'webpack-dev-server' (callback) ->
  # modify some webpack config options
  my-config = Object.create webpack-config
  my-config.devtool = 'eval'
  my-config.debug = true

  # Start a webpack-dev-server
  new Webpack-dev-server(
    webpack my-config
    public-path: '/' + my-config.output.public-path
    stats:
      colors: true
  ).listen 8080, 'localhost', (err) ->
    throw new gutil.Plugin-error('webpack-dev-server', err) if err
    gutil.log '[webpack-dev-server]', 'http://localhost:8080/webpack-dev-server/index.html'
