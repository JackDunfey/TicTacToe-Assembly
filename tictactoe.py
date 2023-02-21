board = [0]*9
def print_board(board):
    for i in range(3):
        print(" ".join(("X" if d == 1 else ("O" if d == -1 else "_")) for d in board[3*i:3*i+3]))
def check_win(board):
    for i in range(3):
        if sum(board[3*i:3*i+3]) == 3 or sum(board[i::3]) == 3:
            print("X wins")
            return True 
        elif sum(board[3*i:3*i+3]) == -3 or sum(board[i::3]) == -3:
            print("O wins")
            return True
    if sum(board[::4]) == 3 or sum(board[2:7:2]) == 3:
        print("X wins")
        return True
    elif sum(board[::4]) == -3 or sum(board[2:7:2]) == -3:
        print("O wins")
        return True
    return False
turn = 1
while not check_win(board):
    print_board(board)
    idx = int(input("Enter number: "))-1
    turn *= -1
    board[idx] = turn