//
//  GameView.m
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

#import "GameView.h"
#import "CarbonKeyEvents.h"

@implementation GameView

- (void)awakeFromNib
{
    keyDownEvents = [[NSMutableArray alloc] init];
    mTime1 = clock();
    
    mScreenHeight = self.frame.size.height;
    mPieces = [[Pieces alloc] init];
    mBoard = [[Board alloc] initWithPieces:mPieces SreenHeight:mScreenHeight];
    mGame = [[Game alloc] initWithBoard:mBoard Pieces:mPieces andScreenHeight:mScreenHeight];
}

- (void)prepareOpenGL
{
    // Synchronize buffer swaps with vertical refresh rate
    GLint swapInt = 1;
    [[self openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];
    
    // Create a display link capable of being used with all active displays
    CVDisplayLinkCreateWithActiveCGDisplays(&displayLink);
    
    // Set the renderer output callback function
    CVDisplayLinkSetOutputCallback(displayLink, &MyDisplayLinkCallback, (__bridge void *)(self));
    
    // Set the display link for the current renderer
    CGLContextObj cglContext = [[self openGLContext] CGLContextObj];
    CGLPixelFormatObj cglPixelFormat = [[self pixelFormat] CGLPixelFormatObj];
    CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(displayLink, cglContext, cglPixelFormat);
    
    // Activate the display link
    CVDisplayLinkStart(displayLink);
}

// This is the renderer output callback function
static CVReturn MyDisplayLinkCallback(CVDisplayLinkRef displayLink, const CVTimeStamp* now, const CVTimeStamp* outputTime,
                                      CVOptionFlags flagsIn, CVOptionFlags* flagsOut, void* displayLinkContext)
{
    @autoreleasepool {
    CVReturn result = [(__bridge GameView*)displayLinkContext getFrameForTime:outputTime];
    return result;
    }
}

- (CVReturn)getFrameForTime:(const CVTimeStamp*)outputTime
{    
    // Draw
    [self drawView];
    
    // Update
    [self updateView];
    
    return kCVReturnSuccess;
}

- (void) drawView
{
	[[self openGLContext] makeCurrentContext];
    
	// We draw on a secondary thread through the display link
	// When resizing the view, -reshape is called automatically on the main thread
	// Add a mutex around to avoid the threads accessing the context simultaneously	when resizing
	CGLLockContext([[self openGLContext] CGLContextObj]);
    
    // Set viewport
    glLoadIdentity();
    glOrtho(0, self.frame.size.width, self.frame.size.height, 0, -1, 1);
    
    // Clear buffer
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // Drawing code here
    [mGame drawScence];
    
    // Update screen
    glFlush();
	CGLFlushDrawable([[self openGLContext] CGLContextObj]);
	CGLUnlockContext([[self openGLContext] CGLContextObj]);
}

- (void)updateView
{
    // Handle input
    NSEvent *latestEvent = [keyDownEvents dequeue];
    if (latestEvent != nil)
    {
        int keyCode = [latestEvent keyCode];
        switch (keyCode)
        {
            case kVK_RightArrow:
            {
                if ([mBoard isPossibleMovementAtX:mGame.mPosX + 1 andY:mGame.mPosY withPiece:mGame.mPiece andRotation:mGame.mRotation])
					mGame.mPosX++;
                break;
            }
            case kVK_LeftArrow:
            {
                if ([mBoard isPossibleMovementAtX:mGame.mPosX - 1 andY:mGame.mPosY withPiece:mGame.mPiece andRotation:mGame.mRotation])
					mGame.mPosX--;
                break;
            }
            case kVK_DownArrow:
            {
                if ([mBoard isPossibleMovementAtX:mGame.mPosX andY:mGame.mPosY + 1 withPiece:mGame.mPiece andRotation:mGame.mRotation])
					mGame.mPosY++;
                break;
            }
            case kVK_Space:
            {
                // Check collision from up to down
				while ([mBoard isPossibleMovementAtX:mGame.mPosX andY:mGame.mPosY withPiece:mGame.mPiece andRotation:mGame.mRotation])
                {
                    mGame.mPosY++;
                }
                
                [mBoard storePieceAtX:mGame.mPosX andY:mGame.mPosY - 1 withPiece:mGame.mPiece andRotation:mGame.mRotation];
                
                [mBoard deletePossibleLines];
                
				if ([mBoard isGameOver])
				{
					[[NSApplication sharedApplication] terminate:nil];
				}
                
                [mGame createNewPiece];
                
                break;
            }
            case kVK_UpArrow:
            {
                if ([mBoard isPossibleMovementAtX:mGame.mPosX andY:mGame.mPosY withPiece:mGame.mPiece andRotation:(mGame.mRotation + 1) % 4])
					mGame.mRotation = (mGame.mRotation + 1) % 4;
                break;
            }
        }
    }
    
    // Handle vertical movement
    
    unsigned long mTime2 = clock();
    
    if ((mTime2 - mTime1) > WAIT_TIME)
    {
        if ([mBoard isPossibleMovementAtX:mGame.mPosX andY:mGame.mPosY+1 withPiece:mGame.mPiece andRotation:mGame.mRotation])
        {
            mGame.mPosY++;
        }
        else
        {
            [mBoard storePieceAtX:mGame.mPosX andY:mGame.mPosY withPiece:mGame.mPiece andRotation: mGame.mRotation];
            
            [mBoard deletePossibleLines];
            
            if ([mBoard isGameOver])
            {
                       [[NSApplication sharedApplication] terminate:nil];
            }
            
            [mGame createNewPiece];
        }
        
        mTime1 = clock();
    }
}

- (void)keyDown:(NSEvent *)theEvent
{
    if([theEvent keyCode] == kVK_Escape)
       [[NSApplication sharedApplication] terminate:nil];
    else
    {
        [keyDownEvents enqueue:theEvent];
    }
}

-(BOOL)acceptsFirstResponder { return YES; }

@end
