//
//  ViewController.m
//  Peek
//
//  Created by pjpjpj on 2017/6/1.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

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
    self.titleLabel.text = @"Peek";
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgImgView.image = [UIImage imageNamed:@"背景"];
    [self.view addSubview:bgImgView];
    [self.view sendSubviewToBack:bgImgView];
    
    // 开启高斯模糊
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, bgImgView.frame.size.width, bgImgView.frame.size.height);
    [bgImgView addSubview:effectView];
    
    [self.leftBarButton setImage:[UIImage imageNamed:@"汉堡"] forState:0];
    [self.leftBarButton addTarget:self action:@selector(messageAction) forControlEvents:1<<6];
    [self.rightBarButton setImage:[UIImage imageNamed:@"好友"] forState:0];
    [self.rightBarButton addTarget:self action:@selector(settingAction) forControlEvents:1<<6];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
