//
//  GameView.h
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
#import <QuartzCore/CVDisplayLink.h>
#import "Game.h"
#import "NSMutableArray+QueueAdditions.h"

@interface GameView : NSOpenGLView
{
    CVDisplayLinkRef displayLink; //display link for managing rendering thread

    long mTime1;
    
    int mScreenHeight;
    Pieces *mPieces;
    Board *mBoard;
    Game *mGame;
    
    NSMutableArray *keyDownEvents;
}

@end
