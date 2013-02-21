//
//  RHchess_game.h
//  osx_chess
//
//  Created by Robert Halstead on 2/20/13.
//  Copyright (c) 2013 Robert Halstead. All rights reserved.
//

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

    NSButton *board[8][8];
}

- (id)create_game:(NSView *) parent :(RHchess_board *) game_board :(RHchess_set *) game_set;
- (void)create_board_tiles;
- (void)build_board:(NSView *)superview;
- (void)button_event:(id) sender;

@end
