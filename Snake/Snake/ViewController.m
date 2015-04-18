//
//  ViewController.m
//  Snake
//
//  Created by eddie on 4/18/15.
//  Copyright (c) 2015 eddie. All rights reserved.
//

#import "ViewController.h"
#import "SnakeView.h"
#import "SnakeUtils.h"
#define Main_Screen_Height [[UIScreen mainScreen] applicationFrame].size.height //主屏幕的高度
#define Main_Screen_Width  [[UIScreen mainScreen] applicationFrame].size.width  //主屏幕的宽度

@interface ViewController (){
    CGFloat offsetX;
    SnakeView *mainView;
    UILabel *lblHighestScore;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    offsetX = 20.0;
    mainView = [[SnakeView alloc] initWithFrame:CGRectMake(0, offsetX, Main_Screen_Width, Main_Screen_Width)];
    [self.view addSubview:mainView];
    offsetX +=Main_Screen_Width+10;
    
    //add restart btn and score label
    [self addActionComponment];
}

-(void)addActionComponment {
    UIButton *btnRestart = [[UIButton alloc] initWithFrame:CGRectMake(20, offsetX, 80, 20)];
    btnRestart.backgroundColor = [UIColor redColor];
    [btnRestart setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [self.view addSubview:btnRestart];
    [btnRestart setTitle: @"重新开始" forState: UIControlStateNormal];
    [btnRestart addTarget:self action:@selector(restartGame) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:[mainView scoreLabel]];
    [mainView scoreLabel].frame =CGRectMake(Main_Screen_Width-80, offsetX, 60, 30);
    offsetX +=30;
    lblHighestScore= [[UILabel alloc] initWithFrame:CGRectMake(0, offsetX, Main_Screen_Width, 30)];
    lblHighestScore.textAlignment = NSTextAlignmentCenter;
    lblHighestScore.textColor = [UIColor blackColor];
    [self.view addSubview:lblHighestScore];
    
    [self refreshScore];
}

-(void) restartGame{
    [mainView restartGame];
    [self refreshScore];
}

-(void) refreshScore {
    NSArray *arrScores = [SnakeUtils getTopScores];
    if ([arrScores count]>0) {
        NSString *strScore = [NSString stringWithFormat:@"最高分: %@分",[arrScores objectAtIndex:0]];
        lblHighestScore.text= strScore;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
