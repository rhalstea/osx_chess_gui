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

- (id) init {
    _white_tile = [NSColor colorWithCalibratedRed:0.96f green:0.93f blue:0.85f alpha:1.0f];
    _black_tile = [NSColor colorWithCalibratedRed:0.10f green:0.60f blue:0.00f alpha:1.0f];
    return self;
}

- (NSColor *)get_tile_color:(int)row :(int)col {
    if ((col + (row % 2)) % 2 == 0)
        return _black_tile;
    else
        return _white_tile;
}

@end
