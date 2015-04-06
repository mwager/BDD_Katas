# Specs for the tic tac toe game
# Rules: http://en.wikipedia.org/wiki/Tic-tac-toe
#
# I try to use the "outside in" strategy, so first I code some high level specs
# from which I extend my low level ones. This means I am coding my way in
# based straight on the specification.
# Every line of code should be there for a reason!


###
* ------------------------- Factory-Helpers -------------------------
###
window.PlayerFactory =
  create: (name = "Michael") ->
    return new Player name

window.GameFactory =
  create: (config = {}) ->
    config.players ?= [
      PlayerFactory.create("Michael"),
      PlayerFactory.create("Uncle Bob")
    ]

    return new Game config

window.BoardFactory  =
  create: () ->
    return new Board


###
* -------------------- LOW LEVEL SPECS -------------------------
###
describe "A Board", ->
  beforeEach ->
    @board = BoardFactory.create()

  it "should have 3 rows with each 3 columns", ->
    boardArr = @board.getBoard()
    expect(boardArr.length).to.equal 3
    expect(boardArr[0].length).to.equal 3
    expect(boardArr[1].length).to.equal 3
    expect(boardArr[2].length).to.equal 3

  it "should not be 'over' if no marks are set", ->
    expect(@board.isOver()).to.equal false


  describe "A user can put a mark on the board", ->
    before ->
      @board = BoardFactory.create()

    it "should provide a method to put a mark on it", ->
      @board.putMark(0, 0, "X")
      boardArr = @board.getBoard()
      expect(boardArr[0][0]).to.equal "X"

    it "should not allow to put the same mark again", ->
      # NOTE: we must pass a fn here which mocha itself may call
      # expect(@board.putMark.bind(0, 0, "X")).to.throw(Error);
      # WTF!?!?!?
      # TypeError: 'undefined' is not a function (evaluating 'this.board.putMark.bind(0, 0, "X")')
      # so:
      try
        @board.putMark(0, 0, "X")
        expect("Error thrown").to.equal "false"
      catch err
        expect(true).to.equal true

    it "should throw an error if the boundaries are exceeded", ->
      #   expect(@board.putMark.bind(3, 0, "X")).to.throw(Error);
      try
        @board.putMark(3, 0, "X")
        expect("Error thrown").to.equal "false"
      catch err
        expect(true).to.equal true


  describe "Is over when", ->
    beforeEach ->
      @board = BoardFactory.create()

    describe "three respective marks in a horizontal row are set", ->
      it "first row - and should know the winner", ->
        @board.putMark(0, 0, "X")
        @board.putMark(0, 1, "X")
        @board.putMark(0, 2, "X")
        expect(@board.isOver()).to.equal true
        expect(@board.getWinner()).to.equal "X"

      it "second row - and should know the winner", ->
        @board.putMark(1, 0, "X")
        @board.putMark(1, 1, "X")
        @board.putMark(1, 2, "X")
        expect(@board.isOver()).to.equal true
        expect(@board.getWinner()).to.equal "X"

      it "third row - and should know the winner", ->
        @board.putMark(2, 0, "O")
        @board.putMark(2, 1, "O")
        @board.putMark(2, 2, "O")
        expect(@board.isOver()).to.equal true
        expect(@board.getWinner()).to.equal "O"

    describe "three respective marks in a vertical row are set", ->
      it "first col - and should know the winner", ->
        @board.putMark(0, 0, "X")
        @board.putMark(1, 0, "X")
        @board.putMark(2, 0, "X")
        expect(@board.isOver()).to.equal true
        expect(@board.getWinner()).to.equal "X"

      it "second col - and should know the winner", ->
        @board.putMark(0, 1, "X")
        @board.putMark(1, 1, "X")
        @board.putMark(2, 1, "X")
        expect(@board.isOver()).to.equal true
        expect(@board.getWinner()).to.equal "X"

      it "third col - and should know the winner", ->
        @board.putMark(0, 2, "X")
        @board.putMark(1, 2, "X")
        @board.putMark(2, 2, "X")
        expect(@board.isOver()).to.equal true
        expect(@board.getWinner()).to.equal "X"

    describe "three respective marks in a diagonal row are set", ->
      it "left to right - and should know the winner", ->
        @board.putMark(0, 0, "X")
        @board.putMark(1, 1, "X")
        @board.putMark(2, 2, "X")
        expect(@board.isOver()).to.equal true
        expect(@board.getWinner()).to.equal "X"

      it "right to left - and should know the winner", ->
        @board.putMark(0, 2, "X")
        @board.putMark(1, 1, "X")
        @board.putMark(2, 0, "X")
        expect(@board.isOver()).to.equal true
        expect(@board.getWinner()).to.equal "X"

    describe "all fields are just set", ->
      it "but no one wins", ->
        @board._board = [
          ["X", "O", "X"],
          ["O", "X", "X"],
          ["O", "X", "O"]
        ]

        log @board.toString()
        expect(@board.isOver()).to.equal true
        expect(@board.getWinner()).to.equal null


describe "A Player", ->
  beforeEach ->
    @player = PlayerFactory.create()

  it "should have a name", ->
    expect(@player.getName()).to.equal "Michael"

  it "should have no points at start", ->
    expect(@player.getPoints()).to.equal 0



###
* ------------------------- HIGH LEVEL SPECS -------------------------
###
describe "Game", ->
  describe "A fresh Game", ->
    beforeEach ->
      @game = GameFactory.create()

    it "should not have more than 2 players", ->
      expect(@game.getPlayers().length).to.equal 2

    it "should have a board", ->
      expect(@game.getBoard()).to.not.equal undefined

    describe "Concrete scenario", ->
      it "Player X wins after 3 draws", ->
        board = BoardFactory.create()
        board.putMark(0, 0, "X")
        board.putMark(1, 0, "O")
        board.putMark(0, 1, "X")
        board.putMark(1, 1, "O")
        board.putMark(0, 2, "X")

        expect(board.isOver()).to.equal true
        expect(board.getWinner()).to.equal "X"
