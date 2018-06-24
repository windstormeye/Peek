//
//  PJCardViewController.m
//  Peek
//
//  Created by pjpjpj on 2017/10/23.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "PJCardViewController.h"
#import "PJOpenCV.h"

@interface PJCardViewController ()

@end

@implementation PJCardViewController {
    UIView *_kImgContentView;
    UIImageView *_kAnswerImageView;
    UIImageView *_kOldImageView;
    UIImageView *_kTagImageView;
    BOOL isTapic;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    isTapic = false;
    self.isRed = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)dealImageWithOpenCV:(UIImage *)image {
    _kImgContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, SCREEN_HEIGHT - 74 - 60)];
    _kImgContentView.userInteractionEnabled = true;
    [self.view addSubview:_kImgContentView];
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
    UIImage *newImage = [UIImage new];
    if (_isRed) {
        newImage = [PJOpenCV imageToDiscernRed:image];
        _kAnswerImageView = newImageView;
        newImageView.image = newImage;
        UIImageView *oldImageView = [[UIImageView alloc] initWithFrame:newImageView.frame];
        oldImageView.image = image;
        _kOldImageView = oldImageView;
        [_kImgContentView addSubview:oldImageView];
        [_kImgContentView addSubview:newImageView];
    } else {
        newImage = [PJOpenCV imageToDiscernBlue:image];
        newImageView.image = newImage;
        _kAnswerImageView = newImageView;
        [_kImgContentView addSubview:newImageView];
    }
}

// 3D-Touch
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!_isRed) {
        return;
    }
    // 支持3Dtouch
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

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _kAnswerImageView.alpha = 1;
}

@end
