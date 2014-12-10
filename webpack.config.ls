module.exports = do
  entry: './entry.js'
  output:
    path: __dirname + '/dist'
    filename: 'bundle.js'
  module:
    loaders:
      * test: /\.css$/
        loader: 'style!css'
      * test: /\.ls$/
        loader: 'livescript'
