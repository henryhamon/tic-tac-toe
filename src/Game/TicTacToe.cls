/// TicTacToe Game Class
Class Game.TicTacToe
{

/// Start a new Game match
ClassMethod Start()
{
  Do ##class(TicTacToe.Engine).NewGame()
  Write #
  Write !,"Let's play Tic Tac Toe"
  Set gameStatus = "Not Done"
  Set currentPlayer = $Select($Random(2)=0:"human",1:"computer")
  Set turn = 0
  While (gameStatus = "Not Done") {
    Set turn = $Increment(turn)
    Do ..DrawBoard(turn)
    If (currentPlayer = "human") {
        Write !,?20, "Ok Human, it's your turn",!
        Read ?20,"Your move coordinates: ",move
    } Else {
        Set move = ..ComputerMove()
        Write !,?20, "Computer move: ", move
        Hang 0.5
    }

    If ('..CheckMoveIsValid(move)||('..IsSpaceFree(move))) {
      Write !,?20, "Invalid moviment, do it again"
      Continue
    }

    Do ..MakeMove(move, $Select(currentPlayer="human":"X", 1:"O"))
    Set gameStatus = ..CheckGameResult()
    Set currentPlayer = $Select(currentPlayer="human":"computer", 1:"human")
  }
  Do ..DrawBoard(turn)
  Write !, ?20, gameStatus
}

/// Draw board with current state
ClassMethod DrawBoard(currentTurn As %Integer)
{
  Set lines = $ListBuild("A","B","C")
  Write !, "Turn: ", currentTurn
  For i = 1:1:3 {
    Write:(i = 1) !,?5,1,?9,2,?13,3,!
    Write:(i > 1) !,?5,"-----------"
    Write !,?1,$List(lines, i),?6, $Piece(^TicTacToe($List(lines, i)),"^",1),?7, " | ",
          ?10, $Piece(^TicTacToe($List(lines, i)),"^",2)," | ",
          ?14, $Piece(^TicTacToe($List(lines, i)),"^",3)
  }
  Write !!
}

/// Iniciate a New Game
ClassMethod NewGame() As %Status
{
  Set sc = $$$OK
  Kill ^TicTacToe
  Set ^TicTacToe("A") = "^^"
  Set ^TicTacToe("B") = "^^"
  Set ^TicTacToe("C") = "^^"
  Return sc
}

/// Is Space Empty?
ClassMethod IsSpaceFree(move As %String) As %Boolean
{
  Quit ($Piece(^TicTacToe($Extract(move,1,1)),"^",$Extract(move,2,2)) = "")
}

/// Check if it is a valid move
ClassMethod CheckMoveIsValid(move As %String) As %Boolean
{
  Set regex = ##class(%Regex.Matcher).%New("(A|B|C){1}[0-9]{1}")
  Set regex.Text = $ZCONVERT(move,"U")
  Return regex.Locate()
}

/// Check if Game is Over
ClassMethod CheckGameResult() As %String
{
    Set lines = $ListBuild("A","B","C")
    // Check Horizontal
    For i = 1:1:3 {
      Set line = $Replace(^TicTacToe($List(lines, i)),"^","")
      If (($Find(line,"XXX")>0)||($Find(line,"OOO")>0)) {
        Return ..WhoWon($Piece(^TicTacToe($List(lines, i)),"^", 1))
      }
    }

    // Check Vertical
    For j = 1:1:3 {
      If (($Piece(^TicTacToe($List(lines, 1)),"^",j)'="") &&
        ($Piece(^TicTacToe($List(lines, 1)),"^",j)=$Piece(^TicTacToe($List(lines, 2)),"^",j)) &&
        ($Piece(^TicTacToe($List(lines, 2)),"^",j)=$Piece(^TicTacToe($List(lines, 3)),"^",j))) {
        Return ..WhoWon($Piece(^TicTacToe($List(lines, 1)),"^",j))
      }
    }

    // Check Diagonal
    If (($Piece(^TicTacToe($List(lines, 2)),"^",2)'="") &&
      (
        (($Piece(^TicTacToe($List(lines, 1)),"^",1)=$Piece(^TicTacToe($List(lines, 2)),"^",2)) &&
          ($Piece(^TicTacToe($List(lines, 2)),"^",2)=$Piece(^TicTacToe($List(lines, 3)),"^",3)))||
        (($Piece(^TicTacToe($List(lines, 1)),"^",3)=$Piece(^TicTacToe($List(lines, 2)),"^",2)) &&
        ($Piece(^TicTacToe($List(lines, 2)),"^",2)=$Piece(^TicTacToe($List(lines, 3)),"^",1)))
      )) {
      Return ..WhoWon($Piece(^TicTacToe($List(lines, 2)),"^",2))
    }

    Set gameStatus = ""
    For i = 1:1:3 {
      For j = 1:1:3 {
        Set:($Piece(^TicTacToe($List(lines, i)),"^",j)="") gameStatus = "Not Done"
      }
    }
    Set:(gameStatus = "") gameStatus = "Draw"
    Quit gameStatus
}

/// Return the winner
ClassMethod WhoWon(letter As %String) As %String
{
  Return "The "_$Select(letter="O":"Computer", 1:"Human")_" Won!"
}

/// Make a move
ClassMethod MakeMove(move As %String, player As %String) As %Boolean
{
  Set $Piece(^TicTacToe($Extract(move,1,1)),"^",$Extract(move,2,2)) = player
}

/// Get Computer Move with MiniMax Algorithm
ClassMethod ComputerMove() As %String [ Language = python ]
{
  import iris
  from math import inf as infinity
  computerLetter = "O"
  playerLetter = "X"

  def isBoardFull(board):
    for i in range(0, 8):
      if isSpaceFree(board, i):
        return False
    return True

  def makeMove(board, letter, move):
    board[move] = letter

  def isWinner(brd, let):
    # check horizontals
    if ((brd[0] == brd[1] == brd[2] == let) or \
      (brd[3] == brd[4] == brd[5] == let) or \
      (brd[6] == brd[7] == brd[8] == let)):
        return True
    # check verticals
    if ((brd[0] == brd[3] == brd[6] == let) or \
        (brd[1] == brd[4] == brd[7] == let) or \
        (brd[2] == brd[5] == brd[8] == let)):
        return True
    # check diagonals
    if ((brd[0] == brd[4] == brd[8] == let) or \
        (brd[2] == brd[4] == brd[6] == let)):
        return True
    return False

  def isSpaceFree(board, move):
    #Retorna true se o espaco solicitado esta livre no quadro
    if(board[move] == ''):
      return True
    else:
      return False

  def copyGameState(board):
    dupeBoard = []
    for i in board:
      dupeBoard.append(i)
    return dupeBoard

  def getBestMove(state, player):
    done = "Done" if isBoardFull(state) else ""
    if done == "Done" and isWinner(state, computerLetter): # If Computer won
      return 1
    elif done == "Done" and isWinner(state, playerLetter): # If Human won
      return -1
    elif done == "Done":    # Draw condition
      return 0

    # Minimax Algorithm
    moves = []
    empty_cells = []
    for i in range(0,9):
      if state[i] == '':
        empty_cells.append(i)

    for empty_cell in empty_cells:
      move = {}
      move['index'] = empty_cell
      new_state = copyGameState(state)
      makeMove(new_state, player, empty_cell)

      if player == computerLetter:
          result = getBestMove(new_state, playerLetter)
          move['score'] = result
      else:
          result = getBestMove(new_state, computerLetter)
          move['score'] = result

      moves.append(move)

    # Find best move
    best_move = None
    if player == computerLetter:
        best = -infinity
        for move in moves:
            if move['score'] > best:
                best = move['score']
                best_move = move['index']
    else:
        best = infinity
        for move in moves:
            if move['score'] < best:
                best = move['score']
                best_move = move['index']

    return best_move

  lines = ['A', 'B', 'C']
  game = []
  current_game_state = iris.gref("^TicTacToe")

  for line in lines:
    for cell in current_game_state[line].split("^"):
      game.append(cell)

  cellNumber = getBestMove(game, computerLetter)
  next_move = lines[int(cellNumber/3)]+ str(int(cellNumber%3)+1)
  return next_move
}

}
