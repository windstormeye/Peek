//
//  PJEditImageBottomColorView.h
//  editImageTest
//
//  Created by pjpjpj on 2017/11/21.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PJEditImageBottomColorViewDelegate <NSObject>

- (void)PJEditImageBottomColorViewSelectedColor:(UIColor*)color;

@end

@interface PJEditImageBottomColorView : UIView

@property (nonatomic, weak) id<PJEditImageBottomColorViewDelegate> viewDelegate;
@end
