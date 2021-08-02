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

def computerMove():
  lines = ['A', 'B', 'C']
  game = []
  current_game_state = iris.gref("^TicTacToe")

  for line in lines:
    for cell in current_game_state[line].split("^"):
      game.append(cell)

  cellNumber = getBestMove(game, computerLetter)
  next_move = lines[int(cellNumber/3)]+ str(int(cellNumber%3)+1)
  return next_move
