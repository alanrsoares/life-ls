module.exports =
  class Life
    @isGoingToLive = (isAlive, aliveNeighbours) ->
      | isAlive => aliveNeighbours >= 2 && aliveNeighbours <= 3
      | _       => aliveNeighbours is 3
