//
//  PJCardBottomView.h
//  Peek
//
//  Created by pjpjpj on 2017/10/24.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PJCardBottomViewDelegate <NSObject>

- (void)PJCardBottomViewYesBtnClick;
- (void)PJCardBottomViewNoBtnClick;

@end

@interface PJCardBottomView : UIView


@property (nonatomic, weak) id<PJCardBottomViewDelegate> viewDelegate;
@end
