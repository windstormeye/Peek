//
//  PJNetWorkManager.h
//  Peek
//
//  Created by pjpjpj on 2018/2/28.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PJNetWorkManager : NSObject

// Get
+ (void)getRequestWithHost:(NSString *)host
                      path:(NSString *)path
                    params:(NSDictionary *)params
                   success:(void(^)(NSDictionary *response)) succesBlock
                    failed:(void(^)(NSDictionary *response)) failBlock;

// Post
+ (void)postRequestWithHost:(NSString *)host
                       path:(NSString *)path
                     params:(NSDictionary *)params
                    success:(void(^)(NSDictionary *response)) succesBlock
                     failed:(void(^)(NSDictionary *response)) failBlock;

@end
