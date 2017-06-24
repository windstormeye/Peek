//
//  PJKeyboard.m
//  Peek
//
//  Created by pjpjpj on 2017/6/24.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "PJKeyboard.h"

@implementation PJKeyboard
+ (void)registerKeyBoardShow:(id)target{
    [[NSNotificationCenter defaultCenter] addObserver:target selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
}
+ (void)registerKeyBoardHide:(id)target{
    [[NSNotificationCenter defaultCenter] addObserver:target selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}
+ (CGRect)returnKeyBoardWindow:(NSNotification *)notification{
    CGRect keyboardEndFrameWindow;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrameWindow];
    return keyboardEndFrameWindow;
}
+ (double)returnKeyBoardDuration:(NSNotification *)notification{
    double keyboardTransitionDuration;
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&keyboardTransitionDuration];
    return keyboardTransitionDuration;
}
+ (UIViewAnimationCurve)returnKeyBoardAnimationCurve:(NSNotification *)notification{
    UIViewAnimationCurve keyboardTransitionAnimationCurve;
    [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&keyboardTransitionAnimationCurve];
    return keyboardTransitionAnimationCurve;
}
@end
