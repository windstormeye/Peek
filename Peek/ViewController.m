//
//  ViewController.m
//  Peek
//
//  Created by pjpjpj on 2017/6/1.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "ViewController.h"
#import "leftHomeView.h"
#import "PJFriendHomeView.h"
#import "PublishViewController.h"
#import "EditViewController.h"
#import "MessageViewController.h"
#import "PJLoginViewController.h"
#import "PJCardViewController.h"

@interface ViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate, leftHomeViewDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *edgePan;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *rightedgePan;
@property (weak, nonatomic) IBOutlet UIButton *camareBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIButton *redCircleBtn;
@property (weak, nonatomic) IBOutlet UIButton *blueCircleBtn;

@end

@implementation ViewController
{
    leftHomeView *_leftView;
    PJFriendHomeView *_kRightView;
    UIView *_kBackView;
    BOOL isRed;
    BOOL isLeft;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    [self initNavigationBar];
    
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

    // 背景图
    _kBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_kBackView];
    _kBackView.backgroundColor = RGB(0, 0, 0);
    _kBackView.hidden = true;
    _kBackView.alpha = 0;
    
    // 左 个人中心
    _leftView = [leftHomeView new];
    _leftView.viewDelega = self;
    [self.view addSubview:_leftView];
    [self.view bringSubviewToFront:_leftView];
    
    // 右 好友列表
    _kRightView = [PJFriendHomeView new];
//    _kRightView.viewDelega = self;
    [self.view addSubview:_kRightView];
    [self.view bringSubviewToFront:_kRightView];
    
    _edgePan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(showLeftAd:)];
    _edgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:_edgePan];
    
    _rightedgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(showRightAd:)];
    _rightedgePan.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:_rightedgePan];
    
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    _panGesture.enabled = NO;
    [self.view addGestureRecognizer:_panGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginReload:) name:@"loginNo"  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserDateReload:) name:@"changeAvarta"  object:nil];
    
    _closeBtn.hidden = true;
    isRed = true;
    isLeft = true;
}

// 用户资料的更新通知
- (void)changeUserDateReload:(NSNotification *)no {
    if (no.userInfo[@"isChange"]) {
        [_leftView setMessage:[[BmobUser currentUser] objectForKey:@"avatar_url"] withUserName:[[BmobUser currentUser] objectForKey:@"nickname"] andUserID:[[BmobUser currentUser] objectForKey:@"username"]];
    }
}

// 登录成功的通知
- (void)loginReload:(NSNotification *)no {
    if (no.userInfo[@"isLogin"]) {
        [_leftView setMessage:[[BmobUser currentUser] objectForKey:@"avatar_url"] withUserName:[[BmobUser currentUser] objectForKey:@"nickname"] andUserID:[[BmobUser currentUser] objectForKey:@"username"]];
    }
}

// 拍照按钮
- (IBAction)takePhoto:(id)sender {
    [self redAndBlueBtnShow];
    [PJTapic selection];
}

// 关闭红蓝
- (IBAction)closeBtnClick:(id)sender {
    [self redAndBlueBtnHidden];
}

- (void)redAndBlueBtnShow {
    [UIView animateWithDuration:0.1 animations:^{
        CGRect redframe = _redCircleBtn.frame;
        redframe.origin.y -= 60;
        redframe.origin.x = SCREEN_WIDTH / 2 - _redCircleBtn.frame.size.width * 1.8;
        _redCircleBtn.frame = redframe;
        
        CGRect blueframe = _blueCircleBtn.frame;
        blueframe.origin.y -= 60;
        blueframe.origin.x = SCREEN_WIDTH / 2 + _blueCircleBtn.frame.size.width * 0.8;
        _blueCircleBtn.frame = blueframe;
        
        _camareBtn.hidden = true;
        _closeBtn.hidden = false;
    }];
}

- (void)redAndBlueBtnHidden {
    [UIView animateWithDuration:0.1 animations:^{
        CGRect redframe = _redCircleBtn.frame;
        redframe.origin.y += 60;
        redframe.origin.x = (SCREEN_WIDTH - redframe.size.width) / 2;
        _redCircleBtn.frame = redframe;
        
        CGRect blueframe = _blueCircleBtn.frame;
        blueframe.origin.y += 60;
        blueframe.origin.x = (SCREEN_WIDTH - blueframe.size.width) / 2;
        _blueCircleBtn.frame = blueframe;
        
        _camareBtn.hidden = false;
        _closeBtn.hidden = true;
    }];
}

- (IBAction)redBtnClick:(id)sender {
    isRed = true;
    [self presentViewController:self.imagePicker animated:YES completion:^{
        [self redAndBlueBtnHidden];
        [PJHUD showInfoWithStatus:@"请使用竖屏姿势拍照"];
    }];
}

- (IBAction)blueBtnClick:(id)sender {
    isRed = false;
    [self presentViewController:self.imagePicker animated:YES completion:^{
        [self redAndBlueBtnHidden];
        [PJHUD showInfoWithStatus:@"请使用竖屏姿势拍照"];
    }];
}


#pragma mark - UIImagePickerController代理方法
// 完成拍照后的回调方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    // 选择的图片信息存储于info字典，在此可根据字典内容拿到编辑之后的图片
    UIImage *tempImage = info[@"UIImagePickerControllerOriginalImage"];
    PJCardViewController *vc = [PJCardViewController new];
    vc.isRed = isRed;
    vc.dealImageView = tempImage;
    [self.navigationController pushViewController:vc animated:true];
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

-(void)Actiondo{
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = _leftView.frame;
        frame.origin.x = -SCREEN_WIDTH * 0.6;
        _panGesture.enabled = NO;
        _leftView.frame = frame;
    }];
}

// 菜单栏滑动退出
- (void)panGesture:(UIPanGestureRecognizer *)ges {
    CGPoint p = [ges translationInView:self.view];
    if (isLeft) {
        CGRect frame = _leftView.frame;
        frame.origin.x = p.x;
        if (p.x > 0) {
            if (_leftView.frame.origin.x == 0) {
                frame.origin.x = 0;
                _leftView.frame = frame;
            } else if (_leftView.frame.origin.x < 0) {
                frame.origin.x = 0;
                _leftView.frame = frame;
            }
        } else {
            _leftView.frame = frame;
            if (ges.state == UIGestureRecognizerStateEnded) {
                frame.origin.x = -SCREEN_WIDTH * 0.6;
                _panGesture.enabled = NO;
                [UIView animateWithDuration:0.25 animations:^{
                    _leftView.frame = frame;
                }];
                [UIView animateWithDuration:0.25 animations:^{
                    _kBackView.alpha = 0;
                } completion:^(BOOL finished) {
                    _kBackView.hidden = true;
                }];
            }
        }
    } else {
        CGRect frame = _kRightView.frame;
        frame.origin.x = p.x + SCREEN_WIDTH * 0.4;
        if (p.x > 0) {
            _kRightView.frame = frame;
            if (ges.state == UIGestureRecognizerStateEnded) {
                frame.origin.x = SCREEN_WIDTH;
                _panGesture.enabled = NO;
                [UIView animateWithDuration:0.25 animations:^{
                    _kRightView.frame = frame;
                }];
                [UIView animateWithDuration:0.25 animations:^{
                    _kBackView.alpha = 0;
                } completion:^(BOOL finished) {
                    _kBackView.hidden = true;
                }];
            }
        } else {
            if (_kRightView.frame.origin.x == SCREEN_WIDTH * 0.4) {
                frame.origin.x = SCREEN_WIDTH * 0.4;
                _kRightView.frame = frame;
            } else if (_kRightView.frame.origin.x < SCREEN_WIDTH * 0.4) {
                frame.origin.x = SCREEN_WIDTH * 0.4;
                _kRightView.frame = frame;
            }
        }
    }
}

// 开启左侧滑功能
- (void)showLeftAd:(UIScreenEdgePanGestureRecognizer *)ges {
    CGPoint p = [ges locationInView:self.view];
//    NSLog(@"%@", NSStringFromCGPoint(p));
    
    CGRect frame = _leftView.frame;
    frame.origin.x = p.x - SCREEN_WIDTH * 0.6;
    // 如果已经划出view
    if (frame.origin.x == 0) {
        return;
    }
    if (p.x > SCREEN_WIDTH * 0.6) {
         frame.origin.x = 0;
    }
    
    _leftView.frame = frame;
    
    if (ges.state == UIGestureRecognizerStateEnded || ges.state == UIGestureRecognizerStateCancelled) {
        // 判断当前广告视图在屏幕上显示是否超过一半
        if (CGRectContainsPoint(self.view.frame, _leftView.center)) {
            // 如果超过,那么完全展示出来
            frame.origin.x = 0;
            _panGesture.enabled = YES;
            isLeft = true;
            _kBackView.hidden = false;
            [UIView animateWithDuration:0.25 animations:^{
                _kBackView.alpha = 0.5;
            }];
        }else{
            // 如果没有,隐藏
            frame.origin.x = -SCREEN_WIDTH * 0.6;
            [UIView animateWithDuration:0.25 animations:^{
                _kBackView.alpha = 0;
            } completion:^(BOOL finished) {
                _kBackView.hidden = true;
            }];
        }
        [UIView animateWithDuration:0.25 animations:^{
            _leftView.frame = frame;
            
        }];
    }
}

- (void)moreAction {
    _kBackView.hidden = false;
    [UIView animateWithDuration:0.25 animations:^{
        _panGesture.enabled = YES;
        CGRect frame = _leftView.frame;
        frame.origin.x = 0;
        _leftView.frame = frame;
        isLeft = true;
        _kBackView.alpha = 0.5;
        [PJTapic selection];
    }];
}

// 展示右侧图
- (void)showRightAd:(UIScreenEdgePanGestureRecognizer *)ges {
    CGPoint p = [ges locationInView:self.view];
    
    CGRect frame = _kRightView.frame;
    frame.origin.x = p.x;
    // 如果已经划出view
    if (_kRightView.frame.origin.x == SCREEN_WIDTH * 0.4) {
        _panGesture.enabled = YES;
        isLeft = false;
        _kBackView.hidden = false;
        [UIView animateWithDuration:0.25 animations:^{
            _kBackView.alpha = 0.5;
        }];
        return;
    }
    if (p.x < SCREEN_WIDTH * 0.4) {
        frame.origin.x = SCREEN_WIDTH * 0.4;
    }

    _kRightView.frame = frame;

    if (ges.state == UIGestureRecognizerStateEnded || ges.state == UIGestureRecognizerStateCancelled) {
        // 判断当前广告视图在屏幕上显示是否超过一半
        if (CGRectContainsPoint(self.view.frame, _kRightView.center)) {
            // 如果超过,那么完全展示出来
            frame.origin.x = SCREEN_WIDTH * 0.4;
            _panGesture.enabled = YES;
            isLeft = false;
            _kBackView.hidden = false;
            [UIView animateWithDuration:0.25 animations:^{
                _kBackView.alpha = 0.5;
            }];
        }else{
            // 如果没有,隐藏
            frame.origin.x = SCREEN_WIDTH;
            [UIView animateWithDuration:0.25 animations:^{
                _kBackView.alpha = 0;
            } completion:^(BOOL finished) {
                _kBackView.hidden = true;
            }];
        }
        [UIView animateWithDuration:0.25 animations:^{
            _kRightView.frame = frame;
        }];
    }
}


// 朋友按钮点击事件
- (void)friendAction {
    _kBackView.hidden = false;
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = _kRightView.frame;
        frame.origin.x = SCREEN_WIDTH * 0.4;
        _kRightView.frame = frame;
        _panGesture.enabled = true;
        isLeft = false;
        _kBackView.alpha = 0.5;
        [PJTapic selection];
    }];
}

- (void)myPublishAction {
    if ([BmobUser currentUser]) {
        PublishViewController *vc = [PublishViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        [self dismissLeftSlideView];
    } else {
        UIStoryboard *SB = [UIStoryboard storyboardWithName:@"PJLoginSB" bundle:nil];
        PJLoginViewController *vc = [SB instantiateViewControllerWithIdentifier:@"PJLoginViewController"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:^{
            
        }];
    }
}

- (void)editAction {
    if ([BmobUser currentUser]) {
        EditViewController *vc = [EditViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        [self dismissLeftSlideView];
    } else {
        UIStoryboard *SB = [UIStoryboard storyboardWithName:@"PJLoginSB" bundle:nil];
        PJLoginViewController *vc = [SB instantiateViewControllerWithIdentifier:@"PJLoginViewController"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:^{
            
        }];
    }
}

- (void)messageAction {
    if ([BmobUser currentUser]) {
        MessageViewController *vc = [MessageViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        [self dismissLeftSlideView];
    } else {
        UIStoryboard *SB = [UIStoryboard storyboardWithName:@"PJLoginSB" bundle:nil];
        PJLoginViewController *vc = [SB instantiateViewControllerWithIdentifier:@"PJLoginViewController"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:^{
            
        }];
    }
}

// 退出登录
- (void)logoutAction {
    if ([BmobUser currentUser]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注意" message:@"退出当前账号后本地缓存数据将销毁，注意保存重要资料，是否继续？" preferredStyle:UIAlertControllerStyleAlert];
        [PJTapic warning];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [BmobUser logout];
            [_leftView setMessage:@"" withUserName:@"还未登录噢~" andUserID:nil];
            [PJTapic succee];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [PJTapic error];
        [PJHUD showErrorWithStatus:@"未登录"];
    }
}

// 头像点击事件
- (void)tapAvatar {
    if ([BmobUser currentUser]) {
        EditViewController *vc = [EditViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        [self dismissLeftSlideView];
    } else {
        UIStoryboard *SB = [UIStoryboard storyboardWithName:@"PJLoginSB" bundle:nil];
        PJLoginViewController *vc = [SB instantiateViewControllerWithIdentifier:@"PJLoginViewController"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:^{
            
        }];
    }
    
}

- (void)dismissLeftSlideView {
    CGRect frame = _leftView.frame;
    frame.origin.x = -SCREEN_WIDTH * 0.6;
    _panGesture.enabled = NO;
    [UIView animateWithDuration:0.25 animations:^{
        _leftView.frame = frame;
    }];
}

@end
