//
//  Game.h
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


#import <Foundation/Foundation.h>
#include <time.h>
#include "Board.h"

// ------ Defines -----

#define WAIT_TIME 10000			// Number of milliseconds that the piece remains before going 1 block down */

@interface Game : NSObject {
    int mScreenHeight;				// Screen height in pixels
	int mNextPosX, mNextPosY;		// Position of the next piece
	int mNextPiece, mNextRotation;	// Kind and rotation of the next piece
    
	Board *mBoard;
	Pieces *mPieces;
}

- (id)initWithBoard:(Board*)board Pieces:(Pieces*)pieces andScreenHeight:(int)screenHeight;

- (void)createNewPiece;
- (void)drawScence;

@property int mPosX, mPosY;         // Position of the piece that is falling down
@property int mPiece, mRotation;    // Kind and rotation the piece that is falling down

@end
