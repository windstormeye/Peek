//
//  PJEditTableView.h
//  Peek
//
//  Created by pjpjpj on 2017/7/4.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PJEditHeaderView.h"

@protocol PJEditTableViewDelegate <NSObject>

- (void)PJEditTableViewChangeAvater:(UIImageView *)img;
- (void)PJEditTableViewDidSelected:(NSInteger)index;
- (void)PJEditHeaderViewToLargerImage:(UIImageView *)img;


@end

@interface PJEditTableView : UITableView <UITableViewDataSource, UITableViewDelegate, PJEditHeaderViewDelegete>

@property (weak, nonatomic) id<PJEditTableViewDelegate> tableDelegate;
@end
