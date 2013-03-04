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
    NSRect frame1 = NSMakeRect(32.0f, 32.0f, 512.0f, 128.0f);
    
    NSScrollView *scroll_box = [[NSScrollView alloc] initWithFrame:frame1];
    NSSize content_size = [scroll_box contentSize];
    
    [scroll_box setHasVerticalScroller:TRUE];
    [scroll_box setHasHorizontalScroller:FALSE];
    [scroll_box setBorderType:NSNoBorder];
    [scroll_box setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];

    NSRect frame2 = NSMakeRect(32.0f, 32.0f, 512.0f, 128.0f);
    _text_box = [[NSTextView alloc] initWithFrame:frame2];
    [_text_box setMinSize:NSMakeSize(0.0, content_size.height)];
    [_text_box setEditable:NO];
    
    [scroll_box setDocumentView:_text_box];
    [superview addSubview:scroll_box];
}

@end
