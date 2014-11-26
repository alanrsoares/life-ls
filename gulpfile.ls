require! <[gulp webpack]>
gutil = require('gulp-util')
mocha = require('gulp-mocha')
WebpackDevServer = require('webpack-dev-server')
webpackConfig = require('./webpack.config.js')

# The development server (the recommended option for development)
gulp.task 'default', ['webpack-dev-server']

gulp.task 'test', (callback) ->
  gulp.src './tests/*.spec.ls'
  .pipe mocha reporter: 'dot'

# Build and watch cycle (another option for development)
# Advantage: No server required, can run app from filesystem
# Disadvantage: Requests are not blocked until bundle is available,
#               can serve an old app on refresh
gulp.task 'build-dev', ['webpack:build-dev'], ->
  gulp.watch ['app/**/*'], ['webpack:build-dev']

# Production build
gulp.task 'build', ['webpack:build']
gulp.task 'webpack:build', (callback) ->
  # modify some webpack config options
  myConfig = Object.create webpackConfig
  myConfig.plugins = myConfig.plugins or []
  myConfig.plugins =
    # This has effect on the react lib size
    myConfig.plugins.concat(
    new webpack.DefinePlugin('process.env': NODE_ENV: JSON.stringify 'production'),
    new webpack.optimize.DedupePlugin!, new webpack.optimize.UglifyJsPlugin!)

  # run webpack
  webpack myConfig, (err, stats) ->
    throw new gutil.PluginError('webpack:build', err) if err
    gutil.log '[webpack:build]', stats.toString(colors: true)
    callback!

# modify some webpack config options
myDevConfig = Object.create webpackConfig
myDevConfig.devtool = 'sourcemap'
myDevConfig.debug = true

# create a single instance of the compiler to allow caching
devCompiler = webpack myDevConfig
gulp.task 'webpack:build-dev', (callback) ->
  # run webpack
  devCompiler.run (err, stats) ->
    throw new gutil.PluginError('webpack:build-dev', err) if err
    gutil.log '[webpack:build-dev]', stats.toString(colors: true)
    callback!

gulp.task 'webpack-dev-server', (callback) ->
  # modify some webpack config options
  myConfig = Object.create webpackConfig
  myConfig.devtool = 'eval'
  myConfig.debug = true

  # Start a webpack-dev-server
  new WebpackDevServer(webpack(myConfig),
    public-path: '/' + myConfig.output.public-path
    stats:
      colors: true
  ).listen 8080, 'localhost', (err) ->
    throw new gutil.PluginError('webpack-dev-server', err) if err
    gutil.log '[webpack-dev-server]', 'http://localhost:8080/webpack-dev-server/index.html'
