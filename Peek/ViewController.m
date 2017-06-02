//
//  ViewController.m
//  Peek
//
//  Created by pjpjpj on 2017/6/1.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,weak)UIView *adView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)initView {    
    [self initNavigationBar];
    self.navigationBar.backgroundColor = [UIColor clearColor];
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 75) / 2, 35, 75, 25)];
    logoView.image = [UIImage imageNamed:@"peek"];
    [self.navigationBar addSubview:logoView];
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgImgView.image = [UIImage imageNamed:@"背景"];
    [self.view addSubview:bgImgView];
    [self.view sendSubviewToBack:bgImgView];
    
    // 开启高斯模糊
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, bgImgView.frame.size.width, bgImgView.frame.size.height);
    [bgImgView addSubview:effectView];
    
    [self.leftBarButton setImage:[UIImage imageNamed:@"汉堡线"] forState:0];
    [self.leftBarButton addTarget:self action:@selector(moreAction) forControlEvents:1<<6];
    [self.rightBarButton setImage:[UIImage imageNamed:@"朋友"] forState:0];
    [self.rightBarButton addTarget:self action:@selector(friendAction) forControlEvents:1<<6];
    
    [self setupAdView];
    
    // 添加边缘手势
    UIScreenEdgePanGestureRecognizer *ges = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(showAd:)];
    // 指定左边缘滑动
    ges.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:ges];
    
    UITapGestureRecognizer * PrivateLetterTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeAd)];
    [self.view addGestureRecognizer:PrivateLetterTap];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)showAd:(UIScreenEdgePanGestureRecognizer *)ges {
    CGPoint p = [ges locationInView:self.view];
    NSLog(@"%@", NSStringFromCGPoint(p));
    CGRect frame = self.adView.frame;
    
    // 如果已经划出view
    if (frame.origin.x == 0) {
        return;
    }
    
    // 更改adView的x值.当滑动距离超过view宽度时，则把x一直设置为0
    if (p.x > SCREEN_WIDTH * 0.6) {
         frame.origin.x = 0;
    } else {
        frame.origin.x = p.x - SCREEN_WIDTH * 0.6;
    }
    self.adView.frame = frame;
    
    if (ges.state == UIGestureRecognizerStateEnded || ges.state == UIGestureRecognizerStateCancelled) {
        // 判断当前广告视图在屏幕上显示是否超过一半
        if (CGRectContainsPoint(self.view.frame, self.adView.center)) {
            // 如果超过,那么完全展示出来
            frame.origin.x = 0;
        }else{
            // 如果没有,隐藏
            frame.origin.x = -SCREEN_WIDTH * 0.6;
        }
        [UIView animateWithDuration:0.25 animations:^{
            self.adView.frame = frame;
        }];
    }
}

/**
 *  添加滑出的view
 */
- (void)setupAdView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.6, SCREEN_HEIGHT)];
    // 设置背景颜色
    [self.view addSubview:view];
    view.backgroundColor = mainGreen;
    CGRect frame = view.frame;
    // 将x值改成负的屏幕宽度,原因是因为默认就在屏幕的左边
    frame.origin.x = -view.frame.size.width;
    // 设置给view
    view.frame = frame;
    self.adView = view;
    
    // 添加轻扫手势  -- 滑回
    UISwipeGestureRecognizer *ges = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeAd)];
    ges.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:ges];
}

- (void)closeAd {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.adView.frame;
        // 如果view已经隐藏
        if (frame.origin.x == -SCREEN_WIDTH * 0.6) {
            return;
        }
        frame.origin.x = -SCREEN_WIDTH * 0.6;
        self.adView.frame = frame;
    }];
}

- (void)moreAction {
    
}

- (void)friendAction {
    
}


@end
