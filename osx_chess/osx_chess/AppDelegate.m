//
//  AppDelegate.m
//  osx_chess
//
//  Created by Robert Halstead on 2/15/13.
//  Copyright (c) 2013 Robert Halstead. All rights reserved.
//

#import "AppDelegate.h"
#import "RHchess_board.h"
#import "RHchess_set.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSView *superview = [_window contentView];
    
    NSRect frame = [_window frame];
    frame.size.height = 704;
    [_window setFrame:frame display:YES];
    [_window setStyleMask:[_window styleMask] & ~NSResizableWindowMask];

    
    RHchess_board *game_board = [[RHchess_board alloc] init];
    RHchess_set   *game_set   = [RHchess_set alloc];
    
    //RHchess_board *board = [RHchess_board alloc];
    _game = [[RHchess_game alloc] create_game:superview :game_board :game_set];
    [_game setup_standard_game];
    
    // Setup engine
    [self addTextArea:superview];
}

- (void)addTextArea:(NSView *)superview {
    NSRect frame = NSMakeRect(32.0f, 32.0f, 512.0f, 128.0f);
    NSTextView *text_box = [[NSTextView alloc] initWithFrame:frame];
    
    [superview addSubview:text_box];

    [text_box insertText:@"Lets see if you can play Chess!"];
}

@end
