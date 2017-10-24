//
//  PJCardViewController.m
//  Peek
//
//  Created by pjpjpj on 2017/10/23.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "PJCardViewController.h"
#import "PJOpenCV.h"
#import "PJCardBottomView.h"
#import <AudioToolbox/AudioToolbox.h>

@interface PJCardViewController () <PJCardBottomViewDelegate>

@end

@implementation PJCardViewController {
    PJCardBottomView *_kBottomView;
    UIView *_kImgContentView;
    UIImageView *_kAnswerImageView;
    BOOL isTapic;
}

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

- (void)viewDidAppear:(BOOL)animated {
    [self showBottomView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    isTapic = false;
    
    
    [self initNavigationBar];
    self.titleLabel.text = @"卡片编辑";
    self.titleLabel.textColor = [UIColor blackColor];
    self.leftBarButton.hidden = true;
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgImgView.image = [UIImage imageNamed:@"背景"];
    [self.view addSubview:bgImgView];
    [self.view sendSubviewToBack:bgImgView];
    // 开启高斯模糊
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, bgImgView.frame.size.width, bgImgView.frame.size.height);
    [bgImgView addSubview:effectView];
    
    _kBottomView = [[NSBundle mainBundle] loadNibNamed:@"PJCardBottomView" owner:self options:nil].firstObject;
    // 设置初始坐标
    _kBottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 60);
    _kBottomView.viewDelegate = self;
    [self.view addSubview:_kBottomView];
}

- (void)setDealImageView:(UIImage *)dealImageView {
    [PJHUD showWithStatus:@""];
    _dealImageView = dealImageView;
    [self dealImageWithOpenCV:dealImageView];
}

- (void)dealImageWithOpenCV:(UIImage *)image {
    _kImgContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, SCREEN_HEIGHT - 74 - 60)];
    _kImgContentView.userInteractionEnabled = true;
    CGFloat imgW = 0;
    CGFloat imgH = 0;
    CGFloat lwScale = 0;
    NSInteger imgOri = image.imageOrientation;
    if (imgOri == 3) {
        lwScale = image.size.width / image.size.height;
        imgH = SCREEN_HEIGHT - 74 - 60;
        imgW = lwScale * imgH;
    }
    // 注意考虑照片大小、方向、缩放问题
    
    UIImageView *newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgW, imgH)];
    UIImage *newImage = [PJOpenCV imageToDiscernRed:image];
    _kAnswerImageView = newImageView;
    newImageView.image = newImage;
    UIImageView *oldImageView = [[UIImageView alloc] initWithFrame:newImageView.frame];
    newImageView.image = newImage;
    oldImageView.image = image;
    [_kImgContentView addSubview:oldImageView];
    [_kImgContentView addSubview:newImageView];
    [self.view addSubview:_kImgContentView];
    [PJHUD dismiss];
}

- (void)showBottomView {
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = _kBottomView.frame;
        frame.origin.y -= 60;
        _kBottomView.frame = frame;
    }];
}

// 3D-Touch
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSArray *arrayTouch = [touches allObjects];
    UITouch *touch = (UITouch *)[arrayTouch lastObject];
    _kAnswerImageView.alpha = 1 - touch.force / 6;
    if (_kAnswerImageView.alpha < 0.15 && !isTapic) {
        AudioServicesPlaySystemSound(1519);
        isTapic = true;
    }
    if (_kAnswerImageView.alpha > 0.9) {
        isTapic = false;
    }
    if (_kAnswerImageView.alpha > 0.65) {
        _kAnswerImageView.alpha  = 1.0;
    }
    
    NSLog(@"move压力 ＝ %f", 1 - touch.force / 6);
    
}

-(void)PJCardBottomViewYesBtnClick {
    NSLog(@"111");
}

- (void)PJCardBottomViewNoBtnClick {
    [self.navigationController popViewControllerAnimated:true];
}

@end
