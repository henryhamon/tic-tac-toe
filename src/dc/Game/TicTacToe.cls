/// TicTacToe Game Class
Class dc.Game.TicTacToe
{

/// Start a new Game match
ClassMethod Start()
{
  Do ..NewGame()
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
ClassMethod ComputerMove() As %String
{
  Set minimax=##class(%SYS.Python).Import("minimax")
  Quit minimax.computerMove()
}

}
