//
//  SnakeUtils.m
//  Snake
//
//  Created by eddie on 4/18/15.
//  Copyright (c) 2015 eddie. All rights reserved.
//

#import "SnakeUtils.h"

#define KLOCALSCORE @"LOCAL_SCORE"

@implementation SnakeUtils

+(void)saveScoreWithValue:(int) value{
    NSUserDefaults *userDefault =  [NSUserDefaults standardUserDefaults];
    NSMutableArray *arrScore = [[userDefault objectForKey:KLOCALSCORE] mutableCopy];
    if (arrScore==nil) {
        arrScore = [[NSMutableArray alloc] init];
    }
    NSNumber *score = [[NSNumber alloc] initWithInt:value];
    [arrScore addObject:score];
    
    //sort array
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    NSArray *arrResult = [arrScore sortedArrayUsingComparator:cmptr];
    
    [userDefault setObject:arrResult forKey:KLOCALSCORE];
    [userDefault synchronize];
    
}


+(NSArray*)getTopScores{
    NSUserDefaults *userDefault =  [NSUserDefaults standardUserDefaults];
    NSArray *arrScore = [userDefault objectForKey:KLOCALSCORE];
    return arrScore;
}

@end
