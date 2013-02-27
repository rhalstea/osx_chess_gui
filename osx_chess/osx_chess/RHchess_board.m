/*
    Copyright (c) 2013, Robert J. Halstead
    All rights reserved.
 
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions
    are met:
 
    *   Redistributions of source code must retain the above copyright
        notice, this list of conditions and the following disclaimer.
 
    *   Redistributions in binary form must reproduce the above copyright
        notice, this list of conditions and the following disclaimer in
        the documentation and/or other materials provided with the
        distribution.
 
    *   Neither the name of the Robert J. Halstead nor the names of its
        contributors may be used to endorse or promote products derived
        from this software without specific prior written permission.
 
    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
    A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
    HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
    SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
    LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
    DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
    THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "RHchess_board.h"

@implementation RHboard_tile

- (id)init:(enum chess_piece)piece :(enum piece_color)color {
    _piece = piece;
    _color = color;
    
    return self;
}

- (enum chess_piece)piece { return _piece; };
- (enum piece_color)color { return _color; };

@end

@implementation RHchess_board

- (id) init {
    _white_tile = [NSColor colorWithCalibratedRed:0.96f green:0.93f blue:0.85f alpha:1.0f];
    _black_tile = [NSColor colorWithCalibratedRed:0.10f green:0.60f blue:0.00f alpha:1.0f];
    return self;
}

- (void)clear_board {
    for (int col = 0; col < 8; ++col)
        for (int row = 0; row < 8; ++row)
            _game_board[col][row] = NULL;
}

- (void)setup_standard_game {
    [self clear_board];
    
    // White's back rank
    _game_board[A][0] = [[RHboard_tile alloc] init:ROOK :WHITE];
    _game_board[B][0] = [[RHboard_tile alloc] init:KNIGHT :WHITE];
    _game_board[C][0] = [[RHboard_tile alloc] init:BISHOP :WHITE];
    _game_board[D][0] = [[RHboard_tile alloc] init:QUEEN :WHITE];
    _game_board[E][0] = [[RHboard_tile alloc] init:KING :WHITE];
    _game_board[F][0] = [[RHboard_tile alloc] init:BISHOP :WHITE];
    _game_board[G][0] = [[RHboard_tile alloc] init:KNIGHT :WHITE];
    _game_board[H][0] = [[RHboard_tile alloc] init:ROOK :WHITE];
    
    // Black's back rank
    _game_board[A][7] = [[RHboard_tile alloc] init:ROOK :BLACK];
    _game_board[B][7] = [[RHboard_tile alloc] init:KNIGHT :BLACK];
    _game_board[C][7] = [[RHboard_tile alloc] init:BISHOP :BLACK];
    _game_board[D][7] = [[RHboard_tile alloc] init:QUEEN :BLACK];
    _game_board[E][7] = [[RHboard_tile alloc] init:KING :BLACK];
    _game_board[F][7] = [[RHboard_tile alloc] init:BISHOP :BLACK];
    _game_board[G][7] = [[RHboard_tile alloc] init:KNIGHT :BLACK];
    _game_board[H][7] = [[RHboard_tile alloc] init:ROOK :BLACK];
    
    // pawns
    for (int i = 0; i < 8; ++i) {
        _game_board[i][1] = [[RHboard_tile alloc] init:PAWN :WHITE];
        _game_board[i][6] = [[RHboard_tile alloc] init:PAWN :BLACK];
    }
}


- (RHboard_tile *)get_board_tile:(int)col :(int)row {
    return _game_board[col][row];
}
- (RHboard_tile *)get_board_tile:(position)pos {
    return [self get_board_tile:pos.col :pos.row];
}
- (NSColor *)get_tile_color:(int)col :(int)row {
    return ((col + (row % 2)) % 2 == 0)? _black_tile : _white_tile;
}


- (void)set_board_tile:(RHboard_tile *)tile :(int)col :(int)row {
    _game_board[col][row] = tile;
}
- (void)set_board_tile:(RHboard_tile *)tile :(position)pos {
    [self set_board_tile:tile :pos.col :pos.row];
}

@end

