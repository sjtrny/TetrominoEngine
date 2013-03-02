//
//  NSMutableArray+QueueAdditions.h
//  Tetris
//
//  Created by Stephen Tierney on 2/03/13.
//  Copyright (c) 2013 Stephen Tierney. All rights reserved.
//
//  Licensed under the WTFPL, Version 2.0 (the "License")
//  You may obtain a copy of the License at
//
//  http://www.wtfpl.net/about/
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (QueueAdditions)

- (id) dequeue;
- (void) enqueue:(id)obj;

@end