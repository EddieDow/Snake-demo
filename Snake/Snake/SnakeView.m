//
//  SnakeView.m
//  Snake
//
//  Created by eddie on 4/18/15.
//  Copyright (c) 2015 eddie. All rights reserved.
//

#import "SnakeView.h"
#import "Sprite.h"
#include <stdlib.h>
#import "SnakeUtils.h"
#import "SnakeConstants.h"


#define DOWN 0
#define UP 1
#define LEFT 2
#define RIGHT 3
#define EASY (0.375f)
#define STATE_ALIVE 0
#define STATE_DEAD 1

#define x_start Main_Screen_Width*4.0/10.0
#define y_start Main_Screen_Width*4.0/10.0
#define score_piece 5.0;
#define k_refresh_interval 0.35f

@implementation SnakeView


-(id)initWithFrame:(CGRect)frame
{    
    if ((self = [super initWithFrame:frame])) {
        
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.textAlignment = NSTextAlignmentRight;
        self.backgroundColor = [UIColor grayColor];
        framesPerSecond = k_refresh_interval;
        widthSprite = frame.size.width/10.0;
        toleranceValue = widthSprite/4.0;
       
        
    }

     [self initSnake];
    [NSTimer scheduledTimerWithTimeInterval: framesPerSecond target:self selector:@selector(gameloop) userInfo:nil repeats:YES];
    return self;
}

#pragma  init the scene of view
- (void) initSnake 
{
    score = 0;
    [_scoreLabel setText:@"当前积分：0分"];
    
    state = STATE_ALIVE;
    //TODO
    Sprite *head = [[Sprite alloc] init];
    head.x = x_start;
    head.y = y_start;
    head.width = widthSprite;
    head.height = widthSprite;
    head.direction = 0;
    
    //first food
    food = [[Sprite alloc] init];
    food.width = widthSprite;
    food.height = widthSprite;
    food.x = widthSprite;
    food.y = self.frame.size.height/2.0;
    
    body = [[NSMutableArray alloc] init];
    [body addObject:head];
    
    
    //debug data init with three segments
    Sprite *b1 =  [[Sprite alloc] init];
    b1.width = widthSprite;
    b1.height = widthSprite;
    b1.x = x_start;
    b1.y = y_start-widthSprite;
    Sprite *b2 =  [[Sprite alloc] init];
    b2.width = widthSprite;
    b2.height = widthSprite;
    b2.x = x_start;
    b2.y = y_start-widthSprite;
    
    [body addObject:b1];
    [body addObject:b2];
}

//check and refresh the whole view
- (void)gameloop 
{
    if(state == STATE_ALIVE) {
        [self moveHead];
        [self setNeedsDisplay];
        [self checkCollision];
        [self checkWalls];
    }
}


- (void) moveHead {
    Sprite *oldHead = [Sprite alloc];
    Sprite *head = [Sprite alloc];
    head = [body objectAtIndex:0];
    oldHead.x = head.x;
    oldHead.y = head.y;
    if (head.direction == DOWN) {
        head.y = head.y+widthSprite;
    } else if (head.direction == UP) {
        head.y = head.y-widthSprite;
    } else if (head.direction == LEFT) {
        head.x = head.x-widthSprite;
    } else if (head.direction == RIGHT) {
        head.x = head.x+widthSprite;
    }
    
    Sprite *b;
    for(int x = 1; x < body.count; x++) {
        b = [body objectAtIndex:x];
        Sprite *tmp = [Sprite alloc];
        tmp.x = b.x;
        tmp.y = b.y;
        b.x = oldHead.x;
        b.y = oldHead.y;
        oldHead.x = tmp.x;
        oldHead.y = tmp.y;
    }
}



 - (void)drawRect:(CGRect)rect {
     CGContextRef myContext = UIGraphicsGetCurrentContext();
     Sprite *b;
     for(int x = 0; x < body.count; x++) {
         b = [body objectAtIndex:x];
         CGContextSetRGBFillColor (myContext, 100,100,100,20);
         CGContextFillRect (myContext, CGRectMake(b.x, b.y, b.width, b.height) );
     }
     
    CGContextFillRect (myContext, CGRectMake(food.x, food.y, food.width, food.height) );
 }
 

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    NSArray *pTouches = [touches allObjects];
	UITouch *first = [pTouches objectAtIndex:0];
    Sprite *head = [body objectAtIndex:0];
	touch = [first locationInView:self];
    
    if((touch.y > (head.y+head.height))&&((head.direction == LEFT)||(head.direction == RIGHT))) {
        //NSLog(@"UP");
        head.direction = DOWN;
    } else if((touch.y < head.y)&&((head.direction == LEFT)||(head.direction == RIGHT))) {
        //NSLog(@"DOWN");
        head.direction = UP;
    } else if ((touch.x < head.x)&&((head.direction == UP)||(head.direction == DOWN))) {
        //NSLog(@"LEFT");
        head.direction = LEFT;
    } else if ((touch.x > (head.x+head.width))&&((head.direction == UP)||(head.direction == DOWN))) {
        //NSLog(@"RIGHT");
        head.direction = RIGHT;
    }
}

- (void)checkCollision
{
    Sprite *tail = [Sprite alloc];
    Sprite *head = [Sprite alloc];
    head = [body objectAtIndex:0];
    
    CGRect intersectRect;
    
    for(int x = 1; x < body.count; x++) {
        tail = [body objectAtIndex:x];
        intersectRect = CGRectIntersection ( CGRectMake(head.x+1, head.y+1, head.width-1, head.height-1),
                                             CGRectMake(tail.x+1, tail.y+1, tail.width-1, tail.height-1) );
        if (!CGRectIsNull(intersectRect)) {
            //NSLog(@"DEAD");
            [self die];
            return;
        } 
    }
    // check whether overlay
    intersectRect = CGRectIntersection ( CGRectMake(head.x+1, head.y+1, head.width-1, head.height-1),
                                         CGRectMake(food.x+1, food.y+1, food.width-1, food.height-1) );
    
    if(!CGRectIsNull(intersectRect)) {
        [self updateLink];
    }

        
}

- (void) checkWalls 
{
    Sprite *head = [Sprite alloc];
    head = [body objectAtIndex:0];
    if(head.x+head.width > (self.frame.size.width+toleranceValue) && head.direction == RIGHT) {
        [self die];
    } else if(head.x < -(widthSprite+toleranceValue) && head.direction == LEFT) {
        [self die];
    } else if(head.y+head.height > (self.frame.size.height+toleranceValue) && head.direction == DOWN) {
        [self die];
    } else if(head.y < -(widthSprite+toleranceValue) && head.direction == UP) {
        [self die];
    }
}

- (void) die 
{
    [SnakeUtils saveScoreWithValue:score];
    // TODO save coordinate of each sprite on local, and restore it if need
//    for (Sprite *b in body) {
//        NSLog(@"x = %.2f y=%.2f", b.x,b.y);
//        //
//    }
    state = STATE_DEAD;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DEAD !"
                                                    message:@"" 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


- (void) generateFood {
    Sprite *tmp = [Sprite alloc];
    Boolean colliding;
    CGRect intersectRect;
    int x;
    int y;
    Boolean loop = true;
    while (loop) {
        colliding = false;
        
        x = ((rand() % 10)*widthSprite);
        y = ((rand() % 10)*widthSprite);
        food.width = widthSprite;
        food.height = widthSprite;
        food.x = x;
        food.y = y;
        
        for(int x = 0; x < body.count; x++) { 
            tmp = [body objectAtIndex:x];
            intersectRect = CGRectIntersection ( CGRectMake(tmp.x, tmp.y, tmp.width, tmp.height),
                                                 CGRectMake(food.x, food.y, food.width, food.height) );    
            if (!CGRectIsNull(intersectRect)) {
                colliding = true;
                break;
            }
        }

        if(colliding == false) {
            loop = false;
        }
    }   
}

- (void) updateLink {
    Sprite *newLink;
    Sprite *head;
    Sprite *last;
    last = [body objectAtIndex:[body count]-1];    
    head = [Sprite alloc];
    head = [body objectAtIndex:0];
    
    newLink = [Sprite alloc];
    newLink.width = widthSprite;
    newLink.height = widthSprite;
    
    if(head.direction == UP) {
        newLink.x = last.x;
        newLink.y = last.y-widthSprite;
    } else if (head.direction == DOWN) {
        newLink.x = last.x;
        newLink.y = last.y+widthSprite;
    } else if (head.direction == LEFT) {
        newLink.x = last.x+widthSprite;
        newLink.y = last.y;
    } else if (head.direction == RIGHT) {
        newLink.x = last.x-widthSprite;
        newLink.y = last.y;
    }
    
    [body addObject:newLink];
     score = score+score_piece;
    
    [_scoreLabel setText:[[NSString alloc] initWithFormat:@"当前积分：%i分",score]];
    [self generateFood];
}


- (void)restartGame {
    [self initSnake];
}

@end
