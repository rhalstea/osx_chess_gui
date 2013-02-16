//
//  AppDelegate.m
//  osx_chess
//
//  Created by Robert Halstead on 2/15/13.
//  Copyright (c) 2013 Robert Halstead. All rights reserved.
//

#import "AppDelegate.h"
#import "RHchess_board.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSView *superview = [_window contentView];
    [_window setStyleMask:[_window styleMask] & ~NSResizableWindowMask];
    
    RHchess_board *board = [RHchess_board alloc];
    [board build_board:superview];
    
}

@end
