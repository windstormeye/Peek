//
//  PJEditHeaderView.h
//  Peek
//
//  Created by pjpjpj on 2017/7/4.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PJEditHeaderViewDelegete <NSObject>

- (void)PJEditHeaderViewChangeAvatar:(UIImageView *)img;

@end

@interface PJEditHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UIButton *EditBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) id<PJEditHeaderViewDelegete> viewDeleget;
@end
