//
//  ViewController.m
//  Peek
//
//  Created by pjpjpj on 2017/6/1.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong)UIView *leftView;
@property(nonatomic,strong)UIView *leftBGView;
@property(nonatomic,strong)UIView *rightView;
@property(nonatomic,strong)UIView *rightBGView;

@property (nonatomic,strong) UIImagePickerController *imagePicker;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)initView {    
    [self initNavigationBar];
    self.navigationBar.backgroundColor = [UIColor clearColor];
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 75) / 2, 35, 75, 25)];
    logoView.image = [UIImage imageNamed:@"peek"];
    [self.navigationBar addSubview:logoView];
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgImgView.image = [UIImage imageNamed:@"背景"];
    [self.view addSubview:bgImgView];
    [self.view sendSubviewToBack:bgImgView];
    
    // 开启高斯模糊
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, bgImgView.frame.size.width, bgImgView.frame.size.height);
    [bgImgView addSubview:effectView];
    
    [self.leftBarButton setImage:[UIImage imageNamed:@"汉堡线"] forState:0];
    [self.leftBarButton addTarget:self action:@selector(moreAction) forControlEvents:1<<6];
    [self.rightBarButton setImage:[UIImage imageNamed:@"朋友"] forState:0];
    [self.rightBarButton addTarget:self action:@selector(friendAction) forControlEvents:1<<6];
    
    [self setupLeftView];
    [self setupRightView];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)takePhoto:(id)sender {
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerController代理方法
// 完成拍照后的回调方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
}

/**
 *  点击相册取消按钮的回调方法
 *
 *  @param picker 取消按钮
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 重写imagePicker的geter方法
- (UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
        // 判断现在可以获得多媒体的方式
        if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
            // 设置image picker的来源，这里设置为摄像头
            _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            // 设置使用哪个摄像头，这里默认设置为前置摄像头
            _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            // 设置摄像头模式为照相
            _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            }
        }
        // 允许编辑
//        _imagePicker.allowsEditing=YES;
        // 设置代理，检测操作
        _imagePicker.delegate=self;
        return _imagePicker;
}

// 开启左侧滑功能
- (void)showLeftAd:(UIScreenEdgePanGestureRecognizer *)ges {
    
    CGPoint p = [ges locationInView:self.view];
    NSLog(@"%@", NSStringFromCGPoint(p));
    CGRect frame = self.leftView.frame;
    
    // 如果已经划出view
    if (frame.origin.x == 0) {
        return;
    }
    
    // 更改adView的x值.当滑动距离超过view宽度时，则把x一直设置为0
    if (p.x > SCREEN_WIDTH * 0.6) {
         frame.origin.x = 0;
    } else {
        CGRect frame = self.leftView.frame;
        frame.origin.x = p.x - SCREEN_WIDTH * 0.6;
    }
    self.leftView.frame = frame;
    
    if (ges.state == UIGestureRecognizerStateEnded || ges.state == UIGestureRecognizerStateCancelled) {
        // 判断当前广告视图在屏幕上显示是否超过一半
        if (CGRectContainsPoint(self.view.frame, self.leftView.center)) {
            // 如果超过,那么完全展示出来
            frame.origin.x = 0;
        }else{
            // 如果没有,隐藏
            frame.origin.x = -SCREEN_WIDTH * 0.6;
        }
        [UIView animateWithDuration:0.25 animations:^{
            self.leftView.frame = frame;
        }];
    }
}

// 开启右侧滑功能
- (void)showRightAd:(UIScreenEdgePanGestureRecognizer *)ges {
    CGPoint p = [ges locationInView:self.view];
    NSLog(@"%@", NSStringFromCGPoint(p));
    CGRect frame = self.rightView.frame;
    
    // 如果已经划出view
    if (frame.origin.x == SCREEN_WIDTH * 0.4) {
        return;
    }
    
    // 更改adView的x值.当滑动距离超过view宽度时，则把x一直设置为0
    if (p.x < SCREEN_WIDTH * 0.4) {
        frame.origin.x = SCREEN_WIDTH * 0.4;
    } else {
        frame.origin.x = p.x;
    }
    self.rightView.frame = frame;
    
    if (ges.state == UIGestureRecognizerStateEnded || ges.state == UIGestureRecognizerStateCancelled) {
        // 判断当前广告视图在屏幕上显示是否超过一半
        if (CGRectContainsPoint(self.view.frame, self.rightView.center)) {
            // 如果超过,那么完全展示出来
            frame.origin.x = SCREEN_WIDTH * 0.4;
        }else{
            // 如果没有,隐藏
            frame.origin.x = SCREEN_WIDTH;
        }
        [UIView animateWithDuration:0.25 animations:^{
            self.rightView.frame = frame;
        }];
    }
}

// 初始化左侧视图
- (void)setupLeftView {
    self.leftBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.leftBGView.backgroundColor = [UIColor blackColor];
    self.leftBGView.alpha = 0;
    self.leftBGView.hidden = YES;
    [self.view addSubview:self.leftBGView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.6, SCREEN_HEIGHT)];
    // 设置背景颜色
    [self.view addSubview:view];
    view.backgroundColor = [UIColor clearColor];
    
    // 开启高斯模糊
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    [view addSubview:effectView];
    
    CGRect frame = view.frame;
    // 将x值改成负的屏幕宽度,原因是因为默认就在屏幕的左边
    frame.origin.x = -SCREEN_WIDTH * 0.6;
    // 设置给view
    view.frame = frame;
    self.leftView = view;
    
    // 添加轻扫手势  -- 滑回
    UISwipeGestureRecognizer *ges = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
    ges.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:ges];
}

// 初始化右侧视图
- (void)setupRightView {
    self.rightBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.rightBGView.backgroundColor = [UIColor blackColor];
    self.rightBGView.alpha = 0;
    self.rightBGView.hidden = YES;
    [self.view addSubview:self.rightBGView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.6, SCREEN_HEIGHT)];
    // 设置背景颜色
    [self.view addSubview:view];
    view.backgroundColor = [UIColor clearColor];
    
    // 开启高斯模糊
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    [view addSubview:effectView];
    
    CGRect frame = view.frame;
    // 将x值改成负的屏幕宽度,原因是因为默认就在屏幕的右边
    frame.origin.x = SCREEN_WIDTH;
    // 设置给view
    view.frame = frame;
    self.rightView = view;
    
    // 添加轻扫手势  -- 滑回
    UISwipeGestureRecognizer *ges = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
    ges.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:ges];
}

- (void)closeView {
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect leftframe = self.leftView.frame;
        CGRect rightframe = self.rightView.frame;
        // 如果view已经隐藏
        if (leftframe.origin.x == -SCREEN_WIDTH * 0.6) {
            if (rightframe.origin.x == SCREEN_WIDTH * 0.4) {
                rightframe.origin.x = SCREEN_WIDTH;
                self.rightView.frame = rightframe;
                return;
            } else {
                return;
            }
        } else {
            leftframe.origin.x = -SCREEN_WIDTH * 0.6;
            self.leftView.frame = leftframe;
        }
        
        // 如果view已经隐藏
        if (rightframe.origin.x == SCREEN_WIDTH) {
            return;
        } else {
            rightframe.origin.x = SCREEN_WIDTH;
            self.leftView.frame = rightframe;
        }
    }];
    self.leftBGView.hidden = YES;
    self.rightBGView.hidden = YES;
}

- (void)moreAction {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.leftView.frame;
        frame.origin.x = 0;
        self.leftView.frame = frame;
        self.leftBGView.hidden = NO;
        self.leftBGView.alpha = 0.3;
    }];
}

- (void)friendAction {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.rightView.frame;
        frame.origin.x = SCREEN_WIDTH * 0.4;
        self.rightView.frame = frame;
        self.rightBGView.hidden = NO;
        self.rightBGView.alpha = 0.3;
    }];
}


@end
