//
//  Pieces.h
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

@interface Pieces : NSObject

- (int)getBlockTypeForPiece:(int)piece withRotation:(int)rotation atLocationWithX:(int)x andY:(int)y;
- (int)getXInitialPosition:(int)piece withRoation:(int)rotation;
- (int)getYInitialPosition:(int)piece withRoation:(int)rotation;

@end