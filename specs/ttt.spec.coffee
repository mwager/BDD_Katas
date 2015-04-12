# Specs for the tic tac toe game
# Rules: http://en.wikipedia.org/wiki/Tic-tac-toe
#
# I try to use the "outside in" strategy, so first I code some high level specs
# from which I extend my low level ones. This means I am coding my way in
# based straight on the specification.
# Every line of code should be there for a reason!
#
# "Good architecture allows major decisions to be deferred" (Uncle Bob)
# --> means here: UI comes later. Business logic should not depend on the UI.


###
* ------------------------- Factory-Helpers -------------------------
###
window.PlayerFactory =
  create: (name = "Michael", countValue = 1, isComputer = false) ->
    return new Player name, countValue, isComputer

__players = []

initPlayers = ->
  __players = [
    PlayerFactory.create("Michael", 1), # first player has 1 and the second has -1 => "by convention" ;)
    PlayerFactory.create("Uncle Bob", -1) # -> this is used to detect the winner, see board.isOver()
  ]

initPlayers()

# TODO!?
window.GameFactory =
  create: (config = {}) ->
    config.players ?= __players

    return new Game config

window.BoardFactory  =
  create: (N = 3) ->
    return new Board N


describe "TicTacToe Specs", ->
  describe "A Mark", ->
    beforeEach ->
      @mark = new Mark([0, 0], __players[0])

    it "should know its position on the board", ->
      expect(@mark.position[0]).to.equal 0
      expect(@mark.position[1]).to.equal 0

    it "should have a player ref", ->
      expect(@mark.player.getName()).to.equal "Michael"

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


    describe "A player can put a mark on the board", ->
      before ->
        @board = BoardFactory.create()

      it "should provide a method to put a mark on it", ->
        @board.putMark(0, 0, __players[0])
        boardArr = @board.getBoard()
        expect(boardArr[0][0].player.getMark()).to.equal "X"

      it "should not allow to put the same mark again", ->
        # NOTE: we must pass a fn here which mocha itself may call
        # expect(@board.putMark.bind(0, 0, __players[0])).to.throw(Error);
        # WTF!?!?!?
        # TypeError: 'undefined' is not a function (evaluating 'this.board.putMark.bind(0, 0, __players[0])')
        # so:
        try
          @board.putMark(0, 0, __players[0])
          expect("Error thrown").to.equal "false"
        catch err
          expect(true).to.equal true

      it "should throw an error if the boundaries are exceeded", ->
        try
          @board.putMark(3, 0, __players[0])
          expect("Error thrown").to.equal "false"
        catch err
          expect(true).to.equal true


    describe "Is over when", ->
      beforeEach ->
        initPlayers()
        @board = BoardFactory.create()

      describe "three respective marks in a horizontal row are set", ->
        it "first row - and should know the winner - and the player should get one point if he wins", ->
          @board.putMark(0, 0, __players[0])
          @board.putMark(0, 1, __players[0])
          @board.putMark(0, 2, __players[0])
          expect(@board.isOver()).to.equal true
          expect(@board.getWinner().getName()).to.equal "Michael"
          expect(@board.getWinner().getPoints()).to.equal 1

        it "second row - and should know the winner", ->
          @board.putMark(1, 0, __players[0])
          @board.putMark(1, 1, __players[0])
          @board.putMark(1, 2, __players[0])
          expect(@board.isOver()).to.equal true
          expect(@board.getWinner().getName()).to.equal "Michael"

        it "third row - and should know the winner", ->
          @board.putMark(2, 0, __players[1])
          @board.putMark(2, 1, __players[1])
          @board.putMark(2, 2, __players[1])
          expect(@board.isOver()).to.equal true
          expect(@board.getWinner().getName()).to.equal "Uncle Bob"

      describe "three respective marks in a vertical row are set", ->
        it "first col - and should know the winner", ->
          @board.putMark(0, 0, __players[0])
          @board.putMark(1, 0, __players[0])
          @board.putMark(2, 0, __players[0])
          expect(@board.isOver()).to.equal true
          expect(@board.getWinner().getName()).to.equal "Michael"

        it "second col - and should know the winner", ->
          @board.putMark(0, 1, __players[0])
          @board.putMark(1, 1, __players[0])
          @board.putMark(2, 1, __players[0])
          expect(@board.isOver()).to.equal true
          expect(@board.getWinner().getName()).to.equal "Michael"

        it "third col - and should know the winner", ->
          @board.putMark(0, 2, __players[0])
          @board.putMark(1, 2, __players[0])
          @board.putMark(2, 2, __players[0])
          expect(@board.isOver()).to.equal true
          expect(@board.getWinner().getName()).to.equal "Michael"

      describe "three respective marks in a diagonal row are set", ->
        it "left to right - and should know the winner", ->
          @board.putMark(0, 0, __players[0])
          @board.putMark(1, 1, __players[0])
          @board.putMark(2, 2, __players[0])
          expect(@board.isOver()).to.equal true
          expect(@board.getWinner().getName()).to.equal "Michael"

        it "right to left - and should know the winner", ->
          @board.putMark(0, 2, __players[0])
          @board.putMark(1, 1, __players[0])
          @board.putMark(2, 0, __players[0])
          expect(@board.isOver()).to.equal true
          expect(@board.getWinner().getName()).to.equal "Michael"

      describe "all fields are just set", ->
        it "but no one wins", ->
          @board.putMark(0, 0, __players[0])
          @board.putMark(0, 1, __players[1])
          @board.putMark(0, 2, __players[0])
          @board.putMark(1, 0, __players[1])
          @board.putMark(1, 1, __players[0])
          @board.putMark(1, 2, __players[0])
          @board.putMark(2, 0, __players[1])
          @board.putMark(2, 1, __players[0])
          @board.putMark(2, 2, __players[1])
          # @board._board = [
          #   ["X", "O", "X"],
          #   ["O", "X", "X"],
          #   ["O", "X", "O"]
          # ]

          # log @board.toString()
          expect(@board.isOver()).to.equal true
          expect(@board.getWinner()).to.equal null


  describe "A Player", ->
    beforeEach ->
      @player = PlayerFactory.create()

    it "should have a name", ->
      expect(@player.getName()).to.equal "Michael"

    it "should have no points at start", ->
      expect(@player.getPoints()).to.equal 0

    xdescribe "can be a computer player", ->
      beforeEach ->
        @computerPlayer = PlayerFactory.create(null, -1, true)

      it "should be a computer player", ->
        expect(@computerPlayer._isComputer).to.equal true
        expect(@computerPlayer._name).to.equal "Uncle Bob"

      describe "and should make the best possible move", ->
        beforeEach ->
          @board = BoardFactory.create()

        it "horizontal", ->
          @board.putMark(0, 0, __players[0])
          @board.putMark(0, 1, __players[0])
          position = @computerPlayer.getPosition(@board)
          expect(position.x).to.equal 0
          expect(position.y).to.equal 2

        it "vertical", ->
          @board.putMark(0, 0, __players[0])
          @board.putMark(1, 0, __players[0])
          position = @computerPlayer.getPosition(@board)
          expect(position.x).to.equal 2
          expect(position.y).to.equal 0

  ###
  * ------------------------- HIGH LEVEL SPECS -------------------------
  ###
  describe "High Level Specs", ->
    describe "Concrete scenario", ->
      it "Player X wins after 3 draws", ->
        board = BoardFactory.create()
        board.putMark(0, 0, __players[0])
        board.putMark(1, 0, __players[1])
        board.putMark(0, 1, __players[0])
        board.putMark(1, 1, __players[1])
        board.putMark(0, 2, __players[0])

        expect(board.isOver()).to.equal true
        expect(board.getWinner().getName()).to.equal "Michael"
