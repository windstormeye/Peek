//
//  PJNoteViewController.h
//  Peek
//
//  Created by pjpjpj on 2018/7/24.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PJNoteViewController : UIViewController

@property (nonatomic, readwrite, strong) NSArray *dataArray;
@property (nonatomic, readwrite, copy) NSString *noteTitle;
@property (nonatomic, readwrite, strong) UIImage *noteImage;

@end
