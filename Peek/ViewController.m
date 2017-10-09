//
//  ViewController.m
//  Peek
//
//  Created by pjpjpj on 2017/6/1.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "ViewController.h"
#import "leftHomeView.h"
#import "PublishViewController.h"
#import "EditViewController.h"
#import "MessageViewController.h"
#import "PJLoginViewController.h"
#import "PJOpenCV.h"

#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>

@interface ViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate, leftHomeViewDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *edgePan;
@property (weak, nonatomic) IBOutlet UIButton *camareBtn;

@property (nonatomic,strong) UIImagePickerController *imagePicker;
@end

@implementation ViewController
{
    leftHomeView *_leftView;
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

    _leftView = [leftHomeView new];
    _leftView.viewDelega = self;
    [self.view addSubview:_leftView];
    [self.view bringSubviewToFront:_leftView];
    
    _edgePan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(showLeftAd:)];
    _edgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:_edgePan];
    
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    _panGesture.enabled = NO;
    [self.view addGestureRecognizer:_panGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginReload:) name:@"loginNo"  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserDateReload:) name:@"changeAvarta"  object:nil];
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

- (IBAction)takePhoto:(id)sender {
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerController代理方法
// 完成拍照后的回调方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    // 选择的图片信息存储于info字典中
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.9)];
    [self.view addSubview:img];
    img.image = info[@"UIImagePickerControllerOriginalImage"];
    
//    img.image = [PJOpenCV imageToDiscernBlue:img.image];
    img.image = [PJOpenCV imageToDiscernRed:img.image];
    
    // 测试代码
    
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [img removeFromSuperview];
    });
    
//    NSLog(@"%@", info);
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

// 左侧菜单栏滑动退出
- (void)panGesture:(UIPanGestureRecognizer *)ges {
    CGPoint p = [ges translationInView:self.view];
//    NSLog(@"%@", NSStringFromCGPoint(p));
    
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
    // 更改adView的x值.当滑动距离超过view宽度时，则把x一直设置为0
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
        }else{
            // 如果没有,隐藏
            frame.origin.x = -SCREEN_WIDTH * 0.6;
        }
        [UIView animateWithDuration:0.25 animations:^{
            _leftView.frame = frame;
            
        }];
    }
}

- (void)moreAction {
    [UIView animateWithDuration:0.25 animations:^{
        _panGesture.enabled = YES;
        CGRect frame = _leftView.frame;
        frame.origin.x = 0;
        _leftView.frame = frame;
    }];
}

- (void)friendAction {
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self shareWebPageToPlatformType:platformType];
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
        [self.navigationController presentViewController:vc animated:YES completion:^{
            
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
        [self.navigationController presentViewController:vc animated:YES completion:^{
            
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
        [self.navigationController presentViewController:vc animated:YES completion:^{
            
        }];
    }
}

// 退出登录
- (void)logoutAction {
    [BmobUser logout];
    UIStoryboard *SB = [UIStoryboard storyboardWithName:@"PJLoginSB" bundle:nil];
    PJLoginViewController *vc = [SB instantiateViewControllerWithIdentifier:@"PJLoginViewController"];
    [self.navigationController presentViewController:vc animated:YES completion:^{
        [_leftView setMessage:nil withUserName:@"还未登录噢~" andUserID:nil];
    }];
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
        [self.navigationController presentViewController:vc animated:YES completion:^{
            
        }];
    }
    
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"Peek" descr:@"带给你全新的知识学习方式" thumImage:[UIImage imageNamed:@"logo"]];
    //设置网页地址
    shareObject.webpageUrl = @"http://www.pjhubs.com";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
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
