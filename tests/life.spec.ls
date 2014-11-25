mocha.setup 'bdd'
expect = chai.expect

describe "Conway's Game of Life" !->
  specify 'Should tell wether a cell dies or lives through the next generation #1' !->
    expect Life.isGoingToLive true, 2 .to .equal true

  specify 'Should tell wether a cell dies or lives through the next generation #2' !->
    expect Life.isGoingToLive true, 3 .to .equal true

  specify 'Should tell wether a cell dies or lives through the next generation #3' !->
    expect Life.isGoingToLive false, 3 .to .equal true

  specify 'Should tell wether a cell dies or lives through the next generation #4' !->
    expect Life.isGoingToLive false, 2 .to .equal false

  specify 'Should get the number of alive neighbours #1' !->
    seed =
      * 0 0 0
      * 1 1 1
      * 0 0 0
    expect Cell.getAliveNeighbours seed, {x:1, y:1} .to .equal 2

  specify 'Should get the number of alive neighbours #2' !->
    seed =
      * 1 0 0
      * 1 1 1
      * 0 0 1
    expect Cell.getAliveNeighbours seed, {x:1, y:1} .to .equal 4

  specify 'Should get the number of alive neighbours #3' !->
    seed =
      * 1 0 0
      * 1 1 1
      * 0 0 1
    expect Cell.getAliveNeighbours seed, {x:0, y:0} .to .equal 2

  specify 'Should get the number of alive neighbours #4' !->
    seed =
      * 1 0 0
      * 1 1 1
      * 0 1 1
    expect Cell.getAliveNeighbours seed, {x:2, y:2} .to .equal 3

  specify 'Should calculate the next generation for a given board #1' !->
    seed =
      * 0 0 0
      * 1 1 1
      * 0 0 0
    expected =
      * 0 1 0
      * 0 1 0
      * 0 1 0
    subject = Cell.nextGen seed
    expect subject.toString() .to .equal expected.toString()

  specify 'Should calculate the next generation for a given board #2' !->
    seed =
      * 0 1 0
      * 0 1 0
      * 0 1 0
    subject = Cell.nextGen seed |> Cell.nextGen
    expect subject.toString() .to .equal seed.toString()

  specify 'Should calculate the next generation for a given board #3' !->
    seed =
      * 1 1 0
      * 1 0 1
      * 0 1 0
    expected =
      * 1 1 0
      * 1 0 1
      * 0 1 0
    subject = Cell.nextGen seed
    expect subject.toString() .to .equal expected.toString()

mocha.run!
