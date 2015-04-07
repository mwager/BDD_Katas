###
* Implementation of the game. All classes in one file for now ;)
###


###
* Class represents a mark on a board
*
* It has a count value (1 or -1) for winner detection,
* a player reference and knows its position (x,y)
###
window.Mark = class
  constructor: (count, player, position)->
    @count    = count
    @player   = player
    @position = position


###
* Class implements a "board" of 3x3 fields
###
window.Board = class
  constructor: (players) ->
    # fixed for now
    @rows       = 3
    @cols       = 3
    @EMPTY      = "-"
    @_winner    = null
    @_markCount = 0

    # hash map to get a player by mark
    @_players = {}
    @_players[players[0].getMark()] = players[0]
    @_players[players[1].getMark()] = players[1]

    @_board = [
      [@EMPTY, @EMPTY, @EMPTY],
      [@EMPTY, @EMPTY, @EMPTY],
      [@EMPTY, @EMPTY, @EMPTY]
    ]

  getBoard: ->
    return @_board

  putMark: (x, y, mark) ->
    if(x >= @rows or y >= @cols)
      throw new Error "X or y must be smaller than #{@rows}/#{@cols} but is: #{x}/#{y}"

    if(@_board[x][y] isnt @EMPTY)
      throw new Error "board[x][y] is already occupied with the mark #{@_board[x][y]}"

    @_markCount++

    countValue = if mark is "X" then 1 else -1

    @_board[x][y] = new Mark(countValue, @_players[mark], [x, y])

  # A game is over when either there are 3 identical marks in a row or all fields are set
  isOver: ->
    # log @toString()

    # 1. rows
    for i in [0...@rows]
      total = 0
      for j in [0...@cols]
        total += @_board[i][j].count

      if @_isOverBecausePlayerWon(total)
        return true

    # 2. cols
    for i in [0...@rows]
      total = 0
      for j in [0...@cols]
        total += @_board[j][i].count

      if @_isOverBecausePlayerWon(total)
        return true

    # 3. diagonals
    i     = 0
    j     = 0
    total = 0
    while i < @rows
      total += @_board[i++][j++].count

    if @_isOverBecausePlayerWon(total)
      return true

    i     = 0
    j     = @cols - 1
    total = 0
    while i < @rows
      total += @_board[i++][j--].count

    if @_isOverBecausePlayerWon(total)
      return true

    # 4. all fields are set but no player has won
    if (@_markCount is (@rows * @cols))
      return true

    return false

  _isOverBecausePlayerWon: (total) ->
    if(total is 3) #...X won on a row
      @_winner = @_players["X"]
      return true

    if(total is -3) #... O won on a row
      @_winner = @_players["O"]
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
  constructor: (name, mark) ->
    @_name   = name
    @_points = 0
    @_mark   = mark

  getName: ->
    @_name

  getPoints: ->
    @_points

  getMark: ->
    @_mark
