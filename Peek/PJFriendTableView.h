//
//  PJFriendTableView.h
//  Peek
//
//  Created by pjpjpj on 2017/11/4.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PJFriendTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSDictionary *tableViewDict;

@end
