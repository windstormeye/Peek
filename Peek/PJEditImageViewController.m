//
//  PJEditImageViewController.m
//  editImageTest
//
//  Created by pjpjpj on 2017/11/21.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "PJEditImageViewController.h"
#import "PJEditImageBottomView.h"
#import "PJEditImageBackImageView.h"
#import "PJEditImageBottomColorView.h"
#import <UShareUI/UShareUI.h>


#define PJSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define PJSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface PJEditImageViewController () <PJEditImageBottomViewDelegate, PJEditImageBottomColorViewDelegate>

@property (nonatomic, strong) PJEditImageBottomView *bottomView;
@property (nonatomic, strong) PJEditImageBackImageView *touchView;
@property (nonatomic, strong) PJEditImageBottomColorView *colorView;

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIScrollView *imageScrollView;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UIButton *finishBtn;

@property (nonatomic, assign) BOOL isBlur;

@end

@implementation PJEditImageViewController

- (instancetype)initWithInputImage:(UIImage *)inputImage {
    self = [super init];
    _imgView.image = inputImage;
    return self;
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
    _isBlur = false;
    
    self.cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 50, 20)];
    [self.view addSubview:self.cancleBtn];
    [self.cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.finishBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 10 - 50, 30, 50, 20)];
    [self.view addSubview:self.finishBtn];
    [self.finishBtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.bottomView = [PJEditImageBottomView new];
    [self.view addSubview:self.bottomView];
    self.bottomView.viewDelegate = self;
    
    [self.view addSubview:self.imageScrollView];
    
    self.touchView = [PJEditImageBackImageView initWithImage:self.inputImage frame:CGRectMake(0, 0, PJSCREEN_WIDTH, PJSCREEN_HEIGHT - 50) lineWidth:10 lineColor:[UIColor blackColor]];
    [self.view addSubview:self.touchView];
    [self.view sendSubviewToBack:self.touchView];
    
    CGFloat marginX = (PJSCREEN_WIDTH - 50 * 4) / 5;
    self.colorView = [[PJEditImageBottomColorView alloc] initWithFrame:CGRectMake(marginX * 2 + 50, PJSCREEN_HEIGHT - 180 - 50, 50, 180)];
    [self.view addSubview:self.colorView];
    self.colorView.viewDelegate = self;
    self.colorView.hidden = true;
}

- (UIScrollView *)imageScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, PJSCREEN_WIDTH, PJSCREEN_HEIGHT - self.bottomView.height)];
    NSInteger index = 0;
    for (UIImage *image in self.imageArray) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(index * PJSCREEN_WIDTH, 0, scrollView.width, scrollView.height)];
        backView.backgroundColor = [UIColor clearColor];
        [scrollView addSubview:backView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PJSCREEN_WIDTH, PJSCREEN_HEIGHT)];
        imageView.image = image;
        [backView addSubview:imageView];
        imageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        imageView.userInteractionEnabled = YES;
        [backView addSubview:imageView];
        
        index ++;
    }
    scrollView.contentSize = CGSizeMake(self.imageArray.count * PJSCREEN_WIDTH, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    
    [self.view bringSubviewToFront:self.cancleBtn];
    [self.view bringSubviewToFront:self.finishBtn];
    
    return scrollView;
}

- (void)cancleBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)finishBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)PJEditImageBottomViewColorViewShow {
    self.colorView.hidden = !self.colorView.hidden;
}

- (void)PJEditImageBottomColorViewSelectedColor:(UIColor *)color {
    [self.touchView setStrokeColor:color];
    self.colorView.hidden = !self.colorView.hidden;
    self.touchView.isBlur = false;
    _isBlur = false;
}

- (void)PJEditImageBottomViewBackBtnClick {
    [self.touchView revokeScreen];
}

- (void)PJEditImageBottomViewBlurBtnClick {
    _isBlur = !_isBlur;
    self.touchView.isBlur = _isBlur;
}

//PJEditImageBottomViewShareBtnClick

@end
