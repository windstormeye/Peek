//
//  PJLoginViewController.m
//  Peek
//
//  Created by pjpjpj on 2017/6/22.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "PJLoginViewController.h"

@interface PJLoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@end

@implementation PJLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    [self initNavigationBar];
    [self.leftBarButton setImage:nil forState:0];
    
    // 开启高斯模糊
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, _bgView.frame.size.width, _bgView.frame.size.height);
    [_bgView addSubview:effectView];
}

@end
