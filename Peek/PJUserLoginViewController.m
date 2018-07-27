//
//  PJUserLoginViewController.m
//  Peek
//
//  Created by pjpjpj on 2018/7/27.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import "PJUserLoginViewController.h"
#import <SMS_SDK/SMSSDK.h>


@interface PJUserLoginViewController () <UITextFieldDelegate>

@property (nonatomic, readwrite, strong) UITextField *phoneTextField;
@property (nonatomic, readwrite, strong) UITextField *verityTextField;
@property (nonatomic, readwrite, strong) UIButton *verityButton;
@property (nonatomic, readwrite, strong) UIButton *loginButton;

@end

@implementation PJUserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.imageView];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [self.view addSubview:effectView];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, self.view.height * 0.1, self.view.width - 20, self.view.height * 0.7)];
    [self.view addSubview:backView];
    [PJTool addShadowToView:backView withOpacity:0.3 shadowRadius:5 andCornerRadius:8];
    backView.backgroundColor = [UIColor whiteColor];
    
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, backView.bottom + 10, self.view.width - 20, self.view.height * 0.1 - 10)];
    [self.view addSubview:cancleBtn];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancleBtn.backgroundColor = [UIColor whiteColor];
    cancleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [PJTool addShadowToView:cancleBtn withOpacity:0.2 shadowRadius:5 andCornerRadius:8];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 20)];
    [backView addSubview:tipsLabel];
    tipsLabel.text = @"手 机 号 直 接 登 录";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = [UIColor blackColor];
    tipsLabel.font = [UIFont boldSystemFontOfSize:14];
    
    self.phoneTextField = ({
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(0, tipsLabel.bottom + 20, backView.width * 0.8, 45)];
        [backView addSubview:textfield];
        textfield.centerX = backView.centerX - 10;
        textfield.layer.cornerRadius = 8;
        textfield.layer.masksToBounds = YES;
        textfield.layer.borderColor = RGB(230, 230, 230).CGColor;
        textfield.layer.borderWidth = 1;
        textfield.placeholder = @"手机号码";
        textfield.font = [UIFont systemFontOfSize:15];
        textfield.backgroundColor = RGB(240, 240, 240);
        textfield.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
        textfield.leftViewMode = UITextFieldViewModeAlways;
        textfield.keyboardType = UIKeyboardTypeNumberPad;
        textfield.tintColor = [UIColor blackColor];
        textfield.tag = 1000;
        textfield.delegate = self;
        textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        textfield;
    });
    
    self.verityTextField = ({
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(self.phoneTextField.left, self.phoneTextField.bottom + 30, backView.width * 0.5, 45)];
        [backView addSubview:textfield];
        textfield.placeholder = @"验证码";
        textfield.layer.cornerRadius = 8;
        textfield.layer.masksToBounds = YES;
        textfield.layer.borderColor = RGB(230, 230, 230).CGColor;
        textfield.layer.borderWidth = 1;
        textfield.font = [UIFont systemFontOfSize:15];
        textfield.backgroundColor = RGB(240, 240, 240);
        textfield.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
        textfield.leftViewMode = UITextFieldViewModeAlways;
        textfield.keyboardType = UIKeyboardTypeNumberPad;
        textfield.tintColor = [UIColor blackColor];
        textfield.tag = 2000;
        textfield.delegate = self;
        textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        textfield;
    });
    
    self.verityButton = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.verityTextField.right + 10, self.verityTextField.top, self.phoneTextField.width - self.verityTextField.width - 10, self.verityTextField.height)];
        [backView addSubview:button];
        [button setTitle:@"发送验证码" forState:UIControlStateNormal];
        button.backgroundColor = RGB(200, 200, 200);
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.selected = NO;
        [button addTarget:self
                   action:@selector(verityBtnClick)
         forControlEvents:UIControlEventTouchUpInside];
        [PJTool addShadowToView:button withOpacity:0.2 shadowRadius:5 andCornerRadius:8];
        
        button;
    });
    
    self.loginButton = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.verityTextField.left, self.verityTextField.bottom + 30, self.phoneTextField.width, self.phoneTextField.height)];
        [backView addSubview:button];
        [button setTitle:@"登 录" forState:UIControlStateNormal];
        button.backgroundColor = RGB(200, 200, 200);
        button.userInteractionEnabled = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(loginButtonClick)
         forControlEvents:UIControlEventTouchUpInside];
        [PJTool addShadowToView:button withOpacity:0.2 shadowRadius:5 andCornerRadius:8];
        
        button;
    });
    
    UILabel *attentionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.loginButton.bottom + 20, 0, 0)];
    attentionLabel.text = @"点击登录即表示您同意";
    attentionLabel.textColor = [UIColor blackColor];
    attentionLabel.font = [UIFont systemFontOfSize:11];
    attentionLabel.textColor = RGB(150, 150, 150);
    [backView addSubview:attentionLabel];
    [attentionLabel sizeToFit];
    attentionLabel.centerX = backView.centerX - 40;
    
    UIButton *protocolButton = [[UIButton alloc] initWithFrame:CGRectMake(0, attentionLabel.y, 0, 0)];
    [backView addSubview:protocolButton];
    [protocolButton setTitle:@"用户协议" forState:UIControlStateNormal];
    [protocolButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    protocolButton.titleLabel.font = [UIFont systemFontOfSize:11];
    [protocolButton sizeToFit];
    protocolButton.left = attentionLabel.right + 2;
    protocolButton.centerY = attentionLabel.centerY;
    [protocolButton addTarget:self action:@selector(protocolButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(backView.width * 0.15, attentionLabel.bottom + 30, backView.width * 0.7, 1)];
    lineView.backgroundColor = RGB(230, 230, 230);
    [backView addSubview:lineView];
    
    UILabel *otherLogin = [[UILabel alloc] initWithFrame:CGRectMake(0, lineView.bottom + 30, 0, 0)];
    [backView addSubview:otherLogin];
    otherLogin.font = [UIFont boldSystemFontOfSize:15];
    otherLogin.text = @"其 它 方 式 登 录";
    otherLogin.textColor = [UIColor blackColor];
    [otherLogin sizeToFit];
    otherLogin.centerX = backView.centerX;
    
    UIButton *wechatButton = [[UIButton alloc] initWithFrame:CGRectMake(self.phoneTextField.left, otherLogin.bottom + 20, self.phoneTextField.width / 2 - 10, self.loginButton.height + 10)];
    [backView addSubview:wechatButton];
    [wechatButton setImage:[UIImage imageNamed:@"user_wechat"] forState:UIControlStateNormal];
    wechatButton.backgroundColor = RGB(60, 179, 113);
    [PJTool addShadowToView:wechatButton withOpacity:0.2 shadowRadius:5 andCornerRadius:8];
    
    UIButton *xinlangButton = [[UIButton alloc] initWithFrame:CGRectMake(wechatButton.right + 20, otherLogin.bottom + 20, self.phoneTextField.width / 2 - 10, self.loginButton.height + 10)];
    [backView addSubview:xinlangButton];
    [xinlangButton setImage:[UIImage imageNamed:@"user_xinlang"] forState:UIControlStateNormal];
    xinlangButton.backgroundColor = RGB(255, 165, 0);
    [PJTool addShadowToView:xinlangButton withOpacity:0.2 shadowRadius:5 andCornerRadius:8];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:self.phoneTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:self.verityTextField];
}

- (void)cancleBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)protocolButtonClick {
    
}

- (void)verityBtnClick {
    if (![self dealPhoneNumber]) {
        return;
    }
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
                            phoneNumber:self.phoneTextField.text
                                   zone:@"86"
                                 result:^(NSError *error) {
                                     if (error) {
                                        NSLog(@"Mob error = %@", error);
                                     }
                                 }];
    self.verityButton.enabled = NO;
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
                [self.verityButton setTitle:[NSString stringWithFormat:@"%lds后重发",second] forState:UIControlStateNormal];
                second--;
            }
            else
            {
                //这句话必须写否则会出问题
                dispatch_source_cancel(timer);
                self.verityButton.enabled = YES;
                [self.verityButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            }
        });
    });
    //启动源
    dispatch_resume(timer);
}

- (BOOL)dealPhoneNumber {
    NSString *phoneString = self.phoneTextField.text;
    if (phoneString.length != 11 || [phoneString isEqualToString:@""]) {
        [[PJHUD shareInstance] warningString:@"请输入正确手机号码" coverHidden:NO];
        return NO;
    }
    return YES;
}

- (BOOL)dealVerityCode {
    NSString *verityString = self.verityTextField.text;
    if ([verityString isEqualToString:@""]) {
        [[PJHUD shareInstance] warningString:@"请输入正确验证码" coverHidden:NO];
        return NO;
    }
    return YES;
}

# pragma mark: delegate

- (void)loginButtonClick {
    if (![self dealPhoneNumber] || ![self dealVerityCode]) {
        return ;
    }
    
    NSString *phoneString = self.phoneTextField.text;
    
    [SMSSDK commitVerificationCode:self.verityTextField.text
                       phoneNumber:self.phoneTextField.text
                              zone:@"86"
                            result:^(NSError *error) {
                                if (!error) {
                                    AVUser *user = [AVUser user];
                                    user.username = phoneString;
                                    user.password = phoneString;
                                    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        if (succeeded) {
                                            [self cancleBtnClick];
                                        } else {
                                            [[PJHUD shareInstance] warningString:error.userInfo[@"NSLocalizedFailureReason"] coverHidden:NO];
                                        }
                                    }];
                                }
                            }];
}

- (void)textFieldChange:(NSNotification *)obj {
    UITextField * textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    if (textField.tag == 1000) {
        if (toBeString.length >= 11) {
            self.verityButton.backgroundColor = RGB(50, 50, 50);
        } else {
            self.verityButton.backgroundColor = RGB(200, 200, 200);
        }
        self.verityButton.selected = !self.verityButton.selected;
    }
    
    if (textField.tag == 2000) {
        if (toBeString.length >= 4 && self.verityButton.selected == YES) {
            self.loginButton.backgroundColor = RGB(50, 50, 50);
        } else {
            self.loginButton.backgroundColor = RGB(200, 200, 200);
        }
    }
}

@end
