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

@property (nonatomic, readwrite, strong) UIImageView *imgView;
@property (nonatomic, readwrite, strong) PJEditImageScrollView *imageScrollView;
@property (nonatomic, readwrite, strong) UIButton *cancleBtn;
@property (nonatomic, readwrite, strong) UIButton *finishBtn;
@property (nonatomic, readwrite, strong) NSMutableArray *imageViewArray;

@property (nonatomic, readwrite, assign) NSInteger page;
@property (nonatomic, readwrite, assign) BOOL isBlur;

@end

@implementation PJEditImageViewController

- (NSArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray new];
    }
    return _imageArray;
}

- (PJEditImageScrollView *)imageScrollView {
    if (!_imageScrollView) {
        _imageScrollView = [[PJEditImageScrollView alloc] initWithFrame:CGRectMake(0, 0, PJSCREEN_WIDTH, PJSCREEN_HEIGHT - self.bottomView.height)];
        _imageScrollView.delegate = self;
        _imageScrollView.userInteractionEnabled = YES;
        
        NSInteger index = 0;
        for (UIImage *image in self.imageArray) {
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(index * PJSCREEN_WIDTH, 0, _imageScrollView.width, _imageScrollView.height)];
            backView.backgroundColor = [UIColor clearColor];
            [_imageScrollView addSubview:backView];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PJSCREEN_WIDTH, PJSCREEN_HEIGHT)];
            imageView.image = image;
            imageView.userInteractionEnabled = YES;
            [backView addSubview:imageView];
            imageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
            
            // 添加绘制view
            PJEditImageBackImageView *touchView = [PJEditImageBackImageView initWithImage:image frame:CGRectMake(0, 0, PJSCREEN_WIDTH, PJSCREEN_HEIGHT) lineWidth:5 lineColor:[UIColor blackColor]];
            touchView.tag = 2000 + index;
            touchView.userInteractionEnabled = YES;
            [imageView addSubview:touchView];
            [imageView sendSubviewToBack:touchView];
            
            [self.imageViewArray addObject:imageView];
            
            index ++;
        }
        _imageScrollView.contentSize = CGSizeMake(self.imageArray.count * PJSCREEN_WIDTH, 0);
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
    
    [self.view addSubview:self.imageScrollView];
    
    self.cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 50, 20)];
    [self.view addSubview:self.cancleBtn];
    [self.cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.cancleBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
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
    
    CGFloat marginX = (PJSCREEN_WIDTH - 50 * 4) / 5;
    self.colorView = [[PJEditImageBottomColorView alloc] initWithFrame:CGRectMake(marginX * 2 + 50, PJSCREEN_HEIGHT - 180 - 50, 50, 180)];
    [self.view addSubview:self.colorView];
    self.colorView.viewDelegate = self;
    self.colorView.hidden = true;
}

- (void)cancleBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)finishBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark delegate

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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 滑动时添加轻微震动
    [PJTapic select];
    CGFloat offsetX = scrollView.contentOffset.x;
    self.page = (offsetX + 0.5 * scrollView.width) / scrollView.width;
}

@end
