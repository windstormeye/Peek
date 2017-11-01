//
//  PJDevice.m
//  Peek
//
//  Created by pjpjpj on 2017/10/31.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "PJDevice.h"

@implementation PJDevice

+ (NSInteger)currentDevice {
    NSString *devStr = [UIDevice currentDevice].systemVersion;
    NSInteger devInt = [devStr integerValue];
    return devInt;
}

@end
