//
//  Game.m
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

#import "Game.h"

@implementation Game

@synthesize mPosX, mPosY, mPiece, mRotation;

- (id)initWithBoard:(Board*)board Pieces:(Pieces*)pieces andScreenHeight:(int)screenHeight
{
    self = [super init];
    if (self) {
        mScreenHeight = screenHeight;
        
        // Get the pointer to the Board and Pieces classes
        mBoard = board;
        mPieces = pieces;
//    	mIO = pIO;
        
        // Game initialization
        [self initGame];
    }
    return self;
}

/*
 Initial parameters of the game
 */
- (void)initGame
{
    // Init random numbers
	srand ((unsigned int) time(NULL));
    
	// First piece
	mPiece			= [self getRandBetween:0 and:6];
	mRotation		= [self getRandBetween:0 and:3];
	mPosX 			= (BOARD_WIDTH / 2) + [mPieces getXInitialPosition:mPiece withRoation:mRotation];
	mPosY 			= [mPieces getYInitialPosition:mPiece withRoation:mRotation];
    
	//  Next piece
	mNextPiece 		= [self getRandBetween:0 and:6];
	mNextRotation 	= [self getRandBetween:0 and:3];
	mNextPosX 		= BOARD_WIDTH + 5;
	mNextPosY 		= 5;
}

- (int)getRandBetween:(int)pA and:(int)pB
{
    return rand () % (pB - pA + 1) + pA;
}

- (void)createNewPiece
{
    // The new piece
	mPiece			= mNextPiece;
	mRotation		= mNextRotation;
	mPosX 			= (BOARD_WIDTH / 2) + [mPieces getXInitialPosition:mPiece withRoation:mRotation];
	mPosY 			= [mPieces getYInitialPosition:mPiece withRoation:mRotation];
    
	// Random next piece
	mNextPiece 		= [self getRandBetween:0 and:6];
	mNextRotation 	= [self getRandBetween:0 and:3];
}

- (void)drawPieceAtX:(int)x andY:(int)y withPiece:(int)piece andRotation:(int)rotation
{    
	// Obtain the position in pixel in the screen of the block we want to draw
	int mPixelsX = [mBoard getXPosInPixels:x];
	int mPixelsY = [mBoard getYPosInPixels:y];
    
	// Travel the matrix of blocks of the piece and draw the blocks that are filled
	for (int i = 0; i < PIECE_BLOCKS; i++)
	{
		for (int j = 0; j < PIECE_BLOCKS; j++)
		{
			// Get the type of the block and draw it with the correct color
			switch ([mPieces getBlockTypeForPiece:piece withRotation:rotation atLocationWithX:j andY:i])
			{
				case 1: glColor3f(0.0, 1.0, 0.0);; break;	// For each block of the piece except the pivot
				case 2: glColor3f(0.0, 0.0, 1.0);; break;	// For the pivot
			}
			
			if ([mPieces getBlockTypeForPiece:piece withRotation:rotation atLocationWithX:j andY:i] != 0)
            {
                    [self drawRectangle:CGRectMake(mPixelsX + i * BLOCK_SIZE, mPixelsY + j * BLOCK_SIZE, BLOCK_SIZE - 1, BLOCK_SIZE - 1)];
            }
		}
	}
}

/*
 Draws a filled rectangle
 */
- (void)drawRectangle:(CGRect)rectangle
{
    glBegin(GL_POLYGON);
    glVertex2i(rectangle.origin.x, rectangle.origin.y);
    glVertex2i(rectangle.origin.x + rectangle.size.width, rectangle.origin.y);
    glVertex2i(rectangle.origin.x + rectangle.size.width, rectangle.origin.y + rectangle.size.height);
    glVertex2i(rectangle.origin.x, rectangle.origin.y + rectangle.size.height);
    glEnd();
}

- (void)drawBoard
{
	// Calculate the limits of the board in pixels
	int mX1 = BOARD_POSITION - (BLOCK_SIZE * (BOARD_WIDTH / 2)) - 1;
	int mX2 = BOARD_POSITION + (BLOCK_SIZE * (BOARD_WIDTH / 2));
	int mY = mScreenHeight - (BLOCK_SIZE * BOARD_HEIGHT);
    
	// Rectangles that delimits the board
    glColor3f(1.0, 0.0, 0.0);
    [self drawRectangle:CGRectMake(mX1 - BOARD_LINE_WIDTH, mY, BOARD_LINE_WIDTH, mScreenHeight - 1)];
    [self drawRectangle:CGRectMake(mX2, mY, BOARD_LINE_WIDTH, mScreenHeight - 1)];
    
	// Drawing the blocks that are already stored in the board
	mX1 += 1;
    glColor3f(1.0, 0.0, 0.0);
	for (int i = 0; i < BOARD_WIDTH; i++)
	{
		for (int j = 0; j < BOARD_HEIGHT; j++)
		{
			// Check if the block is filled, if so, draw it
			if (![mBoard isFreeBlockAtX:i andY:j])
            {
                [self drawRectangle:CGRectMake(mX1 + i * BLOCK_SIZE, mY + j * BLOCK_SIZE, BLOCK_SIZE - 1, BLOCK_SIZE - 1)];
            }
		}
	}
}

- (void)drawScence
{
	[self drawBoard];													// Draw the delimitation lines and blocks stored in the board
	[self drawPieceAtX:mPosX andY:mPosY withPiece:mPiece andRotation:mRotation];					// Draw the playing piece
	[self drawPieceAtX:mNextPosX andY:mNextPosY withPiece:mNextPiece andRotation:mNextRotation];    // Draw the next piece
}

@end
