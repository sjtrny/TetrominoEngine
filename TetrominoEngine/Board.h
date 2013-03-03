//
//  Board.h
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
#include "Pieces.h"

#define BOARD_LINE_WIDTH 6			// Width of each of the two lines that delimit the board
#define BLOCK_SIZE 16				// Width and Height of each block of a piece
#define BOARD_POSITION 320			// Center position of the board from the left of the screen
#define BOARD_WIDTH 10				// Board width in blocks
#define BOARD_HEIGHT 20				// Board height in blocks
#define MIN_VERTICAL_MARGIN 20		// Minimum vertical margin for the board limit
#define MIN_HORIZONTAL_MARGIN 20	// Minimum horizontal margin for the board limit
#define PIECE_BLOCKS 5				// Number of horizontal and vertical blocks of a matrix piece

@interface Board : NSObject {
    enum { POS_FREE, POS_FILLED };			// POS_FREE = free position of the board; POS_FILLED = filled position of the board
	int mBoard [BOARD_WIDTH][BOARD_HEIGHT];	// Board that contains the pieces
	Pieces *mPieces;
	int mScreenHeight;
}

- (id)initWithPieces:(Pieces*)pieces SreenHeight:(int)screenHeight;

- (int)getXPosInPixels:(int)pos;
- (int)getYPosInPixels:(int)pos;
- (BOOL)isFreeBlockAtX:(int)x andY:(int)y;
- (BOOL)isPossibleMovementAtX:(int)x andY:(int)y withPiece:(int)piece andRotation:(int)rotation;
- (void)storePieceAtX:(int)x andY:(int)y withPiece:(int)piece andRotation:(int)rotation;
- (void)deletePossibleLines;
- (BOOL)isGameOver;

@end
