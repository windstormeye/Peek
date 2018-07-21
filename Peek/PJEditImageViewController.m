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
#import "PJEditImageTouchView.h"
#import "Peek-Swift.h"

#define PJSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define PJSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface PJEditImageViewController () <PJEditImageBottomViewDelegate, PJEditImageBottomColorViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>

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
        _imageScrollView = [[PJEditImageScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _imageScrollView.delegate = self;
        
        NSInteger index = 0;
        for (UIImageView *imageView in self.imageViewDataArray) {
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(index * PJSCREEN_WIDTH, -20, _imageScrollView.width, _imageScrollView.height)];
            backView.backgroundColor = [UIColor clearColor];
            [_imageScrollView addSubview:backView];
            
            // 需要手动全部遍历出来
            UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PJSCREEN_WIDTH, PJSCREEN_HEIGHT)];
            tempImageView.image = imageView.image;
            tempImageView.userInteractionEnabled = YES;
            [backView addSubview:tempImageView];
            tempImageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
            for (UIImageView *view in imageView.subviews) {
                UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                imgview.image = view.image;
                [tempImageView addSubview:imgview];
            }
            
            UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
            pinch.delegate = self;
            [tempImageView addGestureRecognizer:pinch];
            
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
            pan.delegate = self;
            pan.minimumNumberOfTouches = 2;
            pan.maximumNumberOfTouches = 2;
            [tempImageView addGestureRecognizer:pan];
            
            PJEditImageTouchView *drawView = [[PJEditImageTouchView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) image:tempImageView.image];
            drawView.userInteractionEnabled = YES;
            drawView.tag = 2000 + index;
            [tempImageView addSubview:drawView];
            
            //创建一个蓝色的Layer
            CALayer *foregroundLayer        = [CALayer layer];
            foregroundLayer.bounds          = CGRectMake(0, 0, backView.width * 0.8, backView.height * 0.8);
            foregroundLayer.backgroundColor = [UIColor redColor].CGColor;
            //创建一个路径
            UIBezierPath *apath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, backView.width, backView.height) cornerRadius:0];
            //创建maskLayer
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.path = apath.CGPath;
            maskLayer.fillColor = [UIColor whiteColor].CGColor;
            maskLayer.fillRule = kCAFillRuleEvenOdd;
            //设置位置
            foregroundLayer.position = self.view.center;
            //设置mask
            foregroundLayer.mask = maskLayer;
            [backView.layer addSublayer:foregroundLayer];
            
            [self.imageViewArray addObject:tempImageView];
            
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
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)pinchAction:(UIPinchGestureRecognizer *)pinch {
    if (pinch.state==UIGestureRecognizerStateBegan || pinch.state==UIGestureRecognizerStateChanged) {
        UIImageView *imageView = self.imageViewArray[self.page];
        imageView.transform = CGAffineTransformScale(imageView.transform, pinch.scale, pinch.scale);
        pinch.scale=1;
    }
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    CGPoint p = [pan translationInView:self.view];
    UIImageView *imageView = self.imageViewArray[self.page];
    CGRect frame = CGRectMake(p.x, p.y, imageView.width, imageView.height);
    imageView.frame = frame;
    self.imageViewArray[self.page] = imageView;
}

- (void)cancleBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)finishBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CAShapeLayer *)maskStyle2:(CGRect)rect {
    //
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    
    CGFloat x = rect.size.width/2.0;
    CGFloat y = rect.size.height/2.0;
    CGFloat radius = MIN(x, y)*0.8;
    
    UIBezierPath *cycle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(x, y)
                                                         radius:radius
                                                     startAngle:0.0
                                                       endAngle:2*M_PI
                                                      clockwise:YES];
    [path appendPath:cycle];
    //
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [path CGPath];
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    
    return maskLayer;
}

# pragma mark delegate

- (void)PJEditImageBottomViewColorViewShow {
    self.colorView.hidden = !self.colorView.hidden;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.colorView.bottom = PJSCREEN_HEIGHT;
    } completion:nil];
}

- (void)PJEditImageBottomColorViewSelectedColor:(UIColor *)color {
    PJEditImageTouchView *touchView = [self getTouchView];
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
    PJEditImageTouchView *touchView = [self getTouchView];
    if (touchView) {
        [touchView revokeScreen];
    }
}

- (void)PJEditImageBottomViewBlurBtnClick {
    _isBlur = !_isBlur;
    PJEditImageTouchView *touchView = [self getTouchView];
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

// 多手势并发
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

// 获取当前imageView上的touchView
- (PJEditImageTouchView *)getTouchView {
    UIImageView *imageView = self.imageViewArray[self.page];
    NSInteger index = 0;
    PJEditImageTouchView *touchView = nil;
    for (UIView *view in imageView.subviews) {
        if (view.tag == 2000 + self.page) {
            touchView = (PJEditImageTouchView *)view;
        }
        index ++;
    }
    return touchView;
}

@end