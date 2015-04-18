//
//  Sprite.h
//  Snake
//
//  Created by eddie on 4/18/15.
//  Copyright (c) 2015 eddie. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Sprite : NSObject

@property (assign) CGFloat x;
@property (assign) CGFloat y;
@property (assign) CGFloat height;
@property (assign) CGFloat width;
@property (assign) int direction;

@end
