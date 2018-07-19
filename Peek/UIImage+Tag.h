//
//  UIImage+Tag.h
//  Peek
//
//  Created by pjpjpj on 2018/7/19.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tag)

/*
 * 0 ==> red
 * 1 ==> blue
 * 2 ==> allPage
 */
@property (nonatomic, readwrite, copy) NSString *type;

@end
