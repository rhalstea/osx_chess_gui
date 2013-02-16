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

#import "RHchess_set.h"

@implementation RHchess_set

- (NSImage *) get_image:(float)x :(float)y :(float)width :(float)height {
    NSImage *source = [NSImage imageNamed:@"chess_set00.gif"];
    NSImage *target = [[NSImage alloc] initWithSize:NSMakeSize(width, height)];
    
    [target lockFocus];
    [source drawInRect:NSMakeRect(0, 0, width, height)
            fromRect:NSMakeRect(x, y, width, height)
            operation:NSCompositeCopy
            fraction:1.0f];
    [target unlockFocus];
    
    return target;
}

- (NSImage *) get_chess_piece:(enum chess_piece)piece :(enum piece_color)color {
    float x;
    float y;
    
    if      (piece == PAWN)     x = 0;
    else if (piece == ROOK)     x = 27;
    else if (piece == KNIGHT)   x = 58;
    else if (piece == BISHOP)   x = 85;
    else if (piece == QUEEN)    x = 115;
    else                        x = 145;
    
    if (color == WHITE)         y = 0;
    else                        y = 47;
    
    return [self get_image:x :y :31 :46];
}

@end
