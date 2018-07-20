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
#import "Peek-Swift.h"

#define PJSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define PJSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface PJEditImageViewController () <PJEditImageBottomViewDelegate, PJEditImageBottomColorViewDelegate, UIScrollViewDelegate>

@property (nonatomic, readwrite, strong) PJEditImageBottomView *bottomView;
@property (nonatomic, readwrite, strong) PJEditImageBackImageView *touchView;
@property (nonatomic, readwrite, strong) PJEditImageBottomColorView *colorView;
@property (nonatomic, readwrite, strong) PJEditImageScrollView *imageScrollView;


@property (nonatomic, readwrite, strong) UIImageView *imgView;
@property (nonatomic, readwrite, strong) UIButton *cancleBtn;
@property (nonatomic, readwrite, strong) UIButton *finishBtn;
@property (nonatomic, readwrite, strong) NSMutableArray *imageViewArray;

@property (nonatomic, readwrite, assign) int page;
@property (nonatomic, readwrite, assign) BOOL isBlur;

@end

@implementation PJEditImageViewController

- (PJEditImageScrollView *)imageScrollView {
    if (!_imageScrollView) {
        _imageScrollView = [[PJEditImageScrollView alloc] initWithFrame:CGRectMake(0, 0, PJSCREEN_WIDTH, PJSCREEN_HEIGHT - self.bottomView.height)];
        _imageScrollView.delegate = self;
        _imageScrollView.userInteractionEnabled = YES;
        
        NSInteger index = 0;
        for (UIImageView *imageView in self.imageViewDataArray) {
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(index * PJSCREEN_WIDTH, 0, _imageScrollView.width, _imageScrollView.height)];
            backView.backgroundColor = [UIColor clearColor];
            [_imageScrollView addSubview:backView];
            
            imageView.userInteractionEnabled = YES;
            // 问题有可能出在这，因为重新addSubview到了一个新的view上。
            [backView addSubview:imageView];
//            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PJSCREEN_WIDTH, PJSCREEN_HEIGHT)];
//            imageView.image = image;
//            imageView.userInteractionEnabled = YES;
//            [backView addSubview:imageView];
//            imageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
            
            // 添加绘制view
            PJEditImageBackImageView *touchView = [PJEditImageBackImageView initWithImage:imageView.image frame:CGRectMake(0, 0, imageView.width, imageView.height) lineWidth:5 lineColor:RGB(50, 50, 50)];
            touchView.tag = 2000 + index;
            touchView.userInteractionEnabled = YES;
            [imageView addSubview:touchView];
            [imageView sendSubviewToBack:touchView];
            
            [self.imageViewArray addObject:imageView];
            
            index ++;
        }
        _imageScrollView.contentSize = CGSizeMake(self.imageViewDataArray.count * PJSCREEN_WIDTH, 0);
        _imageScrollView.showsHorizontalScrollIndicator = NO;
        _imageScrollView.pagingEnabled = YES;
    }
    
    return _imageScrollView;
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
    self.isBlur = false;
    self.page = 0;
    self.imageViewArray = [NSMutableArray new];
    
    [self.view addSubview:self.imageScrollView];
    
    self.cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 50, 20)];
    [self.view addSubview:self.cancleBtn];
    [self.cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.cancleBtn setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
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
    
    self.colorView = [[PJEditImageBottomColorView alloc] initWithFrame:self.bottomView.frame];
    [self.view addSubview:self.colorView];
    self.colorView.top = PJSCREEN_HEIGHT;
    self.colorView.viewDelegate = self;
    self.colorView.hidden = true;
}

- (void)cancleBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)finishBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark delegate

- (void)PJEditImageBottomViewColorViewShow {
    self.colorView.hidden = !self.colorView.hidden;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.colorView.bottom = PJSCREEN_HEIGHT;
    } completion:nil];
}

- (void)PJEditImageBottomColorViewSelectedColor:(UIColor *)color {
    PJEditImageBackImageView *touchView = [self getTouchView];
    if (touchView) {
        [touchView setStrokeColor:color];
        touchView.isBlur = false;
    }
    _isBlur = false;
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.colorView.top = PJSCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        if (finished) {
            self.colorView.hidden = !self.colorView.hidden;
        }
    }];
}

- (void)PJEditImageBottomViewBackBtnClick {
    PJEditImageBackImageView *touchView = [self getTouchView];
    if (touchView) {
        [touchView revokeScreen];
    }
}

- (void)PJEditImageBottomViewBlurBtnClick {
    _isBlur = !_isBlur;
    PJEditImageBackImageView *touchView = [self getTouchView];
    if (touchView) {
        touchView.isBlur = _isBlur;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 滑动时添加轻微震动
    [PJTapic select];
    CGFloat offsetX = scrollView.contentOffset.x;
    self.page = (int)(offsetX + 0.5 * scrollView.width) / scrollView.width;
}

// 获取当前imageView上的touchView
- (PJEditImageBackImageView *)getTouchView {
    UIImageView *imageView = self.imageViewArray[self.page];
    NSInteger index = 0;
    PJEditImageBackImageView *touchView = nil;
    for (UIView *view in imageView.subviews) {
        if (view.tag == 2000 + self.page) {
            touchView = (PJEditImageBackImageView *)view;
        }
        index ++;
    }
    return touchView;
}

@end
