//
//  LeftSliderView.h
//  Peek
//
//  Created by pjpjpj on 2017/6/5.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftSliderViewDelegate <NSObject>

- (void)myPublishAction;
- (void)editAction;
- (void)messageAction;
- (void)logoutAction;
- (void)tapAvatar;

@end

@interface LeftSliderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *useridLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heighConstraint;

@property (nonatomic, weak) id<LeftSliderViewDelegate> viewDelegate;

@end
