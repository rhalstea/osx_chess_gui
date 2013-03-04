//
//  AppDelegate.h
//  osx_chess
//
//  Created by Robert Halstead on 2/15/13.
//  Copyright (c) 2013 Robert Halstead. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RHchess_game.h"


@interface AppDelegate : NSObject <NSApplicationDelegate> {
    RHchess_game    *_game;
    NSTextView      *_text_box;
}

@property (assign) IBOutlet NSWindow *window;

@end
