import numpy as np

ROW_COUNT = 6
COLUMN_COUNT = 7

def create_board():
    board = np.zeros((6,7))
    return board

def drop_piece(board,row,col,piece):
    board[row][col] = piece

def winning_move(board, piece):
	# Check horizontal locations for win
	for c in range(COLUMN_COUNT-3):
		for r in range(ROW_COUNT):
			if board[r][c] == piece and board[r][c+1] == piece and board[r][c+2] == piece and board[r][c+3] == piece:
				return True

	# Check vertical locations for win
	for c in range(COLUMN_COUNT):
		for r in range(ROW_COUNT-3):
			if board[r][c] == piece and board[r+1][c] == piece and board[r+2][c] == piece and board[r+3][c] == piece:
				return True

	# Check positively sloped diaganols
	for c in range(COLUMN_COUNT-3):
		for r in range(ROW_COUNT-3):
			if board[r][c] == piece and board[r+1][c+1] == piece and board[r+2][c+2] == piece and board[r+3][c+3] == piece:
				return True

	# Check negatively sloped diaganols
	for c in range(COLUMN_COUNT-3):
		for r in range(3, ROW_COUNT):
			if board[r][c] == piece and board[r-1][c+1] == piece and board[r-2][c+2] == piece and board[r-3][c+3] == piece:
				return True

def is_valid_location(board,col):
    return board[5][col] == 0


def get_next_open_row(board,col):
    for r in range (ROW_COUNT):
        if board[r][col] == 0:
            return r
        
def print_board(board):
    print(np.flip(board,0))

board = create_board()

print_board(board)
game_over  = False
turn = 0

while not game_over:
    
    # ask player 1

    if turn == 0:
        col = int(input("Player one make your selection (0-6): "))
        
        print(col)

        if is_valid_location(board,col):
            row = get_next_open_row(board,col)
            print(row)
            drop_piece(board,row,col,1)

        

    # ask player 2
    else:
        col = int(input("Player two make your selection (0-6): "))
        
        print(col)

        if is_valid_location(board,col):
            row = get_next_open_row(board,col)
            
            drop_piece(board,row,col,2)

    print_board(board)

    piece = 1 if turn == 0 else 1

    win = winning_move(board, piece)

    if win:
         
        if piece == 1:
            print(" Player one has won")
            break
        else:
            print(" Player Two has won")
            break


    turn += 1
    turn =  turn % 2
