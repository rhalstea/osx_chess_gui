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

- (id)init:(chess_piece)piece :(piece_color)color {
    _piece = piece;
    _color = color;
    
    return self;
}

- (chess_piece)piece { return _piece; };
- (piece_color)color { return _color; };

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
    
    _white_turn = true;
    _castle_string = @"KQkq";
    _en_passant = @"-";
    _half_moves = 0;
    _full_moves = 1;
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

- (NSString *)get_FEN_char:(RHboard_tile*) tile {
    NSString *ret = [RHchess_set chess_piece_toString:[tile piece]];
    
    if ([tile color] == WHITE)
        return [ret uppercaseString];
    else
        return [ret lowercaseString];
}

- (NSString *)get_FEN_string {
    NSString *fen_string = @"";
    NSString *turn = (_white_turn)? @"w":@"b";
    for (int row = 7; row >= 0; --row) {
        int blank_space = 0;

        for (int col = 0; col < 8; ++col) {
            RHboard_tile *curr_tile = _game_board[col][row];
            
            if (curr_tile != NULL) {
                if (blank_space > 0)
                    fen_string = [fen_string stringByAppendingFormat:@"%d", blank_space];
                blank_space = 0;
                
                fen_string = [fen_string stringByAppendingString:[self get_FEN_char:curr_tile]];
            }
            else {
                blank_space++;
            }            
        }
        if (blank_space > 0)
            fen_string = [fen_string stringByAppendingFormat:@"%d", blank_space];
        if (row != 0)
            fen_string = [fen_string stringByAppendingString:@"/"];

    }
    
    
    return [NSString stringWithFormat:@"%@ %@ %@ %@ %d %d", fen_string,
                                                            turn,
                                                            _castle_string,
                                                            _en_passant,
                                                            _half_moves,
                                                            _full_moves];
}


- (void)set_board_tile:(RHboard_tile *)tile :(int)col :(int)row {
    _game_board[col][row] = tile;
}
- (void)set_board_tile:(RHboard_tile *)tile :(position)pos {
    [self set_board_tile:tile :pos.col :pos.row];
}

- (char)int_toCol:(int)pos {
    return pos + 97;
}

- (void)move_tile:(int)src_col :(int)src_row :(int)dest_col :(int)dest_row {
    RHboard_tile *tile = [self get_board_tile:src_col :src_row];
    NSString *dest_pos = [NSString stringWithFormat:@"%c%d", [self int_toCol:dest_col], dest_row+1];
    
    // remove en_passant pawn
    if (tile.piece == PAWN && [dest_pos isEqualToString:_en_passant]) {
        if (tile.color == BLACK) // taking a white pawn
            [self set_board_tile:NULL :dest_col :dest_row+1];
        else   // taking a black pawn
            [self set_board_tile:NULL :dest_col :dest_row-1];
    }
    
    // mark en-passant square when moving a pawn
    if (tile.piece == PAWN) {
        if (tile.color == WHITE && src_row == 1 && dest_row == 3)
            _en_passant = [NSString stringWithFormat:@"%c%d", [self int_toCol:src_col], 3];
        else if (tile.color == BLACK && src_row == 6 && dest_row == 4)
            _en_passant = [NSString stringWithFormat:@"%c%d", [self int_toCol:src_col], 6];
        else
            _en_passant = @"-";
    }
    else
        _en_passant = @"-";
    
    // FIXME: handle castling
    [self set_board_tile:_game_board[src_col][src_row] :dest_col :dest_row];
    [self set_board_tile:NULL :src_col :src_row];
}

- (void)move_tile:(position)src :(position)dest {
    [self move_tile:src.col :src.row :dest.col :dest.row];
}

@end

