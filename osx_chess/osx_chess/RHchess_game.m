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
#import "RHchess_game.h"

@implementation RHchess_game

- (id)create_game:(NSView *) parent :(RHchess_board *) game_board :(RHchess_set *) game_set {
    _parent             = parent;
    _game_board         = game_board;
    _game_set           = game_set;
    
    _tile_width         = 64.0;
    _tile_height        = 64.0;
    _border_bottom      = 32.0;
    _border_left        = 32.0;
    
    _piece_source       = NULL;
    _piece_destination  = NULL;
    
    [self create_board_tiles];
    
    return self;
}

- (void)setup_standard_game {
    // White's back rank
    [_game_buttons[A][0] setImage:[_game_set get_chess_piece:ROOK :WHITE]];
    [_game_buttons[B][0] setImage:[_game_set get_chess_piece:KNIGHT :WHITE]];
    [_game_buttons[C][0] setImage:[_game_set get_chess_piece:BISHOP :WHITE]];
    [_game_buttons[D][0] setImage:[_game_set get_chess_piece:QUEEN :WHITE]];
    [_game_buttons[E][0] setImage:[_game_set get_chess_piece:KING :WHITE]];
    [_game_buttons[F][0] setImage:[_game_set get_chess_piece:BISHOP :WHITE]];
    [_game_buttons[G][0] setImage:[_game_set get_chess_piece:KNIGHT :WHITE]];
    [_game_buttons[H][0] setImage:[_game_set get_chess_piece:ROOK :WHITE]];
   
    // Black's back rank
    [_game_buttons[A][7] setImage:[_game_set get_chess_piece:ROOK :BLACK]];
    [_game_buttons[B][7] setImage:[_game_set get_chess_piece:KNIGHT :BLACK]];
    [_game_buttons[C][7] setImage:[_game_set get_chess_piece:BISHOP :BLACK]];
    [_game_buttons[D][7] setImage:[_game_set get_chess_piece:QUEEN :BLACK]];
    [_game_buttons[E][7] setImage:[_game_set get_chess_piece:KING :BLACK]];
    [_game_buttons[F][7] setImage:[_game_set get_chess_piece:BISHOP :BLACK]];
    [_game_buttons[G][7] setImage:[_game_set get_chess_piece:KNIGHT :BLACK]];
    [_game_buttons[H][7] setImage:[_game_set get_chess_piece:ROOK :BLACK]];

    // pawns
    for (int i = 0; i < 8; ++i) {
        [_game_buttons[i][1] setImage:[_game_set get_chess_piece:PAWN :WHITE]];
        [_game_buttons[i][6] setImage:[_game_set get_chess_piece:PAWN :BLACK]];
    }
}

// Modifier Functions
- (void)set_tile_width:(float)width     { _tile_width = width; }
- (void)set_tile_height:(float)height   { _tile_height = height; }
- (void)set_border_bottom:(float)offset { _border_bottom = offset; }
- (void)set_border_left:(float)offset   { _border_left = offset; }

// Accessor Functions
- (float)get_board_width    { return (2 * _border_left) + (8.0f * _tile_width); }
- (float)get_board_height   { return (2 * _border_bottom) + (8.0f * _tile_height); }


// Helper functions
- (void)button_event:(id) sender {
    if (_piece_source == NULL) {
        _piece_source = sender;
        [_piece_source setBordered:TRUE];
        return;
    }
    
    NSButton *source = _piece_source;
    
    [_piece_source setBordered:FALSE];
    _piece_source = NULL;
    
    if (source == sender) {
        return;
    }
    
    [sender setImage:[source image]];
    [source setImage:NULL];
    /*
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:[NSString stringWithFormat:@"Going from %@ to %@", [source title], [sender title]]];
    [alert runModal];
     */
}

- (NSButton *)create_tile:(float) x :(float) y :(float) width :(float) height {
    NSRect frame = NSMakeRect(x, y, width, height);
    NSButton *ret = [[NSButton alloc] initWithFrame:frame];
    
    [ret setTitle:NULL];
    [ret setBordered:false];
    [ret setTarget:self];
    [ret setAction:@selector(button_event:)];
    
    [ret.cell setBackgroundColor:[NSColor colorWithCalibratedRed:0.96f green:0.93f blue:0.85f alpha:1.0f]];
    
    [_parent addSubview:ret];
    
    return ret;
}

- (void)create_board_tiles {
    
    for (int row = 0; row < 8; ++row) {
        for (int col = 0; col < 8; ++col) {
            float x = _border_left   + _tile_width  * col;
            float y = _border_bottom + _tile_height * row;
            
            _game_buttons[col][row] = [self create_tile:x :y :_tile_width :_tile_height];
            [_game_buttons[col][row].cell setBackgroundColor:[_game_board get_tile_color:col :row]];
        }
    }
}

@end
