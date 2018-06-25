//
//  ViewController.m
//  Peek
//
//  Created by pjpjpj on 2017/6/1.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "HomeViewController.h"
#import "PJPhotoViewController.h"

#import "PJNoteCollectionView.h"
#import "PJHomeBottomView.h"
#import "Peek-Swift.h"

@interface HomeViewController () <PJHomeBottomViewDelegate, PJCameraViewDelegate>

@property (nonatomic, readwrite, assign) BOOL isShowCollectionView;

@property (nonatomic, readwrite, strong) PJNoteCollectionView *collectionView;
@property (nonatomic, readwrite, strong) PJHomeBottomView *bottomView;
@property (nonatomic, readwrite, strong) PJCameraView *cameraView;
@property (nonatomic, readwrite, strong) PJSegmentView *segmentView;

@property (nonatomic, readwrite, strong) UIRefreshControl *collectionViewRefreshControl;
@property (nonatomic, readwrite, strong) UIView *cameraTopView;
@property (nonatomic, readwrite, strong) UIView *cameraCaverView;
@property (nonatomic, readwrite, assign) NSInteger segmentIndex;

@property (nonatomic, readwrite, strong) NSMutableArray *imageArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

// MARK: layz load

- (UIView *)cameraTopView {
    if (!_cameraTopView) {
        _cameraTopView = ({
            UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bottomView.width, self.bottomView.height / 3 * 2)];
            [self.view addSubview:topView];
            topView.alpha = 0;
            topView.hidden = YES;
            
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cameraTopViewPan:)];
            [topView addGestureRecognizer:pan];
            
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.frame = topView.bounds;
            gradientLayer.colors =@[(__bridge id)[UIColor whiteColor].CGColor, (__bridge id)[UIColor colorWithWhite:2.0 alpha:0.01].CGColor];
            gradientLayer.locations = @[@0.1];
            gradientLayer.endPoint = CGPointMake(0.0, 1.0);
            gradientLayer.startPoint = CGPointMake(0.0, 0.0);
            [topView.layer addSublayer:gradientLayer];
            
            _segmentView = ({
                PJSegmentView *segmentView = [[PJSegmentView alloc] initWithFrame:CGRectMake(0, 0, topView.width / 2, topView.height / 2)];
                segmentView.centerX = topView.centerX;
                segmentView.centerY = topView.centerY;
                [topView addSubview:segmentView];
                segmentView.menuArray = @[@"红色", @"蓝色", @"整版扫描"];
                segmentView;
            });
            
            topView;
        });
    }
    return _cameraTopView;
}

- (UIView *)cameraCaverView {
    if (!_cameraCaverView) {
        _cameraCaverView = ({
            UIView *caverView = [[UIView alloc] initWithFrame:self.view.frame];
            [self.view addSubview:caverView];
            caverView.backgroundColor = [UIColor whiteColor];
            caverView.alpha = 0;
            caverView.hidden = YES;
            caverView;
        });
    }
    return _cameraCaverView;
}

// MARK: life cycle

- (void)initView {
    self.navBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.segmentIndex = 0;
    
    self.isShowCollectionView = YES;
    self.imageArray = [NSMutableArray new];
    
    self.collectionViewRefreshControl = [UIRefreshControl new];
    [self.collectionViewRefreshControl addTarget:self
                                          action:@selector(refreshAction)
                                forControlEvents:UIControlEventValueChanged];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH * 0.4, SCREEN_WIDTH * 0.4 * 1.3);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.headerReferenceSize=CGSizeMake(self.view.width, 100);
    layout.minimumLineSpacing = 25;
    layout.minimumInteritemSpacing = 25;
    layout.sectionInset = UIEdgeInsetsMake(25, 25, 25, 25);
    self.collectionView = [[PJNoteCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) collectionViewLayout:layout];
    [self.collectionView addSubview:self.collectionViewRefreshControl];
    self.collectionView.alwaysBounceVertical = YES;
    [self.view addSubview:self.collectionView];
    self.collectionView.dataArray = @[@{@"itemImageName" : @"backImage", @"itemName" : @"一个人的旅程"},
                                 @{@"itemImageName" : @"banner", @"itemName" : @"我的校园时光"},
                                 @{@"itemImageName" : @"banner2", @"itemName" : @"你要很努力才行啊！"},
                                 @{@"itemImageName" : @"banner3", @"itemName" : @"加油做自己💪"},
                                 @{@"itemImageName" : @"banner4", @"itemName" : @"每一天都要过好！"},];
    [self.collectionView reloadData];

    self.cameraView = [[PJCameraView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.cameraView];
    self.cameraView.hidden = YES;
    self.cameraView.alpha = 0;
    self.cameraView.viewDelegate = self;
    
    self.bottomView = [[PJHomeBottomView alloc] initWithFrame:CGRectMake(0, self.view.height - 100, self.view.width, 100)];
    self.bottomView.viewDelegate = self;
    [self.view addSubview:self.bottomView];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cameraViewPan:)];
    [self.bottomView addGestureRecognizer:pan];
}


// MARK: UI response
- (void)homeBottomViewButtonClick {
    [self.cameraView takePhoto];
}

-(void)refreshAction {
    NSLog(@"下拉刷新");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionViewRefreshControl endRefreshing];
    });
}

- (void)cameraTopViewPan:(UIPanGestureRecognizer *)ges {
    
    [self.view bringSubviewToFront:self.cameraCaverView];
    [self.view bringSubviewToFront:self.collectionView];
    
    CGPoint p = [ges translationInView:self.bottomView];
    CGRect frame = self.collectionView.frame;
    frame.origin.y = p.y - self.collectionView.height;
    self.collectionView.frame = frame;

    self.cameraCaverView.hidden = NO;
    self.cameraCaverView.alpha = p.y * 0.0015625;
    
    if (ges.state == UIGestureRecognizerStateEnded) {
        if (frame.origin.y > -self.view.height / 2) {
            frame.origin.y = 0;
            [UIView animateWithDuration:0.25 animations:^{
                self.collectionView.frame = frame;
            } completion:^(BOOL finished) {
                self.cameraView.hidden = YES;
                self.cameraTopView.hidden = YES;
                self.cameraCaverView.hidden = YES;
                self.isShowCollectionView = YES;

                [self.view bringSubviewToFront:self.bottomView];
                self.bottomView.isShowHomeButton = NO;
            }];
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                self.collectionView.y = -self.collectionView.height;
            } completion:^(BOOL finished) {
                self.cameraCaverView.hidden = YES;
                self.cameraCaverView.alpha = 0;
            }];
        }
    }
    
}

- (void)cameraViewPan:(UIPanGestureRecognizer *)ges {
    if (!self.isShowCollectionView) {
        return;
    }
    
    CGPoint p = [ges translationInView:self.bottomView];
    CGRect frame = self.collectionView.frame;
    frame.origin.y = p.y;
    
    self.cameraView.hidden = NO;
    self.cameraView.alpha = -p.y * 0.0015625;
    self.collectionView.frame = frame;
    
    if (ges.state == UIGestureRecognizerStateEnded) {
        if (frame.origin.y < -self.view.height / 2) {
            frame.origin.y = - self.collectionView.height;
            [UIView animateWithDuration:0.25 animations:^{
                self.collectionView.frame = frame;
            } completion:^(BOOL finished) {
                if (finished) {
                    self.isShowCollectionView = NO;
                    [UIView animateWithDuration:0.25 animations:^{
                        self.cameraView.alpha = 1;
                    }];
                    [UIView animateWithDuration:0.25 animations:^{
                        self.cameraView.alpha = 1;
                        self.cameraTopView.hidden = NO;
                        self.cameraTopView.alpha = 1;
                    } completion:^(BOOL finished) {
                        if (finished) {
                            [self.view bringSubviewToFront:self.cameraTopView];
                            [self.view bringSubviewToFront:self.bottomView];
                            self.bottomView.isShowHomeButton = YES;
                        }
                    }];
                }
            }];
        } else {
            frame.origin.y = 0;
            [UIView animateWithDuration:0.25 animations:^{
                self.collectionView.frame = frame;
            } completion:^(BOOL finished) {
                if (finished) {
                    self.isShowCollectionView = YES;
                    self.cameraView.hidden = YES;
                    self.cameraView.alpha = 0;
                }
            }];
        }
    }
}

// MARK: delegate

- (void)cameraView:(UIImage *)takePhotoImage {
//    PJPhotoViewController *vc = [PJPhotoViewController new];
//    [self.navigationController pushViewController:vc animated:true];
    [self.imageArray addObject:takePhotoImage];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.cameraView.frame];
    imageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    imageView.image = takePhotoImage;
    [self.view addSubview:imageView];
    [UIView animateWithDuration:0.25 animations:^{
        imageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        imageView.right = self.cameraView.width - 50;
        imageView.y = self.cameraView.height / 3;
    }];
}

- (void)swipeGestureWithDirection:(UISwipeGestureRecognizerDirection)direction {
    if (direction == UISwipeGestureRecognizerDirectionLeft) {
        if (self.segmentIndex != 0) {
            self.segmentIndex --;
        }
    } else {
        if (self.segmentIndex < self.segmentView.menuArray.count - 1) {
            self.segmentIndex ++;
        }
    }
    self.segmentView.segmentIndex = [NSNumber numberWithInteger:self.segmentIndex];
    [self.segmentView menuMoveByIndexWithIndex:self.segmentIndex];
}

@end
