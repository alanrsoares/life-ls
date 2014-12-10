module.exports = do
  entry: './entry.ls'
  output:
    path: __dirname + '/dist'
    filename: 'bundle.js'
  module:
    loaders:
      * test: /\.css$/
        loader: 'style!css'
      * test: /\.ls$/
        loader: 'livescript'
