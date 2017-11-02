//
//  PJModifyNameViewController.m
//  Peek
//
//  Created by pjpjpj on 2017/8/18.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "PJModifyViewController.h"

@interface PJModifyViewController () <UITextFieldDelegate>

@end

@implementation PJModifyViewController {
    // 输入UITextField
    UITextField *_kFocusTxt;
    UILabel *_kTipsLabel;
    UITextField *_kOneTxt;
    UITextField *_kSecondTxt;
    UIView *_kOneTxtView;
    UIView *_kTwoTxtView;
}

- (void)initWithTitleLabelName:(NSString *)name {
    [self initViewWithName:name];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initViewWithName:(NSString *)nameStr {
    [self initNavigationBar];
    self.titleLabel.text = nameStr;
    self.titleLabel.textColor = [UIColor blackColor];
    [self.leftBarButton setImage:[[UIImage imageNamed:@"back"] imageWithColor:[UIColor blackColor]] forState:0];
    [self.rightBarButton setImage:[[UIImage imageNamed:@"person_yes"] imageWithColor:[UIColor blackColor]] forState:0];
    [self.rightBarButton addTarget:self action:@selector(finishUpdate) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgImgView.image = [UIImage imageNamed:@"背景"];
    [self.view addSubview:bgImgView];
    [self.view sendSubviewToBack:bgImgView];
    // 开启高斯模糊
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, bgImgView.frame.size.width, bgImgView.frame.size.height);
    [bgImgView addSubview:effectView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,64 + 30, SCREEN_WIDTH, 60)];
    [self.view addSubview:bgView];
    bgView.backgroundColor = [UIColor whiteColor];
    
    _kFocusTxt = [[UITextField alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - SCREEN_WIDTH * 0.9)/2, (bgView.frame.size.height - 25)/2, SCREEN_WIDTH * 0.9, 25)];
    [bgView addSubview:_kFocusTxt];
    _kFocusTxt.clearButtonMode = UITextFieldViewModeWhileEditing;
    _kFocusTxt.font = [UIFont systemFontOfSize:18];
    _kFocusTxt.textColor = [UIColor blackColor];
    // 选中其为中文九宫格输入法
    _kFocusTxt.keyboardType = UIKeyboardTypeNamePhonePad;
    _kFocusTxt.returnKeyType = UIReturnKeyDone;
    _kFocusTxt.textAlignment = NSTextAlignmentCenter;
    // 使其成为第一响应者
    [_kFocusTxt becomeFirstResponder];
    
    _kTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - SCREEN_WIDTH * 0.8)/2, bgView.frame.origin.y + bgView.frame.size.height + 10, SCREEN_WIDTH * 0.8, 15)];
    [self.view addSubview:_kTipsLabel];
    _kTipsLabel.textColor = RGB(70, 70, 70);
    _kTipsLabel.font = [UIFont systemFontOfSize:12];
    _kTipsLabel.hidden = true;
    _kTipsLabel.textAlignment = NSTextAlignmentCenter;
    
    _kOneTxtView = [[UIView alloc] initWithFrame:CGRectMake(0, bgView.frame.origin.y + bgView.frame.size.height + 20, SCREEN_WIDTH, bgView.frame.size.height)];
    [self.view addSubview:_kOneTxtView];
    _kOneTxtView.backgroundColor = [UIColor whiteColor];
    _kOneTxtView.hidden = true;

    
    _kOneTxt = [[UITextField alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - SCREEN_WIDTH * 0.9)/2, (_kOneTxtView.frame.size.height - 25)/2, SCREEN_WIDTH * 0.9, 25)];
    [_kOneTxtView addSubview:_kOneTxt];
    _kOneTxt.placeholder = @"输入新密码";
    _kOneTxt.font = _kFocusTxt.font;
    _kOneTxt.textAlignment = NSTextAlignmentLeft;
    _kOneTxt.secureTextEntry = true;
    _kOneTxt.returnKeyType = UIReturnKeyNext;
    _kOneTxt.delegate = self;
    
    _kTwoTxtView = [[UIView alloc] initWithFrame:CGRectMake(0, _kOneTxtView.frame.origin.y + _kOneTxtView.frame.size.height + 1, SCREEN_WIDTH, _kOneTxtView.frame.size.height)];
    [self.view addSubview:_kTwoTxtView];
    _kTwoTxtView.backgroundColor = [UIColor whiteColor];
    _kTwoTxtView.hidden = true;
    
    _kSecondTxt = [[UITextField alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - SCREEN_WIDTH * 0.9)/2, (_kTwoTxtView.frame.size.height - 25)/2, SCREEN_WIDTH * 0.9, 25)];
    [_kTwoTxtView addSubview:_kSecondTxt];
    _kSecondTxt.placeholder = @"再输入一次";
    _kSecondTxt.font = _kOneTxt.font;
    _kSecondTxt.textAlignment = NSTextAlignmentLeft;
    _kSecondTxt.secureTextEntry = true;
    _kSecondTxt.returnKeyType = UIReturnKeyDone;
    _kSecondTxt.delegate = self;
}

- (void)setType:(ModifyType)type {
    _type = type;
    switch (type) {
        case 0:
            [self nickNameInitView]; break;
        case 1:
            [self mailInitView]; break;
        case 2:
            [self phoneInitView]; break;
        case 3:
            [self passwdInitView]; break;
    }
}

- (void)nickNameInitView {
    NSString *nickNameStr = [[BmobUser currentUser] objectForKey:@"nickname"];
    if (nickNameStr) {
        _kFocusTxt.text = [[BmobUser currentUser] objectForKey:@"nickname"];
    } else {
        _kFocusTxt.placeholder = @"输入昵称";
        _kFocusTxt.textColor = RGB(70, 70, 70);
    }
    
}

- (void)mailInitView {
    NSString *nickNameStr = [[BmobUser currentUser] objectForKey:@"email"];
    _kFocusTxt.keyboardType = UIKeyboardTypeASCIICapable;
    if (nickNameStr) {
        _kFocusTxt.text = [[BmobUser currentUser] objectForKey:@"email"];
    } else {
        _kFocusTxt.placeholder = @"输入邮箱";
        _kFocusTxt.textColor = RGB(70, 70, 70);
    }
    _kTipsLabel.hidden = false;
    _kTipsLabel.text = @"仅用于登录和密码找回，不会被搜索或公开显示";
}

- (void)phoneInitView {
    _kFocusTxt.delegate = self;
    _kFocusTxt.keyboardType = UIKeyboardTypePhonePad;
    NSString *nickNameStr = [[BmobUser currentUser] objectForKey:@"username"];
    nickNameStr = [self divisionPhoneString:nickNameStr];
    if (nickNameStr) {
        _kFocusTxt.text = nickNameStr;
    } else {
        _kFocusTxt.placeholder = @"输入电话号码";
        _kFocusTxt.textColor = RGB(70, 70, 70);
    }
    _kTipsLabel.hidden = false;
    _kTipsLabel.text = @"仅用于登录和密码找回，不会被搜索或公开显示";
}

- (void)passwdInitView {
    _kFocusTxt.placeholder = @"输入当前密码";
    _kFocusTxt.secureTextEntry = true;
    _kFocusTxt.returnKeyType = UIReturnKeyNext;
    _kFocusTxt.textAlignment = NSTextAlignmentLeft;
    _kOneTxtView.hidden = false;
    _kTwoTxtView.hidden = false;
}

- (NSString *)divisionPhoneString:(NSString *)phoneString {
    NSString *headString = [NSString stringWithFormat:@"%@ ", [phoneString substringToIndex:3]];
    NSString *middleString = [NSString stringWithFormat:@"%@ ", [phoneString substringWithRange:NSMakeRange(3, 4)]];
    NSString *lastString = [NSString stringWithFormat:@"%@", [phoneString substringWithRange:NSMakeRange(7, 4)]];
    NSString *finalString = [NSString stringWithFormat:@"%@%@%@", headString, middleString, lastString];
    
    return finalString;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length && _kFocusTxt.text.length < 14) {
        return true;
    }
    if (!range.length && _kFocusTxt.text.length < 13) {
        if (range.location == 3 || range.location == 8) {
            NSString *tempStr = _kFocusTxt.text;
            _kFocusTxt.text = [NSString stringWithFormat:@"%@ ", tempStr];
        }
        return true;
    }
    return false;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (_type == passwd) {
        if ([_kFocusTxt isFirstResponder]) {
            [_kOneTxt becomeFirstResponder];
            return true;
        }
        if ([_kOneTxt isFirstResponder]) {
            [_kSecondTxt becomeFirstResponder];
            return true;
        }
        if ([_kSecondTxt isFirstResponder]) {
            [self finishUpdate];
            return true;
        }
    } else {
        [self finishUpdate];
    }
    return true;
}

- (void)finishUpdate {
    switch (_type) {
        case 0:
            [self updateNickName]; break;
        case 1:
            [self updateEmail]; break;
        case 2:
            [self updatePhone]; break;
        case 3:
            [self updatePasswd]; break;
    }
}

- (void)updateNickName {
    [PJHUD showWithStatus:@""];
    
    // 修改后的姓名与原姓名一致，假成功
    NSString *namaString = [[BmobUser currentUser] objectForKey:@"nickname"];
    if ([_kFocusTxt.text isEqualToString:namaString]) {
        [PJHUD showSuccessWithStatus:@"修改成功"];
        [self.navigationController popViewControllerAnimated:true];
        return;
    }
    
    BmobUser *bUser = [BmobUser currentUser];
    [bUser setObject:_kFocusTxt.text forKey:@"nickname"];
    [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [PJHUD showSuccessWithStatus:@"修改成功"];
            [self modifyNo];
        }
    }];
}

- (void)updateEmail {
    [PJHUD showWithStatus:@""];
    
    // 修改后的email与原email一致，假成功
    NSString *emailString = [[BmobUser currentUser] objectForKey:@"email"];
    if ([_kFocusTxt.text isEqualToString:emailString]) {
        [PJHUD showSuccessWithStatus:@"修改成功"];
        [self.navigationController popViewControllerAnimated:true];
        return;
    }
    
    BmobUser *bUser = [BmobUser currentUser];
    [bUser setObject:_kFocusTxt.text forKey:@"email"];
    [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [PJHUD showSuccessWithStatus:@"修改成功"];
            [self modifyNo];
        }
    }];}

- (void)updatePhone {
    [PJHUD showWithStatus:@""];
    
    // 修改后的电话与原电话一致，假成功
    NSString *phoneString = [[BmobUser currentUser] objectForKey:@"username"];
    if ([_kFocusTxt.text isEqualToString:phoneString]) {
        [PJHUD showSuccessWithStatus:@"修改成功"];
        [self.navigationController popViewControllerAnimated:true];
        return;
    }
    
    BmobUser *bUser = [BmobUser currentUser];
    [bUser setObject:_kFocusTxt.text forKey:@"username"];
    [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [PJHUD showSuccessWithStatus:@"修改成功"];
            [self modifyNo];
        }
    }];}

- (void)updatePasswd {
    if ([_kFocusTxt.text isEqualToString:@""]) {
        [PJHUD showErrorWithStatus:@"请输入当前密码"];
        return;
    }
    if ([_kOneTxt.text isEqualToString:@""] || [_kSecondTxt.text isEqualToString:@""]) {
        [PJHUD showErrorWithStatus:@"两次密码不能为空"];
        return;
    }
    if (![_kOneTxt.text isEqualToString:_kSecondTxt.text]) {
        [PJHUD showErrorWithStatus:@"两次新密码输入有误"];
        return;
    }
    
    // 修改后的密码与原密码一致，假成功
    if ([_kFocusTxt.text isEqualToString:_kSecondTxt.text]) {
        [PJHUD showSuccessWithStatus:@"修改成功"];
        [self.navigationController popViewControllerAnimated:true];
        return;
    }
    
    BmobUser *user = [BmobUser currentUser];
    [user updateCurrentUserPasswordWithOldPassword:_kFocusTxt.text newPassword:_kSecondTxt.text block:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //用新密码登录
            [BmobUser loginInbackgroundWithAccount:[[BmobUser currentUser] objectForKey:@"username"] andPassword:_kSecondTxt.text block:^(BmobUser *user, NSError *error) {
                if (error) {
                    NSLog(@"login error:%@",error);
                } else {
                    [PJHUD showSuccessWithStatus:@"修改成功"];
                    [self.navigationController popViewControllerAnimated:true];
                }
            }];
        } else {
            NSLog(@"change password error:%@",error);
        }
    }];
}

- (void)modifyNo {
    NSNotification *notification = [NSNotification notificationWithName:@"modifyNo" object:nil userInfo:@{@"isModify":@true}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.navigationController popViewControllerAnimated:true];
}

@end
