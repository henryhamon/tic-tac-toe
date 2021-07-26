/// Description
Class TicTacToe.Engine
{

/// New Game
ClassMethod NewGame() As %Status
{
  Set sc = $$$OK
  Kill ^TicTacToe
  Set ^TicTacToe("A") = ""
  Set ^TicTacToe("B") = ""
  Set ^TicTacToe("C") = ""
  Return sc
}

/// Check if it is a valid move
ClassMethod CheckMoveIsValid(move As %String) As %Status
{
  Set sc = $$$OK
  Set regex = ##class(%Regex.Matcher).%New("(A|B|C){1}[0-9]{1}")
  Set regex.Text = $ZCONVERT(move,"U")
  If ('regex.Locate()) {
    Return $$$ERROR(5002,"Invalid move")
  }
  Return sc
}

ClassMethod MakeMove(line as %String, column As %Integer, player As %String) [ Language = python ]
{
  return True
}

}
