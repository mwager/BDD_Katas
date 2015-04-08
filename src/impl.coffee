###
* Implementation of the game. All classes in one file for now ;)
###

__EMPTY = "-"

###
* Class represents a mark on a board
*
* It has a count value (1 or -1) for winner detection,
* a player reference and knows its position (x,y)
###
window.Mark = class
  constructor: (position, player)->
    @position = position
    @player   = player
    @count    = player.getCount()


###
* Class implements a "board" of 3x3 fields
###
window.Board = class
  constructor: (rows, cols) ->
    if rows isnt cols
      throw new Error "Board Error: Rows !== cols: #{rows}/#{cols}"

    if rows < cols or rows > cols
      throw new Error "Board Error: Rows must equal cols: #{rows}/#{cols}"

    @rows       = rows
    @cols       = cols
    @EMPTY      = __EMPTY
    @_winner    = null
    @_markCount = 0

    @_board = []

    for x in [0...@rows]
      @_board.push []
      for y in [0...@rows]
        @_board[x].push @EMPTY

  getBoard: ->
    return @_board

  putMark: (x, y, player) ->
    if(x >= @rows or y >= @cols)
      throw new Error "X or y must be smaller than #{@rows}/#{@cols} but is: #{x}/#{y}"

    if(@_board[x][y] isnt @EMPTY)
      throw new Error "board[x][y] is already occupied with the mark #{@_board[x][y].getPlayer().getMark()}"

    @_markCount++

    @_board[x][y] = new Mark([x, y], player)

  # A game is over when either there are 3 identical marks in a row or all fields are set
  isOver: ->
    # log @toString()

    # 1. rows
    for i in [0...@rows]
      total = 0
      for j in [0...@cols]
        mark  = @_board[i][j] # remember the field
        total += @_board[i][j].count

      if @_isOverBecausePlayerWon(total, mark)
        return true

    # 2. cols
    for i in [0...@rows]
      total = 0
      for j in [0...@cols]
        mark  = @_board[j][i] # remember the field
        total += @_board[j][i].count

      if @_isOverBecausePlayerWon(total, mark)
        return true

    # 3. diagonals
    i     = 0
    j     = 0
    total = 0
    while i < @rows
      mark  = @_board[i][j] # remember the field
      total += @_board[i++][j++].count

    if @_isOverBecausePlayerWon(total, mark)
      return true

    i     = 0
    j     = @cols - 1
    total = 0
    while i < @rows
      mark  = @_board[i][j] # remember the field
      total += @_board[i++][j--].count

    if @_isOverBecausePlayerWon(total, mark)
      return true

    # 4. all fields are set but no player has won
    if (@_markCount is (@rows * @cols))
      return true

    return false

  _isOverBecausePlayerWon: (total, mark) ->
    if(total is 3) #...X won on a row
      @_winner = mark.player
      @_winner.addPoints 1
      return true

    if(total is -3) #... O won on a row
      @_winner = mark.player
      @_winner.addPoints 1
      return true

  getWinner: ->
    return @_winner

  # string representation of the board for visual debugging ;)
  toString: ->
    str = ""
    for row in @_board
      for mark in row
        str += if mark.player then mark.player.getMark() else @EMPTY

      str += "\n"

    return str


###
* Class represents a "player"
###
window.Player = class
  constructor: (name, countValue, isComputer) ->
    @_name       = name
    @_points     = 0
    @_countValue = countValue
    @_mark       = if countValue is 1 then "X" else "O"
    @_isComputer = isComputer

    # default name ;-)
    if isComputer and !name
      @_name = "Uncle Bob"

  getName: ->
    @_name

  addPoints: (points) ->
    @_points += points

  getPoints: ->
    @_points

  getMark: ->
    @_mark

  getCount: ->
    return @_countValue

  # get the best position if we are a computer player
  getPosition: (board) ->
    position   = {}
    boardArray = board.getBoard()

    for x in [0...boardArray.length]
      for y in [0...boardArray.length]
        if boardArray[x][y] is __EMPTY
          return {x: x, y: y}

    # TODO
    # # 1. horizontal win
    # if boardArray[0][0] isnt __EMPTY
    #   boardArray[0][0].player.getMark() is @_mark and
    #   boardArray[0][1].player.getMark() is @_mark and
    #   boardArray[0][2] is __EMPTY
    #   position = {x: 0, y: 2}

    return position


###
* Class represents a "game"
* A game has players and "knows" the board
###
window.Game = class
  initBoard: (players) ->
    @_players = players
    @_board   = new Board(players)

  getPlayers: ->
    return @_players
