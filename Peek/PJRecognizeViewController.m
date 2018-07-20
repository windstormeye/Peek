//
//  PJRecognizeViewController.m
//  Peek
//
//  Created by pjpjpj on 2018/7/19.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import "PJRecognizeViewController.h"
#import "PJOpenCV.h"
#import "UIImage+Tag.h"
#import "PJEditImageViewController.h"

NSNotificationName const PJRecognizeViewControllerRecaptrueNotification = @"PJRecognizeViewControllerRecaptrueNotification";

@interface PJRecognizeViewController () <UIScrollViewDelegate>

@property (nonatomic, readwrite, assign) int page;
@property (nonatomic, readwrite, assign) BOOL isTapic;

@property (nonatomic, readwrite, strong) NSMutableArray *imageViewArray;

@property (nonatomic, readwrite, strong) UIButton *bottomButton;
@property (nonatomic, readwrite, strong) UIButton *cancleBtn;
@property (nonatomic, readwrite, strong) UIButton *finishBtn;
@property (nonatomic, readwrite, strong) UIButton *trashBtn;
@property (nonatomic, readwrite, strong) UIView *bottomView;
@property (nonatomic, readwrite, strong) UIImageView *tempImageView;

@end

@implementation PJRecognizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    self.navigationController.navigationBar.hidden = YES;
    self.imageViewArray = [NSMutableArray new];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 30, 50, 20)];
    [self.view addSubview:self.cancleBtn];
    [self.cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.cancleBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.finishBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 5 - 80, 30, 80, 20)];
    [self.view addSubview:self.finishBtn];
    [self.finishBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.finishBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    for (UIImage *image in self.imageArray) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageView.image = image;
        imageView.userInteractionEnabled = YES;
        imageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        
        UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewSwipe:)];
        leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
        [imageView addGestureRecognizer:leftSwipe];
        
        UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewSwipe:)];
        rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
        [imageView addGestureRecognizer:rightSwipe];

        [self.imageViewArray addObject:imageView];
        
        [self dealImageWithOpenCV:image contentView:imageView isRed:image.type.intValue];
    }
    
    self.page = (int)self.photoIndex;
    self.tempImageView = self.imageViewArray[self.page];
    [self.view addSubview:self.tempImageView];
    
    [self.view bringSubviewToFront:self.cancleBtn];
    [self.view bringSubviewToFront:self.finishBtn];
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 50, self.view.width, 50)];
    [self.view addSubview:self.bottomView];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bottomView.layer.shadowOffset = CGSizeMake(2, 2);
    self.bottomView.layer.shadowOpacity = 0.3;
    self.bottomView.layer.shadowRadius = 4;
    
    self.trashBtn = ({
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.bottomView.width - 40 - 10, (self.bottomView.height - 52) / 2 , 40, 52)];
        [self.bottomView addSubview:btn];
        [btn setImage:[UIImage imageNamed:@"trash"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(trashBtnClick) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    
    self.bottomButton = ({
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        btn.centerX = self.bottomView.centerX;
        [self.bottomView addSubview:btn];
        [btn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"重拍这一张" forState:UIControlStateNormal];
        [btn setTitleColor:RGB(30, 144, 255) forState:UIControlStateNormal];
        
        btn;
    });
}

- (void)cancleBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 下一步
- (void)rightBtnClick {
    PJEditImageViewController *vc = [PJEditImageViewController new];
    vc.imageViewDataArray = [self.imageViewArray mutableCopy];
    [self.navigationController pushViewController:vc animated:YES];
}

// 重拍
- (void)bottomBtnClick {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.tempImageView removeFromSuperview];
        self.tempImageView = nil;
        [self.imageViewArray removeObjectAtIndex:self.page];
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PJRecognizeViewControllerRecaptrueNotification
                                                        object:nil
                                                      userInfo:@{
                                                                 @"index" : [NSNumber numberWithInt:self.page],
                                                                 @"imageArray" : self.imageArray,
                                                                 }];
    
}

// 垃圾桶
- (void)trashBtnClick {
    [self.view bringSubviewToFront:self.tempImageView];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.tempImageView.x -= 20;
        self.tempImageView.y -= 100;
    } completion:^(BOOL finished) {
        
        if (finished) {
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.tempImageView.transform = CGAffineTransformMakeScale(0.2, 0.2);
                self.tempImageView.x = self.view.width;
                self.tempImageView.y = self.view.height;
            } completion:^(BOOL finished) {
                if (finished) {
                    [self.tempImageView removeFromSuperview];
                    self.tempImageView = nil;
                    [self.imageViewArray removeObjectAtIndex:self.page];
                    
                    if (self.imageViewArray.count == 0) {
                        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                            self.bottomView.top = self.view.height;
                        } completion:^(BOOL finished) {
                            if (finished) {
                                UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 15)];
                                [self.view addSubview:tipsLabel];
                                tipsLabel.text = @"空空如也~快去拍一些吧";
                                [tipsLabel sizeToFit];
                                tipsLabel.centerX = self.view.centerX;
                                tipsLabel.centerY = self.view.centerY;
                                tipsLabel.textColor = [UIColor blackColor];
                                tipsLabel.font = [UIFont systemFontOfSize:15];
                                tipsLabel.alpha = 0;
                                
                                [UIView animateWithDuration:0.25 animations:^{
                                    tipsLabel.alpha = 1;
                                }];
                            }
                        }];
                    }
                    
                    if (self.page == self.imageViewArray.count) {
                        [self rightSwipe];
                        return ;
                    }
                    self.page --;
                    
                    [self leftSwipe];
                }
            }];
        }
    }];
}

- (void)backgroundViewSwipe:(UISwipeGestureRecognizer *)swipe {
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        [self rightSwipe];
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self leftSwipe];
    }
}

- (void)rightSwipe {
    self.bottomButton.enabled = NO;
    self.trashBtn.enabled = NO;
    
    int page = self.page;
    if (page == 0) {
        self.bottomButton.enabled = YES;
        self.trashBtn.enabled = YES;
        return;
    }
    page --;
    self.page = page;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.tempImageView.alpha = 0;
        self.tempImageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    } completion:^(BOOL finished) {
        if (finished) {
            [self.tempImageView removeFromSuperview];
            
            self.tempImageView = self.imageViewArray[page];
            [self.view addSubview:self.tempImageView];
            self.tempImageView.right = 0;
            self.tempImageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                self.tempImageView.centerX = self.view.centerX;
                self.tempImageView.alpha = 1;
            } completion:^(BOOL finished) {
                
                [PJTapic select];
                self.bottomButton.enabled = YES;
                self.trashBtn.enabled = YES;
            }];
        }
    }];
}

- (void)leftSwipe {
    self.bottomButton.enabled = NO;
    self.trashBtn.enabled = NO;
    
    int page = self.page;
    page ++;
    if (page >= self.imageViewArray.count) {
        self.bottomButton.enabled = YES;
        self.trashBtn.enabled = YES;
        return;
    }
    self.page = page;
    if (self.imageViewArray.count != 0) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.tempImageView.right = 0;
            self.tempImageView.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                [self.tempImageView removeFromSuperview];
                self.tempImageView = nil;
                
                UIImageView *imageView = self.imageViewArray[page];
                imageView.centerX = self.view.centerX;
                imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
                imageView.alpha = 1;
                [self.view addSubview:imageView];
                self.tempImageView = imageView;
                [UIView animateWithDuration:0.25
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                     self.tempImageView.alpha = 1;
                                     self.tempImageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
                                 } completion:^(BOOL finished) {
                                     
                                     [PJTapic select];
                                     self.bottomButton.enabled = YES;
                                     self.trashBtn.enabled = YES;
                                 }];
            }
        }];
    }
}

- (void)dealImageWithOpenCV:(UIImage *)image contentView:(UIView *)contentView isRed:(NSInteger)type {
    UIImageView *newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    UIImage *newImage = [UIImage new];
    if (type == 0) {
        newImage = [PJOpenCV imageToDiscernRed:image];
        UIImageView *_kAnswerImageView = newImageView;
        newImageView.image = newImage;
        [contentView addSubview:_kAnswerImageView];
        
        _kAnswerImageView.userInteractionEnabled = YES;
        
        // 标识
        _kAnswerImageView.tag = 1002;
    } else {
        newImage = [PJOpenCV imageToDiscernBlue:image];
        newImageView.image = newImage;
        UIImageView *_kAnswerImageView = newImageView;
        [contentView addSubview:_kAnswerImageView];
        
        // 标识
        _kAnswerImageView.tag = 1002;
    }
}


// 3D-Touch
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    int page = self.page;
    if (page >= self.imageViewArray.count) {
        return;
    }
    UIImage *image = self.imageArray[page];
    if (image.type.intValue != 0) {
        return;
    }
    
    UIImageView *_kAnswerImageView = nil;
    UIImageView *imageView = self.imageViewArray[page];
    for (UIImageView *tampImageView in imageView.subviews) {
        if (tampImageView.tag == 1002) {
            _kAnswerImageView = tampImageView;
        }
    }
    // 支持3Dtouch
    NSArray *arrayTouch = [touches allObjects];
    UITouch *touch = (UITouch *)[arrayTouch lastObject];
    _kAnswerImageView.alpha = 1 - touch.force / 6;
    if (_kAnswerImageView.alpha < 0.15 && !self.isTapic) {
        AudioServicesPlaySystemSound(1519);
        self.isTapic = true;
    }
    if (_kAnswerImageView.alpha > 0.9) {
        self.isTapic = false;
    }
    if (_kAnswerImageView.alpha > 0.65) {
        _kAnswerImageView.alpha  = 1.0;
    }

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    int page = self.page;
    if (page >= self.imageViewArray.count) {
        return;
    }
    UIImageView *_kAnswerImageView = nil;
    UIImageView *imageView = self.imageViewArray[page];
    for (UIImageView *tampImageView in imageView.subviews) {
        if (tampImageView.tag == 1002) {
            _kAnswerImageView = tampImageView;
        }
    }
    _kAnswerImageView.alpha = 1;
}

@end
