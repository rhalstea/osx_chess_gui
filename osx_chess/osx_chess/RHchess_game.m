//
//  RHchess_game.m
//  osx_chess
//
//  Created by Robert Halstead on 2/20/13.
//  Copyright (c) 2013 Robert Halstead. All rights reserved.
//

#import "RHchess_game.h"

@implementation RHchess_game

- (id)create_game:(NSView *) parent :(RHchess_board *) game_board :(RHchess_set *) game_set {
    _parent     = parent;
    _game_board = game_board;
    _game_set   = game_set;
    
    _tile_width       = 64.0;
    _tile_height      = 64.0;
    _border_bottom    = 32.0;
    _border_left      = 32.0;
    
    [self create_board_tiles];
    
    return self;
}

- (void)create_board_tiles {
    
    for (int row = 0; row < 8; ++row) {
        for (int col = 0; col < 8; ++col) {
            float x = _border_left   + _tile_width  * col;
            float y = _border_bottom + _tile_height * row;
            
            _game_buttons[row][col] = [self create_tile:x :y :_tile_width :_tile_height];
            [_game_buttons[row][col] setTitle:[NSString stringWithFormat:@"%d_%d", row, col]];
        }
    }
}

- (void)button_event:(id) sender {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:[NSString stringWithFormat:@"I Was Clicked: %@", [sender title]]];
    [alert runModal];
}


- (NSButton *)create_tile:(float) x :(float) y :(float) width :(float) height {
    NSRect frame = NSMakeRect(x, y, width, height);
    NSButton *ret = [[NSButton alloc] initWithFrame:frame];
    
    [ret setTitle:@"aaa"];
    [ret setBordered:false];
    [ret setTarget:self];
    [ret setAction:@selector(button_event:)];
    
    [ret.cell setBackgroundColor:[NSColor colorWithCalibratedRed:0.96f green:0.93f blue:0.85f alpha:1.0f]];
    
    [_parent addSubview:ret];
    
    return ret;
}

@end
