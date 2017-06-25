//
//  PJLoginViewController.m
//  Peek
//
//  Created by pjpjpj on 2017/6/22.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "PJLoginViewController.h"
#import <JVFloatLabeledTextField/JVFloatLabeledTextField.h>
#import "FUIButton.h"
#import <SMS_SDK/SMSSDK.h>


@interface PJLoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (nonatomic, strong) UITextField *nameTxt;
@property (nonatomic, strong) UITextField *passwdTxt;
@property (nonatomic, strong) UITextField *securityTxt;
@property (nonatomic, strong) FUIButton *loginBtn;
@property (nonatomic, strong) FUIButton *signUpBtn;
@property (nonatomic, strong) FUIButton *sendBtn;
@property (nonatomic, strong) UIButton *signUpBtn_small;
@property (nonatomic, strong) UIButton *loginBtn_small;
@property (nonatomic, strong) UIView *pwLineView;
@property (nonatomic, strong) UIView *securityLineView;
@end

@implementation PJLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    [self initNavigationBar];
    self.leftBarButton.hidden = true;
    self.titleLabel.text = @"登录";
    
    UIButton *leftBarButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 33, 30, 30)];
    [leftBarButton setImage:[[UIImage imageNamed:@"close"] imageWithColor:[UIColor whiteColor]] forState:0];
    leftBarButton.tintColor = [UIColor whiteColor];
    [leftBarButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBarButton];

    UIVisualEffectView *effectView =[[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    effectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [_bgView addSubview:effectView];
    
    UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - SCREEN_WIDTH * 0.5)/2, 90, SCREEN_WIDTH * 0.5, SCREEN_WIDTH * 0.5)];
    logoImg.layer.cornerRadius = logoImg.frame.size.width * 0.2;
    logoImg.layer.masksToBounds = YES;
    logoImg.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:logoImg];
    
    // 用户名输入框
    JVFloatLabeledTextField *nameTxt = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - SCREEN_WIDTH * 0.6) / 2, CGRectGetMaxY(logoImg.frame) + 30, SCREEN_WIDTH * 0.6 - 70, 40)];
    [self.view addSubview:nameTxt];
    self.nameTxt = nameTxt;
    self.nameTxt.keyboardType = UIKeyboardTypeNumberPad;
    nameTxt.textColor = [UIColor whiteColor];
    nameTxt.font = [UIFont systemFontOfSize:16];
    nameTxt.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"手机号码", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    nameTxt.floatingLabelFont = [UIFont boldSystemFontOfSize:11];
    nameTxt.floatingLabelTextColor = [UIColor lightGrayColor];
    nameTxt.floatingLabelActiveTextColor = mainDeepSkyBlue;
    nameTxt.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTxt.keepBaseline = YES;
    
    // 用户名输入框下划线
    UIView *nameLineView = [[UIView alloc] initWithFrame:CGRectMake(nameTxt.frame.origin.x, CGRectGetMaxY(nameTxt.frame) + 1, SCREEN_WIDTH * 0.6, 1)];
    [self.view addSubview:nameLineView];
    nameLineView.backgroundColor = [UIColor lightGrayColor];
    
    // 验证码输入框
    JVFloatLabeledTextField *securityTxt = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(nameTxt.frame.origin.x, CGRectGetMaxY(nameTxt.frame) + 5, SCREEN_WIDTH * 0.6, 40)];
    [self.view addSubview:securityTxt];
    self.securityTxt = securityTxt;
    self.securityTxt.keyboardType = UIKeyboardTypeNumberPad;
    securityTxt.textColor = [UIColor whiteColor];
    securityTxt.floatingLabelActiveTextColor = mainDeepSkyBlue;
    securityTxt.font = [UIFont systemFontOfSize:16];
    securityTxt.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"验证码", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    securityTxt.floatingLabelFont = [UIFont boldSystemFontOfSize:11];
    securityTxt.floatingLabelTextColor = [UIColor lightGrayColor];
    securityTxt.clearButtonMode = UITextFieldViewModeWhileEditing;
    securityTxt.keepBaseline = YES;
    securityTxt.hidden = YES;
    
    // 验证码输入框下划线
    UIView *securityLineView = [[UIView alloc] initWithFrame:CGRectMake(nameTxt.frame.origin.x, CGRectGetMaxY(securityTxt.frame) + 1, SCREEN_WIDTH * 0.6, 1)];
    [self.view addSubview:securityLineView];
    self.securityLineView = securityLineView;
    securityLineView.backgroundColor = [UIColor lightGrayColor];
    self.securityLineView.hidden = YES;

    
    // 密码输入框
    JVFloatLabeledTextField *passwdTxt = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(nameTxt.frame.origin.x, CGRectGetMaxY(nameTxt.frame) + 5, SCREEN_WIDTH * 0.6, 40)];
    [self.view addSubview:passwdTxt];
    self.passwdTxt = passwdTxt;
    passwdTxt.textColor = [UIColor whiteColor];
    passwdTxt.floatingLabelActiveTextColor = mainDeepSkyBlue;
    passwdTxt.secureTextEntry = YES;
    passwdTxt.font = [UIFont systemFontOfSize:16];
    passwdTxt.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"密码", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    passwdTxt.floatingLabelFont = [UIFont boldSystemFontOfSize:11];
    passwdTxt.floatingLabelTextColor = [UIColor lightGrayColor];
    passwdTxt.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwdTxt.keepBaseline = YES;
    // 密码输入框下划线
    UIView *passwdLineView = [[UIView alloc] initWithFrame:CGRectMake(nameTxt.frame.origin.x, CGRectGetMaxY(passwdTxt.frame) + 1, SCREEN_WIDTH * 0.6, 1)];
    [self.view addSubview:passwdLineView];
    self.pwLineView = passwdLineView;
    passwdLineView.backgroundColor = [UIColor lightGrayColor];
    
    // 登录按钮
    FUIButton *loginBtn = [[FUIButton alloc] initWithFrame:CGRectMake(nameTxt.frame.origin.x, CGRectGetMaxY(passwdLineView.frame) + 50, SCREEN_WIDTH * 0.6, 40)];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    self.loginBtn = loginBtn;
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.buttonColor = mainDeepSkyBlue;
    loginBtn.shadowColor = [UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1];
    loginBtn.shadowHeight = 3.0f;
    loginBtn.cornerRadius = 5.0f;
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    FUIButton *signUpBtn = [[FUIButton alloc] initWithFrame:CGRectMake(loginBtn.frame.origin.x, loginBtn.frame.origin.y, loginBtn.frame.size.width, loginBtn.frame.size.height)];
    [signUpBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.view addSubview:signUpBtn];
    self.signUpBtn = signUpBtn;
    signUpBtn.hidden = YES;
    [signUpBtn addTarget:self action:@selector(signUpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    signUpBtn.buttonColor = [UIColor orangeColor];
    signUpBtn.shadowColor = [UIColor colorWithRed:139/255.0 green:90/255.0 blue:43/255.0 alpha:1];
    signUpBtn.shadowHeight = 3.0f;
    signUpBtn.cornerRadius = 5.0f;
    signUpBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [signUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // 发送验证码按钮
    FUIButton *sendBtn = [[FUIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.6, nameTxt.frame.origin.y, 70, 30)];
    [self.view addSubview:sendBtn];
    [sendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.sendBtn = sendBtn;
    sendBtn.hidden = YES;
    [sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:1<<6];
    sendBtn.buttonColor = [UIColor orangeColor];
    sendBtn.shadowColor = [UIColor colorWithRed:139/255.0 green:90/255.0 blue:43/255.0 alpha:1];
    sendBtn.shadowHeight = 3.0f;
    sendBtn.cornerRadius = 5.0f;
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // 前往注册按钮
    UIButton *signUpBtn_small = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(loginBtn.frame) - 115, CGRectGetMaxY(loginBtn.frame) + 10, 115, 20)];
    [self.view addSubview:signUpBtn_small];
    self.signUpBtn_small = signUpBtn_small;
    signUpBtn_small.titleLabel.textAlignment = NSTextAlignmentCenter;
    signUpBtn_small.titleLabel.font = [UIFont systemFontOfSize:12];
    [signUpBtn_small setTitle:@"没有账号？前往注册" forState:UIControlStateNormal];
    [signUpBtn_small addTarget:self action:@selector(signUpBtn_smallClick) forControlEvents:UIControlEventTouchUpInside];
    // 前往登录按钮
    UIButton *loginBtn_small = [[UIButton alloc] initWithFrame:CGRectMake(signUpBtn_small.frame.origin.x, signUpBtn_small.frame.origin.y, signUpBtn_small.frame.size.width, signUpBtn_small.frame.size.height)];
    [self.view addSubview:loginBtn_small];
    loginBtn_small.titleLabel.textAlignment = NSTextAlignmentCenter;
    loginBtn_small.titleLabel.font = [UIFont systemFontOfSize:12];
    [loginBtn_small setTintColor:[UIColor greenColor]];
    loginBtn_small.hidden = YES;
    self.loginBtn_small = loginBtn_small;
    [loginBtn_small setTitle:@"已有账号？前往登录" forState:UIControlStateNormal];
    [loginBtn_small addTarget:self action:@selector(loginBtn_smallClick) forControlEvents:UIControlEventTouchUpInside];
}

// 点击前往注册
- (void)signUpBtn_smallClick {
    self.loginBtn.hidden = YES;
    self.loginBtn_small.hidden = NO;
    self.signUpBtn_small.hidden = YES;
    self.signUpBtn.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.passwdTxt.frame;
        frame = CGRectMake(self.passwdTxt.frame.origin.x, self.passwdTxt.frame.origin.y + 45, self.passwdTxt.frame.size.width, self.passwdTxt.frame.size.height);
        self.passwdTxt.frame = frame;
        self.pwLineView.frame = CGRectMake(frame.origin.x, self.pwLineView.frame.origin.y + 45, frame.size.width, 1);
    } completion:^(BOOL finished) {
        self.securityTxt.hidden = NO;
        self.securityLineView.hidden = NO;
        self.securityTxt.alpha = 0;
        self.securityLineView.alpha = 0;
        self.sendBtn.hidden = NO;
        self.sendBtn.alpha = 0;
        [UIView animateWithDuration:0.25 animations:^{
            self.sendBtn.alpha = 1;
            self.securityTxt.alpha = 1;
            self.securityLineView.alpha = 1;
        }];
    }];
}

// 点击前往登录
- (void)loginBtn_smallClick {
    self.loginBtn.hidden = NO;
    self.loginBtn_small.hidden = YES;
    self.signUpBtn_small.hidden = NO;
    self.signUpBtn.hidden = YES;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.securityTxt.hidden = YES;
        self.securityLineView.hidden = YES;
        
        CGRect frame = self.passwdTxt.frame;
        frame = CGRectMake(self.passwdTxt.frame.origin.x, self.passwdTxt.frame.origin.y - 45, self.passwdTxt.frame.size.width, self.passwdTxt.frame.size.height);
        self.passwdTxt.frame = frame;
        self.pwLineView.frame = CGRectMake(frame.origin.x, self.pwLineView.frame.origin.y - 45, frame.size.width, 1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            self.sendBtn.alpha = 0;
        } completion:^(BOOL finished) {
            self.sendBtn.hidden = YES;
        }];
        
    }];
}

// 登录
- (void)loginBtnClick {
    [PJHUD showWithStatus:@""];
    [BmobUser loginInbackgroundWithAccount:self.nameTxt.text andPassword:self.passwdTxt.text block:^(BmobUser *user, NSError *error) {
        if (user) {
            [self dismissViewControllerAnimated:YES completion:^{
                [PJHUD dismiss];
                NSNotification *notification = [NSNotification notificationWithName:@"loginNo" object:nil userInfo:@{@"isLogin":@true}];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }];
        } else {
            [PJHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", error]];
        }
    }];}

// 注册
- (void)signUpBtnClick {
    [PJHUD showWithStatus:@""];
    [SMSSDK commitVerificationCode:self.securityTxt.text phoneNumber:self.nameTxt.text zone:@"86" result:^(NSError *error) {
        if (!error) {
            BmobUser *bUser = [BmobUser new];
            [bUser setUsername:self.nameTxt.text];
            [bUser setMobilePhoneNumber:self.nameTxt.text];
            [bUser setPassword:self.passwdTxt.text];
            [bUser signUpInBackgroundWithBlock:^ (BOOL isSuccessful, NSError *error){
                if (isSuccessful){
                    [PJHUD showSuccessWithStatus:@"注册成功"];
                    [self dismissViewControllerAnimated:YES completion:^{
                        NSNotification *notification = [NSNotification notificationWithName:@"loginNo" object:nil userInfo:@{@"isLogin":@true}];
                        [[NSNotificationCenter defaultCenter] postNotification:notification];                    }];
                } else {
                    [PJHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", error]];
                }
            }];
        }
        else {
            [PJHUD showErrorWithStatus:@"出错啦！"];
        }
    }];
}

// 返回事件
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 发送验证码
- (void)sendBtnClick {
    if ([self.nameTxt.text isEqualToString:@""]) {
        [PJHUD showErrorWithStatus:@"请填写手机号码"];
        return;
    }
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.nameTxt.text zone:@"86" result:^(NSError *error) {
        if (error) {
            [PJHUD showErrorWithStatus:@"出错啦！"];
            return ;
        }
    }];
    self.sendBtn.enabled = NO;
    __block NSInteger second = 60;
    //全局队列    默认优先级
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //定时器模式  事件源
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    //NSEC_PER_SEC是秒，＊1是每秒
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), NSEC_PER_SEC * 1, 0);
    //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
    dispatch_source_set_event_handler(timer, ^{
        //回调主线程，在主线程中操作UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second >= 0) {
                [self.sendBtn setTitle:[NSString stringWithFormat:@"%lds后重发",second] forState:UIControlStateNormal];
                second--;
            }
            else
            {
                //这句话必须写否则会出问题
                dispatch_source_cancel(timer);
                self.sendBtn.enabled = YES;
                [self.sendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                
            }
        });
    });
    //启动源
    dispatch_resume(timer);
}

@end
