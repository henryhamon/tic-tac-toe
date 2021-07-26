/// Description
Class TicTacToe.Game
{

/// New Game match
ClassMethod Play()
{
  Do ##class(TicTacToe.Engine).NewGame()
  Write #
  Do ..DrawBoard()
  Read ?30,"Your move coordinates: ",move
}

/// Draw board with current state
ClassMethod DrawBoard()
{
  Write !,?5,1,?9,2,?13,3,!
  Write !,?1,"A",?6, $Piece(^TicTacToe("A"),"^",1),?7, " | ",
                ?10, $Piece(^TicTacToe("A"),"^",2)," | ",
                ?14, $Piece(^TicTacToe("A"),"^",3)
  Write !,?5,"-----------"
  Write !,?1,"B",?6, $Piece(^TicTacToe("B"),"^",1),?7, " | ",
                ?10, $Piece(^TicTacToe("B"),"^",2), " | ",
                ?14, $Piece(^TicTacToe("B"),"^",3)
  Write !,?5,"-----------"
  Write !,?1,"C",?6, $Piece(^TicTacToe("C"),"^",1),?7, " | ",
                ?10, $Piece(^TicTacToe("C"),"^",2), " | ",
                ?14, $Piece(^TicTacToe("C"),"^",3)
  Write !!
}

/// Player Move
ClassMethod PlayerMove(move As %String) As %Status
{
  Set sc = $$$OK
  // do something
  Return sc
}

ClassMethod ComputerMove() [ Language = python ]
{
  return True
}

}
