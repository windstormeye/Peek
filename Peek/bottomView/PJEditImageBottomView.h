//
//  PJEditImageBottomView.h
//  editImageTest
//
//  Created by pjpjpj on 2017/11/21.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PJEditImageBottomViewDelegate <NSObject>

- (void)PJEditImageBottomViewColorViewShow;
- (void)PJEditImageBottomViewBackBtnClick;
- (void)PJEditImageBottomViewBlurBtnClick;

@end

@interface PJEditImageBottomView : UIView

@property (nonatomic, weak) id<PJEditImageBottomViewDelegate> viewDelegate;
@end
