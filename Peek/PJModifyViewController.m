//
//  PJModifyNameViewController.m
//  Peek
//
//  Created by pjpjpj on 2017/8/18.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "PJModifyViewController.h"

@interface PJModifyViewController ()

@end

@implementation PJModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    [self initNavigationBar];
    self.titleLabel.text = @"修改昵称";
    self.titleLabel.textColor = [UIColor blackColor];
    [self.leftBarButton setImage:[[UIImage imageNamed:@"back"] imageWithColor:[UIColor blackColor]] forState:0];
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgImgView.image = [UIImage imageNamed:@"背景"];
    [self.view addSubview:bgImgView];
    [self.view sendSubviewToBack:bgImgView];
    
    // 开启高斯模糊
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, bgImgView.frame.size.width, bgImgView.frame.size.height);
    [bgImgView addSubview:effectView];
    
    _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    [self.view addSubview:_tipsLabel];
    _tipsLabel.text = @"111";
    _tipsLabel.font = [UIFont systemFontOfSize:14];
}

- (void)setTitleText:(NSString *)titleText {
    self.titleLabel.text = titleText;
    _tipsLabel.text = titleText;
}

@end
