#-> helper functions

head = (xs) -> xs.0
tail = (xs) -> xs.slice 1
map = (fn, xs) -->
  | !xs or
    !xs.length => []
  | otherwise  => [fn head xs] .concat map fn, tail xs
fold = (fn, y, xs) -->
  | !xs or
    !xs.length => y
  | otherwise  => fold fn, fn(y, head xs), tail xs

#-> business logic

class Life
  @isGoingToLive = (isAlive, aliveNeighbours) ->
    | isAlive => aliveNeighbours >= 2 && aliveNeighbours <= 3
    | _       => aliveNeighbours is 3

class Cell
  getNeighbours = (grid, coords) ->
    neighbours = []
    y = coords.y
    x = coords.x
    prevRow = grid[y-1] or []
    nextRow = grid[y+1] or []
    [
      prevRow[x-1], prevRow[x], prevRow[x+1],
      nextRow[x-1], nextRow[x], nextRow[x+1],
      grid[y][x-1], grid[y][x+1]
    ]

  @getAliveNeighbours = (grid, coords) ->
    neighbours = getNeighbours(grid, coords)
    reducer = (x, y) -> x += +!!y
    neighbours |> fold reducer, 0

  @nextGen = (grid) ->
    newGrid = []
    len = grid.length-1
    for y from 0 to len by 1
      newGrid[y] = []
      for x from 0 to len by 1
        aliveNeighbors = @getAliveNeighbours grid, {x, y}
        newGrid[y][x] = +(Life.isGoingToLive grid[x][y], aliveNeighbors)
    newGrid
