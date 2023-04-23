import random

class Bloco:
    def __init__(self, top, right, bottom, left):
        self.top = top
        self.right = right
        self.bottom = bottom
        self.left = left

    def __repr__(self):
        return f"bloco({self.top}, {self.right}, {self.bottom}, {self.left})"

def generate_random_pieces(rows, cols):
    return [Bloco(random.randint(0, 9), random.randint(0, 9), random.randint(0, 9), random.randint(0, 9)) for _ in range(rows * cols)]

def fix_piece_edges(pieces, rows, cols):
    for row in range(rows):
        for col in range(cols):
            current_piece = pieces[row * cols + col]

            # Fix top piece
            if row > 0:
                top_piece = pieces[(row - 1) * cols + col]
                top_piece.bottom = current_piece.top

            # Fix bottom piece
            if row < rows - 1:
                bottom_piece = pieces[(row + 1) * cols + col]
                bottom_piece.top = current_piece.bottom

            # Fix left piece
            if col > 0:
                left_piece = pieces[row * cols + (col - 1)]
                left_piece.right = current_piece.left

            # Fix right piece
            if col < cols - 1:
                right_piece = pieces[row * cols + (col + 1)]
                right_piece.left = current_piece.right

    return pieces

rows, cols = 1, 3
random_pieces = generate_random_pieces(rows, cols)
fixed_pieces = fix_piece_edges(random_pieces, rows, cols)

print('[', end = '')
print(', \n'.join([str(piece) for piece in fixed_pieces]), ']')

