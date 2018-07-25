//
//  PJUserForgetPasswdViewController.m
//  Peek
//
//  Created by pjpjpj on 2017/10/30.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "PJUserForgetPasswdViewController.h"

@interface PJUserForgetPasswdViewController ()

@end

@implementation PJUserForgetPasswdViewController

-(void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView {
//    [self initNavigationBar];
//    self.titleLabel.text = @"忘记密码";
//    self.titleLabel.textColor = [UIColor blackColor];
//    [self.leftBarButton setImage:[[UIImage imageNamed:@"back"] imageWithColor:[UIColor blackColor]] forState:0];
//    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    bgImgView.image = [UIImage imageNamed:@"背景"];
//    [self.view addSubview:bgImgView];
//    [self.view sendSubviewToBack:bgImgView];
    
    // 开启高斯模糊
//    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    effectView.frame = CGRectMake(0, 0, bgImgView.frame.size.width, bgImgView.frame.size.height);
//    [bgImgView addSubview:effectView];
}


@end
