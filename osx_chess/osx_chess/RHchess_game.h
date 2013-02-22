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
#import "RHchess_board.h"

@interface RHchess_game : NSObject {
    NSView          *_parent;
    RHchess_board   *_game_board;
    RHchess_set     *_game_set;

    // When playing the game a piece will need
    // to be moved from one location to another
    NSButton        *_piece_source;
    NSButton        *_piece_destination;
    
    // Attributes for the GUI's board tiles
    NSButton        *_game_buttons[8][8];
    float           _tile_width;
    float           _tile_height;
    float           _border_bottom;
    float           _border_left;
}

- (id)create_game:(NSView *) parent :(RHchess_board *) game_board :(RHchess_set *) game_set;
- (void)setup_standard_game;

// Modifier functions
- (void)set_tile_width:(float)width;
- (void)set_tile_height:(float)height;
- (void)set_border_bottom:(float)offset;
- (void)set_border_left:(float)offset;

// Accessor functions
- (float)get_board_width;
- (float)get_board_height;

@end
