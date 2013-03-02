//
//  AppDelegate.h
//  Tetris
//
//  Created by Stephen Tierney on 1/03/13.
//  Copyright (c) 2013 Stephen Tierney. All rights reserved.
//
//  Licensed under the WTFPL, Version 2.0 (the "License")
//  You may obtain a copy of the License at
//
//  http://www.wtfpl.net/about/
//

#import <Cocoa/Cocoa.h>
#import "GameView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet GameView *view;

@end
