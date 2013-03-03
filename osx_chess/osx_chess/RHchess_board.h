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

#import <Foundation/Foundation.h>
#import "RHchess_set.h"

enum {A=0, B=1, C=2, D=3, E=4, F=5, G=6, H=7};
typedef int board_column;


typedef struct {
    int col;
    int row;
} position;




@interface RHboard_tile : NSObject {
    chess_piece _piece;
    piece_color _color;
}
- (id)init:(chess_piece)piece :(piece_color)color;
- (chess_piece)piece;
- (piece_color)color;
@end




@interface RHchess_board : NSObject {
    NSColor         *_white_tile;
    NSColor         *_black_tile;

    RHboard_tile    *_game_board[8][8];
    
    bool            _white_turn;
    NSString        *_castle_string;
    NSString        *_en_passant;
    int             _half_moves;
    int             _full_moves;
    
}

- (id)init;
- (void)setup_standard_game;

- (RHboard_tile *)get_board_tile:(int)col :(int)row;
- (RHboard_tile *)get_board_tile:(position) pos;
- (NSColor *)get_tile_color:(int)col :(int)row;
- (NSString *)get_FEN_string;

- (void)set_board_tile:(RHboard_tile*)tile :(int)col :(int)row;
- (void)set_board_tile:(RHboard_tile*)tile :(position) pos;

- (void)move_tile:(int) src_col :(int)src_row :(int)dest_col :(int)dest_row;
- (void)move_tile:(position) src :(position) dest;

@end
