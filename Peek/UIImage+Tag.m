//
//  UIImage+Tag.m
//  Peek
//
//  Created by pjpjpj on 2018/7/19.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import "UIImage+Tag.h"
#import <objc/runtime.h>

static const void * Type = &Type;

@implementation UIImage (Tag)

@dynamic type;

- (void)setType:(NSString *)type {
    objc_setAssociatedObject(self, Type, type, OBJC_ASSOCIATION_COPY);

}

- (NSString *)type {
    return objc_getAssociatedObject(self, Type);
}

@end
