//
//  SnakeUtils.h
//  Snake
//
//  Created by eddie on 4/18/15.
//  Copyright (c) 2015 eddie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SnakeUtils : NSObject


+(void)saveScoreWithValue:(int) value;
+(NSArray*)getTopScores;
@end
