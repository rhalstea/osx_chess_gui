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

@implementation RHchess_board

// Object Member Fucntions
float _tile_width       = 64.0;
float _tile_height      = 64.0;
float _border_bottom    = 32.0;
float _border_left      = 32.0;

- (void)build_board:(NSView *)superview {
    
    for (int row = 0; row < 8; ++row) {
        for (int col = 0; col < 8; ++col) {
            float x = _border_left + _tile_width * col;
            float y = _border_bottom + _tile_height * row;
            NSButton *tile = [self add_board_tile:superview :x :y :_tile_width :_tile_height];
            if ( (col + (row%2)) % 2 == 1)
                [tile.cell setBackgroundColor:[NSColor colorWithCalibratedRed:0.96f green:0.93f blue:0.85f alpha:1.0f]];
            else
                [tile.cell setBackgroundColor:[NSColor colorWithCalibratedRed:0.1f green:0.6f blue:0.0f alpha:1.0f]];
        }
    }
}

// Modifier functions
- (void)set_tile_width:(float)width     { _tile_width = width; }
- (void)set_tile_height:(float)height   { _tile_height = height; }
- (void)set_border_bottom:(float)offset { _border_bottom = offset; }
- (void)set_border_left:(float)offset   { _border_left = offset; }

- (float)board_width    { return (2 * _border_left) + (8.0f * _tile_width); }
- (float)board_height   { return (2 * _border_bottom) + (8.0f * _tile_height); }

// Helper Functions
- (NSButton *)add_board_tile:(NSView *)superview :(float)x :(float)y :(float)width :(float)height {
    NSRect frame = NSMakeRect(x, y, width, height);
    NSButton *ret = [[NSButton alloc] initWithFrame:frame];
    [ret setTitle:@""];
    [ret setBordered:false];
    [superview addSubview:ret];

    return ret;
}

@end
