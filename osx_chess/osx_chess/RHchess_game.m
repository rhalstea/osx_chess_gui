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
    _border_bottom      = 160.0;
    _border_left        = 32.0;
    
    _piece_source       = NULL;
    _piece_destination  = NULL;
    
    [self create_board_tiles];
    [self create_engine_terminal];
    
    _engine = [[RHuci_interface alloc] init:_engine_terminal];
    [NSThread detachNewThreadSelector:@selector(start_engine:)
                             toTarget:_engine
                           withObject:nil];
    
    return self;
}

- (void)setup_standard_game {
    [_game_board setup_standard_game];
    [self draw_board];
}

- (void)draw_board {
    for (int col = 0; col < 8; ++col)
        for (int row = 0; row < 8; ++row) {
            RHboard_tile *tile = [_game_board get_board_tile:col :row];
            if (tile == NULL)
                [_game_buttons[col][row] setImage:NULL];
            else
                [_game_buttons[col][row] setImage:[_game_set get_chess_piece:[tile piece] :[tile color]]];
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
    NSButton *destination = sender;
    
    [_piece_source setBordered:FALSE];
    _piece_source = NULL;
    
    if (source == sender) {
        return;
    }
    
    [_game_board move_tile:[self get_coordinates:source] :[self get_coordinates:destination]];
    [self draw_board];

    NSString *pos = [_game_board get_FEN_string];
    NSDictionary *info = [NSDictionary dictionaryWithObject:pos
                                                     forKey:@"position"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"position_update"
                                                        object:self
                                                      userInfo:info];
}

- (position) get_coordinates:(NSButton *) source {
    position ret;

    // FIXME: their is a better way than brute force
    for(int row = 0; row < 8; ++row)
        for (int col = 0; col < 8; ++col)
            if (source == _game_buttons[col][row]) {
                ret.col = col;
                ret.row = row;
                
                return ret;
            }
    
    ret.col = -1;
    ret.row = -1;

    return ret;
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

- (void)create_engine_terminal {
    NSRect frame1 = NSMakeRect(32.0f, 32.0f, 512.0f, 128.0f);
    
    NSScrollView *scroll_box = [[NSScrollView alloc] initWithFrame:frame1];
    NSSize content_size = [scroll_box contentSize];
    
    [scroll_box setHasVerticalScroller:TRUE];
    [scroll_box setHasHorizontalScroller:FALSE];
    [scroll_box setBorderType:NSNoBorder];
    [scroll_box setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    
    NSRect frame2 = NSMakeRect(32.0f, 32.0f, 512.0f, 128.0f);
    _engine_terminal = [[NSTextView alloc] initWithFrame:frame2];
    [_engine_terminal setMinSize:NSMakeSize(0.0, content_size.height)];
    [_engine_terminal setEditable:NO];
    
    [scroll_box setDocumentView:_engine_terminal];
    [_parent addSubview:scroll_box];
}

@end
