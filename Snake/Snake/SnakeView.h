//
//  SnakeView.h
//  Snake
//
//  Created by eddie on 4/18/15.
//  Copyright (c) 2015 eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Sprite;

@interface SnakeView : UIView {
    NSMutableArray *body;
    CGPoint touch;
    Sprite *food;
    float framesPerSecond;
    int score;
    int state;
    CGFloat widthSprite;
    CGFloat toleranceValue;
}

@property (nonatomic, retain) UILabel *scoreLabel;

- (void) restartGame;

@end
