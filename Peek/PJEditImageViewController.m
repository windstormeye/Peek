//
//  PJEditImageViewController.m
//  editImageTest
//
//  Created by pjpjpj on 2017/11/21.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "PJEditImageViewController.h"
#import "PJEditImageBottomView.h"
#import "PJEditImageBottomColorView.h"
#import "PJEditImageTouchView.h"
#import "PJCardImageView.h"
#import "PJChoiceNoteViewController.h"
#import "PJTool.h"
#import "Peek-Swift.h"

#define PJSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define PJSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define MaxSCale 2.0  //最大缩放比例
#define MinScale 1.0  //最小缩放比例

@interface PJEditImageViewController () <PJEditImageBottomViewDelegate, PJEditImageBottomColorViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, readwrite, strong) PJEditImageBottomView *bottomView;
@property (nonatomic, readwrite, strong) PJEditImageBottomColorView *colorView;
@property (nonatomic, readwrite, strong) PJEditImageScrollView *imageScrollView;


@property (nonatomic, readwrite, strong) UIImageView *imgView;
@property (nonatomic, readwrite, strong) UIButton *cancleBtn;
@property (nonatomic, readwrite, strong) UIButton *finishBtn;
@property (nonatomic, readwrite, strong) UILabel *tipsLabel;

@property (nonatomic, readwrite, strong) NSMutableArray *imageViewArray;
@property (nonatomic, readwrite, assign) CGPoint centerPoint;
@property (nonatomic, readwrite, assign) CGFloat lastScale;

@property (nonatomic, readwrite, assign) int page;
@property (nonatomic, readwrite, assign) BOOL isBlur;

@end

@implementation PJEditImageViewController

- (PJEditImageScrollView *)imageScrollView {
    if (!_imageScrollView) {
        _imageScrollView = [[PJEditImageScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _imageScrollView.delegate = self;
        
        NSInteger index = 0;
        for (PJCardImageView *cardImageView in self.imageViewDataArray) {
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(index * PJSCREEN_WIDTH, -20, _imageScrollView.width, _imageScrollView.height)];
            backView.backgroundColor = [UIColor clearColor];
            [_imageScrollView addSubview:backView];
            
            // 需要手动全部遍历出来
            PJCardImageView *tempCardImageView = [[PJCardImageView alloc] initWithFrame:CGRectMake(0, 0, PJSCREEN_WIDTH, PJSCREEN_HEIGHT)];
            tempCardImageView.image = cardImageView.image;
            tempCardImageView.userInteractionEnabled = YES;
            [backView addSubview:tempCardImageView];
            tempCardImageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
            UIImageView *opencvImageView = [[UIImageView alloc] initWithFrame:cardImageView.openvcImageView.frame];
            opencvImageView.image = cardImageView.openvcImageView.image;
            tempCardImageView.openvcImageView = opencvImageView;
            
            UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
            pinch.delegate = self;
            [tempCardImageView addGestureRecognizer:pinch];
            
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
            pan.delegate = self;
            pan.minimumNumberOfTouches = 2;
            pan.maximumNumberOfTouches = 2;
            [tempCardImageView addGestureRecognizer:pan];
            
            PJEditImageTouchView *drawView = [[PJEditImageTouchView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) image:tempCardImageView.image];
            drawView.userInteractionEnabled = YES;
            drawView.tag = 2000 + index;
            tempCardImageView.touchView = drawView;
            
            CAShapeLayer* cropLayer = [[CAShapeLayer alloc] init];
            [backView.layer addSublayer:cropLayer];
            // 创建一个绘制路径
            CGMutablePathRef path =CGPathCreateMutable();
            // 空心矩形的rect
            CGRect cropRect = CGRectMake(backView.width * 0.1, backView.height * 0.1, backView.width * 0.8, backView.height * 0.8);
            // 绘制rect
            CGPathAddRect(path, nil, backView.bounds);
            CGPathAddRect(path, nil, cropRect);
            // 设置填充规则(重点)
            [cropLayer setFillRule:kCAFillRuleEvenOdd];
            // 关联绘制的path
            [cropLayer setPath:path];
            // 设置填充的颜色
            [cropLayer setFillColor:[[UIColor whiteColor] CGColor]];
            
            
            [self.imageViewArray addObject:tempCardImageView];
            
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
    self.lastScale = 1.0;
    
    [self.view addSubview:self.imageScrollView];
    
    self.cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 50, 20)];
    [self.view addSubview:self.cancleBtn];
    [self.cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.cancleBtn setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
    [self.cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.finishBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 10 - 80, 30, 80, 20)];
    [self.view addSubview:self.finishBtn];
    [self.finishBtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.finishBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.tipsLabel = [UILabel new];
    self.tipsLabel.text = @"图片编辑";
    self.tipsLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.view addSubview:self.tipsLabel];
    self.tipsLabel.textColor = [UIColor blackColor];
    [self.tipsLabel sizeToFit];
    self.tipsLabel.centerX = self.view.centerX;
    self.tipsLabel.centerY = self.finishBtn.centerY;
    
    
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

- (void)pinchAction:(UIPinchGestureRecognizer *)pinchGesture {
    UIView *view = pinchGesture.view;
    UIImageView *imageView = self.imageViewArray[self.page];
    
    if(pinchGesture.state == UIGestureRecognizerStateBegan) {
        self.lastScale = [pinchGesture scale];
        [self getTouchView].isStroke = NO;
    }
    
    if (pinchGesture.state == UIGestureRecognizerStateBegan ||
        pinchGesture.state == UIGestureRecognizerStateChanged) {
        CGFloat currentScale = [[view.layer valueForKeyPath:@"transform.scale"] floatValue];
        const CGFloat kMaxScale = 3.0;
        CGFloat newScale = 1 -  (self.lastScale - pinchGesture.scale);
        newScale = MIN(newScale, kMaxScale / currentScale);
        if (newScale != kMaxScale) {
            view.transform = CGAffineTransformScale(view.transform, newScale, newScale);
        }
        self.lastScale = pinchGesture.scale;
    }
    
    if (pinchGesture.state == UIGestureRecognizerStateEnded) {
        if (imageView.frame.size.width < self.view.width * 0.8) {
            [UIView animateWithDuration:0.25 animations:^{
                view.transform = CGAffineTransformMakeScale(0.8, 0.8);
            }];
        }
    }
    
    /*
     *  防止因为放缩过程中的连滞，导致只有一个手指在放缩，
     *  最终导致centerPoint在该单一手指位置，而不是两个手指的中间位置。
     */
    if([pinchGesture numberOfTouches] < 2) {
        return;
    }
    if(pinchGesture.state == UIGestureRecognizerStateBegan) {
        self.centerPoint = [pinchGesture locationInView:view];
        pinchGesture.scale=1.0;
    }

    [view.layer setAffineTransform:CGAffineTransformScale(view.transform, pinchGesture.scale, pinchGesture.scale)];
    pinchGesture.scale = 1.0;

    CGPoint nowPoint = [pinchGesture locationInView:view];
    [view.layer setAffineTransform:
     CGAffineTransformTranslate(view.transform, nowPoint.x - self.centerPoint.x, nowPoint.y - self.centerPoint.y)];
    self.centerPoint = [pinchGesture locationInView:view];
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        [self getTouchView].isStroke = NO;
    }
    //获取拖拽手势在self.view 的拖拽姿态
    CGPoint p = [pan translationInView:self.view];
    //改变panGestureRecognizer.view的中心点 就是self.imageView的中心点
    pan.view.center = CGPointMake(pan.view.center.x + p.x, pan.view.center.y + p.y);
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (pan.view.width == self.view.width * 0.8) {
            if (pan.view.x != self.view.width * 0.1 || pan.view.y != self.view.height * 0.1) {
                [UIView animateWithDuration:0.25 animations:^{
                    pan.view.x = self.view.width * 0.1;
                    pan.view.y = self.view.height * 0.1;
                } completion:^(BOOL finished) {
                    if (finished) {
                        [PJTapic select];
                    }
                }];
            }
        } else {
            // 上部白边出现
            if (pan.view.y > self.view.height * 0.1 && pan.view.x < self.view.width * 0.1 && pan.view.right > self.view.width * 0.9) {
                [UIView animateWithDuration:0.25 animations:^{
                    pan.view.y = self.view.height * 0.1;
                } completion:^(BOOL finished) {
                    [PJTapic select];
                }];
            }
            // 左部白边出现
            if (pan.view.left > self.view.width * 0.1 && pan.view.right > self.view.width * 0.9 && pan.view.top < self.view.height * 0.1 && pan.view.bottom > self.view.height * 0.9) {
                [UIView animateWithDuration:0.25 animations:^{
                    pan.view.x = self.view.width * 0.1;
                } completion:^(BOOL finished) {
                    [PJTapic select];
                }];
            }
            // 右部白边出现
            if (pan.view.right < self.view.width * 0.9 && pan.view.left < self.view.width * 0.1 && pan.view.top < self.view.height * 0.1) {
                [UIView animateWithDuration:0.25 animations:^{
                    pan.view.right = self.view.width * 0.9;
                } completion:^(BOOL finished) {
                    [PJTapic select];
                }];
            }
            // 下部空白出现
            if (pan.view.bottom < self.view.height * 0.9 && pan.view.left < self.view.width * 0.1 && pan.view.right > self.view.width * 0.9) {
                [UIView animateWithDuration:0.25 animations:^{
                    pan.view.bottom = self.view.height * 0.9;
                } completion:^(BOOL finished) {
                    [PJTapic select];
                }];
            }
            
            // 左上角白边出现
            if (pan.view.x > self.view.width * 0.1 && pan.view.y > self.view.height * 0.1) {
                [UIView animateWithDuration:0.25 animations:^{
                    pan.view.x = self.view.width * 0.1;
                    pan.view.y = self.view.height * 0.1;
                } completion:^(BOOL finished) {
                    [PJTapic select];
                }];
            }
            // 右上角白边出现
            if (pan.view.right < self.view.width * 0.9 && pan.view.y > self.view.height * 0.1) {
                [UIView animateWithDuration:0.25 animations:^{
                    pan.view.right = self.view.width * 0.9;
                    pan.view.y = self.view.height * 0.1;
                } completion:^(BOOL finished) {
                    [PJTapic select];
                }];
            }
            // 左下角白边出现
            if (pan.view.left > self.view.width * 0.1 && pan.view.bottom < self.view.height * 0.9) {
                [UIView animateWithDuration:0.25 animations:^{
                    pan.view.left = self.view.width * 0.1;
                    pan.view.bottom = self.view.height * 0.9;
                } completion:^(BOOL finished) {
                    [PJTapic select];
                }];
            }
            // 右下角白边出现
            if (pan.view.right < self.view.width * 0.9 && pan.view.left < self.view.width * 0.1 && pan.view.top < self.view.height * 0.1 && pan.view.bottom < self.view.height * 0.9) {
                [UIView animateWithDuration:0.25 animations:^{
                    pan.view.right = self.view.width * 0.9;
                    pan.view.bottom = self.view.height * 0.9;
                } completion:^(BOOL finished) {
                    [PJTapic select];
                }];
            }
        }
    }
    
    //重置拖拽手势的姿态
    [pan setTranslation:CGPointZero inView:self.view];
}

- (void)cancleBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)finishBtnClick {
    PJChoiceNoteViewController *vc = [PJChoiceNoteViewController new];
    NSInteger index = 0;
    for (PJCardImageView *card in self.imageViewArray) {
        card.touchImageView = [PJTool convertCreateImageWithUIView:card.touchView];
        index ++;
    }
    vc.cardImageViewArray = self.imageViewArray;
    [self.navigationController pushViewController:vc animated:YES];
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
        touchView.isBlur = NO;
        touchView.isStroke = YES;
    }
    self.isBlur = false;
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.colorView.top = PJSCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        if (finished) {
            self.colorView.hidden = !self.colorView.hidden;
            [self changeTipslabelText];
        }
    }];
}

- (void)PJEditImageBottomViewBackBtnClick {
    PJEditImageTouchView *touchView = [self getTouchView];
    if (touchView) {
        [touchView revokeScreen];
        touchView.isStroke = NO;
    }
    [self changeTipslabelText];
}

- (void)PJEditImageBottomViewBlurBtnClick {
    self.isBlur = !self.isBlur;
    PJEditImageTouchView *touchView = [self getTouchView];
    if (touchView) {
        touchView.isBlur = self.isBlur;
        touchView.isStroke = NO;
    }
    [self changeTipslabelText];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self getTouchView].isStroke = NO;
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

- (void)changeTipslabelText {
    if (self.isBlur) {
        self.tipsLabel.text = @"马赛克只对原内容生效";
        self.tipsLabel.textColor = [UIColor orangeColor];
        self.tipsLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.tipsLabel sizeToFit];
        self.tipsLabel.centerX = self.view.centerX;
    } else {
        self.tipsLabel.text = @"图片编辑";
        self.tipsLabel.font = [UIFont boldSystemFontOfSize:17];
        self.tipsLabel.textColor = [UIColor blackColor];
        [self.tipsLabel sizeToFit];
        self.tipsLabel.centerX = self.view.centerX;
        self.tipsLabel.centerY = self.finishBtn.centerY;
    }
}

@end
