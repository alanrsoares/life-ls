head = (xs) -> xs.0
tail = (xs) -> xs.slice 1
map = (fn, xs) -->
  | !xs or
    !xs.length => []
  | otherwise  => [fn head xs] ++ map fn, tail xs
fold = (fn, y, xs) -->
  | !xs or
    !xs.length => y
  | otherwise  => fold fn, fn(y, head xs), tail xs

Life = require './life.ls'

module.exports =
  class Cell
    get-neighbours = (grid, coords) ->
      neighbours = []
      y = coords.y
      x = coords.x
      prev = grid[y-1] or []
      next = grid[y+1] or []
      [
        prev[x-1]     prev[x]       prev[x+1]
        grid[y][x-1]  grid[y][x+1]
        next[x-1]     next[x]       next[x+1]
      ]

    @get-alive-neighbours = (grid, coords) ->
      neighbours = get-neighbours(grid, coords)
      reducer = (x, y) -> x += +!!y
      neighbours |> fold(reducer, 0)

    @next-gen = (grid) ->
      new-grid = []
      length = grid.length - 1
      for y from 0 to length by 1
        new-grid[y] = []
        for x from 0 to length by 1
          alive-neighbours = @get-alive-neighbours(grid, {x, y})
          new-grid[y][x] = +Life.is-going-to-live(grid[x][y], alive-neighbours)
      new-grid
