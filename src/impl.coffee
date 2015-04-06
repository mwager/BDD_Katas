###
* Class implements a "board" of X x X fields
###
window.Board = class
  constructor: () ->
    # fixed for now
    @rows    = 3
    @cols    = 3
    @EMPTY   = "-"
    @_winner = null

    # if(rows.length isnt cols.length)
    #   throw new Error "Row count must match column count but is: rows = #{rows}, cols = #{cols}"

    @_board = [
      [@EMPTY, @EMPTY, @EMPTY],
      [@EMPTY, @EMPTY, @EMPTY],
      [@EMPTY, @EMPTY, @EMPTY]
    ]

    # for i in [0...rows]
    #   rowsArr = []
    #
    #   for j in [0...cols]
    #     rowsArr.push(0)
    #
    #   @_board.push(rowsArr)

  getBoard: ->
    return @_board

  putMark: (x, y, mark = "X") ->
    if(x >= @rows or y >= @cols)
      throw new Error "X or y must be smaller than #{@rows}/#{@cols} but is: #{x}/#{y}"

    if(@_board[x][y] isnt @EMPTY)
      throw new Error "board[x][y] is already occupied with the mark #{@_board[x][y]}"

    @_board[x][y] = mark

  # A game is over when either there are 3 identical marks in a row or all fields are set
  # TODO this could be done so much better ;)
  isOver: ->
    # 1. horizontal
    if(@_board[0][0] isnt @EMPTY and @_board[0][0] is @_board[0][1] and @_board[0][1] is @_board[0][2])
      @_winner = @_board[0][0]
      return true
    if(@_board[1][0] isnt @EMPTY and @_board[1][0] is @_board[1][1] and @_board[1][1] is @_board[1][2])
      @_winner = @_board[1][0]
      return true
    if(@_board[2][0] isnt @EMPTY and @_board[2][0] is @_board[2][1] and @_board[2][1] is @_board[2][2])
      @_winner = @_board[2][0]
      return true

    # 2. vertical
    if(@_board[0][0] isnt @EMPTY and @_board[0][0] is @_board[1][0] and @_board[1][0] is @_board[2][0])
      @_winner = @_board[0][0]
      return true
    if(@_board[0][1] isnt @EMPTY and @_board[0][1] is @_board[1][1] and @_board[1][1] is @_board[2][1])
      @_winner = @_board[0][1]
      return true
    if(@_board[0][2] isnt @EMPTY and @_board[0][2] is @_board[1][2] and @_board[1][2] is @_board[2][2])
      @_winner = @_board[0][2]
      return true

    # 3. diagonal
    if(@_board[0][0] isnt @EMPTY and @_board[0][0] is @_board[1][1] and @_board[1][1] is @_board[2][2])
      @_winner = @_board[0][0]
      return true
    if(@_board[0][2] isnt @EMPTY and @_board[0][2] is @_board[1][1] and @_board[1][1] is @_board[2][0])
      @_winner = @_board[0][2]
      return true

    # 4. all fields are set but no player has won
    if @_board[0][0] isnt @EMPTY and
       @_board[0][1] isnt @EMPTY and
       @_board[0][2] isnt @EMPTY and
       @_board[1][0] isnt @EMPTY and
       @_board[1][1] isnt @EMPTY and
       @_board[1][2] isnt @EMPTY and
       @_board[2][0] isnt @EMPTY and
       @_board[2][1] isnt @EMPTY and
       @_board[2][2] isnt @EMPTY
      return true

    return false

  getWinner: ->
    return @_winner

  # string representation of the board for visual debugging ;)
  toString: ->
    str = ""
    for row in @_board
      for mark in row
        str += mark

      str += "\n"

    return str

###
* Class represents a "player"
###
window.Player = class
  constructor: (name) ->
    @_name   = name
    @_points = 0

  getName: ->
    return @_name

  getPoints: ->
    return @_points


###
* Class represents a "game"
###
window.Game = class
  ###
  * Game constructor
  *
  * Needs a config object like this:
  *   config =
  *     players: [playerInstanceX, playerInstanceO]
  ###
  constructor: (config) ->
    @_config = config
    @_board = {}

  getPlayers: ->
    return @_config.players

  # sense!?
  getBoard: ->
    return @_board
