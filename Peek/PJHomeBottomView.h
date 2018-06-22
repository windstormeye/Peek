//
//  PJHomeBottomView.h
//  Peek
//
//  Created by pjpjpj on 2018/6/20.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PJHomeBottomViewDelegate <NSObject>

- (void)homeBottomViewButtonClick;

@end

@interface PJHomeBottomView : UIView

@property (nonatomic, readwrite, assign) BOOL isShowHomeButton;
@property (nonatomic, readwrite, weak) id<PJHomeBottomViewDelegate> viewDelegate;

@end
