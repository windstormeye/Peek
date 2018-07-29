//
//  PJNoteViewController.m
//  Peek
//
//  Created by pjpjpj on 2018/7/24.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import "PJNoteViewController.h"
#import "PJCardImageView.h"
#import "Card+CoreDataProperties.h"
#import "UIImage+Tag.h"
#import "PJFavoriteButton.h"

@interface PJNoteViewController ()

@property (nonatomic, readwrite, strong) PJCardImageView *card;
@property (nonatomic, readwrite, strong) PJFavoriteButton *likeBtn;

@property (nonatomic, readwrite, strong) UIButton *cancleBtn;
@property (nonatomic, readwrite, strong) UIButton *commentBtn;
@property (nonatomic, readwrite, strong) UIButton *visibleBtn;
@property (nonatomic, readwrite, strong) UIButton *shareBtn;
@property (nonatomic, readwrite, strong) UIImageView *tempImageView;
@property (nonatomic, readwrite, strong) UILabel *tipsLabel;
@property (nonatomic, readwrite, strong) UILabel *dayLabel;
@property (nonatomic, readwrite, strong) UILabel *timeLabel;

@property (nonatomic, readwrite, assign) BOOL isTapic;
@property (nonatomic, readwrite, assign) NSInteger page;
@property (nonatomic, readwrite, strong) NSMutableArray *imageViewArray;

@end

@implementation PJNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageViewArray = [NSMutableArray new];
    self.page = 0;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:backImageView];
    backImageView.image = self.noteImage;
    backImageView.contentMode = UIViewContentModeScaleAspectFit;
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [backImageView addSubview:effectView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 50, self.view.width, 50)];
    [self.view addSubview:bottomView];
    
    CGFloat btnW = 50;
    CGFloat btnH = 50;
    CGFloat marginX = (bottomView.width - 4 * 50) / 5;
    
    self.cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(marginX, 0, btnW, btnH)];
    [bottomView addSubview:self.cancleBtn];
    [self.cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.cancleBtn setImage:[UIImage imageNamed:@"note_back"] forState:UIControlStateNormal];
    [self.cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.likeBtn = [[PJFavoriteButton alloc] initWithFrame:CGRectMake(self.cancleBtn.right + marginX, 5, btnW - 10, btnH - 10)];
    [bottomView addSubview:self.likeBtn];
    self.likeBtn.image = [UIImage imageNamed:@"no_like"];
    self.likeBtn.duration = 1;
    self.likeBtn.defaultColor = [UIColor blackColor];
    self.likeBtn.lineColor = [UIColor purpleColor];
    self.likeBtn.favoredColor = [UIColor redColor];
    self.likeBtn.circleColor = [UIColor yellowColor];
    self.likeBtn.userInteractionEnabled = YES;
    [self.likeBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.likeBtn.right + marginX, 0, btnW, btnH)];
    [bottomView addSubview:self.commentBtn];
    [self.commentBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    
    self.shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.commentBtn.right + marginX, 0, btnW, btnH)];
    [self.shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [bottomView addSubview:self.shareBtn];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height * 0.1)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor clearColor];
    
    UIImageView *timerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [topView addSubview:timerImageView];
    timerImageView.image = [UIImage imageNamed:@"timer"];
    timerImageView.centerX = topView.centerX;
    timerImageView.centerY = topView.centerY + 5;
    
    self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, topView.width / 2 - timerImageView.width / 2 - 10, 20)];
    [topView addSubview:self.dayLabel];
    self.dayLabel.text = @"星期天";
    self.dayLabel.textColor = [UIColor blackColor];
    self.dayLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    self.dayLabel.textAlignment = NSTextAlignmentRight;
    self.dayLabel.centerY = timerImageView.centerY;
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timerImageView.right + 10, 0, self.dayLabel.width, 20)];
    [topView addSubview:self.timeLabel];
    self.timeLabel.text = @"19:32";
    self.timeLabel.textColor = [UIColor blackColor];
    self.timeLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.centerY = timerImageView.centerY;
    
    self.visibleBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 30 - 20, 0, 30, 30)];
    [self.view addSubview:self.visibleBtn];
    self.visibleBtn.centerY = self.timeLabel.centerY;
    [self.visibleBtn addTarget:self
                        action:@selector(visibleBtnClick:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.visibleBtn setImage:[UIImage imageNamed:@"visible"]
                     forState:UIControlStateNormal];
    [self.visibleBtn setImage:[UIImage imageNamed:@"visible_off"]
                     forState:UIControlStateSelected];
    
    
    for (Card *card in self.dataArray) {
        PJCardImageView *cardImageView = [[PJCardImageView alloc] initWithFrame:CGRectMake(0, self.view.height * 0.1, self.view.width * 0.8, self.view.height * 0.8)];
        cardImageView.centerX = self.view.centerX;
        cardImageView.userInteractionEnabled = YES;
        cardImageView.image = [UIImage imageWithData:card.itemImage];
        cardImageView.layer.cornerRadius = 5;
        
        UIImageView *opencvImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cardImageView.width, cardImageView.height)];
        opencvImageView.image = [UIImage imageWithData:card.itemOpencvImage];
        cardImageView.openvcImageView = opencvImageView;
        
        UIImageView *touchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cardImageView.width, cardImageView.height)];
        touchImageView.image = [UIImage imageWithData:card.itemTouchImage];
        cardImageView.touchImageView = touchImageView;
        
        UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewSwipe:)];
        leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
        [cardImageView addGestureRecognizer:leftSwipe];
        
        UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewSwipe:)];
        rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
        [cardImageView addGestureRecognizer:rightSwipe];
        
        long double rotate =0.0;
        CGRect rect;
        float translateX =0;
        float translateY =0;
        float scaleX =1.0;
        float scaleY =1.0;
        rotate = 3 *M_PI_2;
        rect = CGRectMake(0,0, cardImageView.image.size.height, cardImageView.image.size.width);
        translateX = -rect.size.height;
        translateY = 0;
        scaleY = rect.size.width/rect.size.height;
        scaleX = rect.size.height/rect.size.width;
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context =UIGraphicsGetCurrentContext();
        //做CTM变换
        CGContextTranslateCTM(context,0.0, rect.size.height);
        CGContextScaleCTM(context,1.0, -1.0);
        CGContextRotateCTM(context, rotate);
        CGContextTranslateCTM(context, translateX, translateY);
        CGContextScaleCTM(context, scaleX, scaleY);
        //绘制图片
        CGContextDrawImage(context,CGRectMake(0,0, rect.size.width, rect.size.height), cardImageView.image.CGImage);
        cardImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        
        [self.imageViewArray addObject:cardImageView];
    }
    
    self.tempImageView = self.imageViewArray[self.page];
    [self.view addSubview:self.tempImageView];
}

- (void)cancleBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)finishBtnClick {
  
}

- (void)likeBtnClick:(PJFavoriteButton *)btn {
    btn.selected = !btn.selected;
}

- (void)visibleBtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
}

- (void)backgroundViewSwipe:(UISwipeGestureRecognizer *)swipe {
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        [self rightSwipe];
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self leftSwipe];
    }
}

- (void)rightSwipe {
    NSInteger page = self.page;
    if (page == 0) {
        return;
    }
    page --;
    self.page = page;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.tempImageView.alpha = 0;
        self.tempImageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        if (finished) {
            [self.tempImageView removeFromSuperview];
            
            self.tempImageView = self.imageViewArray[page];
            [self.view addSubview:self.tempImageView];
            self.tempImageView.right = 0;
            self.tempImageView.transform = CGAffineTransformMakeScale(1, 1);
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                self.tempImageView.centerX = self.view.centerX;
                self.tempImageView.alpha = 1;
            } completion:^(BOOL finished) {
                
                [PJTapic select];
            }];
        }
    }];
}

- (void)leftSwipe {
    NSInteger page = self.page;
    page ++;
    if (page >= self.imageViewArray.count) {
        return;
    }
    self.page = page;
    if (self.imageViewArray.count != 0) {
        [UIView animateWithDuration:0.25 delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.tempImageView.right = 0;
                             self.tempImageView.alpha = 0;
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 [self.tempImageView removeFromSuperview];
                                 self.tempImageView = nil;
                                 
                                 UIImageView *imageView = self.imageViewArray[page];
                                 imageView.centerX = self.view.centerX;
                                 imageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                                 imageView.alpha = 1;
                                 [self.view addSubview:imageView];
                                 self.tempImageView = imageView;
                                 [UIView animateWithDuration:0.25
                                                       delay:0
                                                     options:UIViewAnimationOptionCurveEaseIn
                                                  animations:^{
                                                      self.tempImageView.alpha = 1;
                                                      self.tempImageView.transform = CGAffineTransformMakeScale(1, 1);
                                                  } completion:^(BOOL finished) {
                                                      [PJTapic select];
                                                  }];
                             }
                         }];
    }
}

// 3D-Touch
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSInteger page = self.page;
    if (page >= self.imageViewArray.count) {
        return;
    }
    PJCardImageView *cardImageView = self.imageViewArray[page];
    UIImage *image = cardImageView.image;
    if (image.type.intValue != 0) {
        return;
    }
    
    UIImageView *_kAnswerImageView = cardImageView.openvcImageView;
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
    NSInteger page = self.page;
    if (page >= self.imageViewArray.count) {
        return;
    }
    PJCardImageView *cardImageView = self.imageViewArray[page];
    UIImageView *_kAnswerImageView = cardImageView.openvcImageView;
    _kAnswerImageView.alpha = 1;
}

- (void) transitionWithType:(NSString *) type WithSubtype:(NSString *) subtype ForView : (UIView *) view {
    CATransition *animation = [CATransition animation];
    animation.duration = 0.7f;
    animation.type = type;
    if (subtype != nil) {
        animation.subtype = subtype;
    }
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    [view.layer addAnimation:animation forKey:@"animation"];
}

@end
