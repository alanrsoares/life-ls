module.exports =
  class Life
    @is-going-to-live = (is-alive, alive-neighbours) ->
      | is-alive => aliveNeighbours >= 2 && alive-neighbours <= 3
      | _        => alive-neighbours is 3
