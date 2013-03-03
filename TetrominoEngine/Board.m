//
//  Board.m
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

#import "Board.h"

@implementation Board

- (id)initWithPieces:(Pieces*)pieces SreenHeight:(int)screenHeight
{
    self = [super init];
    if (self) {
        // Get the pointer to the pieces class
        mPieces = pieces;
        
        // Get the screen height
        mScreenHeight = screenHeight;
        
        //Init the board blocks with free positions
        [self initBoard];
    }
    return self;
}

// Init the board blocks with free positions
-(void)initBoard
{
	for (int i = 0; i < BOARD_WIDTH; i++)
		for (int j = 0; j < BOARD_HEIGHT; j++)
			mBoard[i][j] = POS_FREE;
}

/*
 Returns the horizontal position (isn pixels) of the block given like parameter
 
 Parameters:
 >> pPos:	Horizontal position of the block in the board
 */
- (int)getXPosInPixels:(int)pos
{
    return  ( ( BOARD_POSITION - (BLOCK_SIZE * (BOARD_WIDTH / 2)) ) + (pos * BLOCK_SIZE) );
}

/*
 Returns the vertical position (in pixels) of the block given like parameter
 
 Parameters:
 >> pPos:	Horizontal position of the block in the board
 */
- (int)getYPosInPixels:(int)pos
{
    return ( (mScreenHeight - (BLOCK_SIZE * BOARD_HEIGHT)) + (pos * BLOCK_SIZE) );
}

/*
 Returns 1 (true) if the this block of the board is empty, 0 if it is filled
 
 Parameters:
 >> pX:		Horizontal position in blocks
 >> pY:		Vertical position in blocks
 */
- (BOOL)isFreeBlockAtX:(int)x andY:(int)y
{
    if (mBoard [x][y] == POS_FREE) return true; else return false;
}

/*
 Check if the piece can be stored at this position without any collision
 Returns true if the movement is  possible, false if it not possible
 
 Parameters:
 >> pX:		Horizontal position in blocks
 >> pY:		Vertical position in blocks
 >> pPiece:	Piece to draw
 >> pRotation:	1 of the 4 possible rotations
 */
- (BOOL)isPossibleMovementAtX:(int)x andY:(int)y withPiece:(int)piece andRotation:(int)rotation
{
	// Checks collision with pieces already stored in the board or the board limits
	// This is just to check the 5x5 blocks of a piece with the appropiate area in the board
	for (int i1 = x, i2 = 0; i1 < x + PIECE_BLOCKS; i1++, i2++)
	{
		for (int j1 = y, j2 = 0; j1 < y + PIECE_BLOCKS; j1++, j2++)
		{
			// Check if the piece is outside the limits of the board
			if (	i1 < 0 			||
				i1 > BOARD_WIDTH  - 1	||
				j1 > BOARD_HEIGHT - 1)
			{
				if ([mPieces getBlockTypeForPiece:piece withRotation:rotation atLocationWithX:j2 andY:i2] != 0)
					return 0;
			}
            
			// Check if the piece have collisioned with a block already stored in the map
			if (j1 >= 0)
			{
				if ([mPieces getBlockTypeForPiece:piece withRotation:rotation atLocationWithX:j2 andY:i2] &&
					![self isFreeBlockAtX:i1 andY:j1])
					return false;
			}
		}
	}
    
	// No collision
	return true;
}

/*
 Store a piece in the board by filling the blocks
 
 Parameters:
 >> pX:		Horizontal position in blocks
 >> pY:		Vertical position in blocks
 >> pPiece:	Piece to draw
 >> pRotation:	1 of the 4 possible rotations
*/
- (void)storePieceAtX:(int)x andY:(int)y withPiece:(int)piece andRotation:(int)rotation
{
	// Store each block of the piece into the board
	for (int i1 = x, i2 = 0; i1 < x + PIECE_BLOCKS; i1++, i2++)
	{
		for (int j1 = y, j2 = 0; j1 < y + PIECE_BLOCKS; j1++, j2++)
		{
			// Store only the blocks of the piece that are not holes
			if ([mPieces getBlockTypeForPiece:piece withRotation:rotation atLocationWithX:j2 andY:i2] != 0)
				mBoard[i1][j1] = POS_FILLED;
		}
	}
}

/*
Delete a line of the board by moving all above lines down

Parameters:
>> pY:		Vertical position in blocks of the line to delete
*/
- (void)deleteLine:(int)pY
{
	// Moves all the upper lines one row down
	for (int j = pY; j > 0; j--)
	{
		for (int i = 0; i < BOARD_WIDTH; i++)
		{
			mBoard[i][j] = mBoard[i][j-1];
		}
	}
}

// Delete all the lines that should be removed
- (void)deletePossibleLines
{
    for (int j = 0; j < BOARD_HEIGHT; j++)
	{
		int i = 0;
		while (i < BOARD_WIDTH)
		{
			if (mBoard[i][j] != POS_FILLED) break;
			i++;
		}
        
		if (i == BOARD_WIDTH)
        {
            [self deleteLine:j];
        }
	}
}

- (BOOL)isGameOver
{
    //If the first line has blocks, then, game over
	for (int i = 0; i < BOARD_WIDTH; i++)
	{
		if (mBoard[i][0] == POS_FILLED) return true;
	}
    
	return false;
}

@end
