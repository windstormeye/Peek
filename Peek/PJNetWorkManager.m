//
//  PJNetWorkManager.m
//  Peek
//
//  Created by pjpjpj on 2018/2/28.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import "PJNetWorkManager.h"
#import <AFNetworking.h>
#import "PJNetWorkPath.h"


@implementation PJNetWorkManager

+ (void)getRequestWithHost:(NSString *)host path:(NSString *)path params:(NSDictionary *)params success:(void (^)(NSDictionary *response))succesBlock failed:(void (^)(NSDictionary *response))failBlock {
    NSURLSessionDataTask *dataTask = [[self class] createGetRequest:host path:path params:params success:succesBlock failed:failBlock];
}

+ (void)postRequestWithHost:(NSString *)host path:(NSString *)path params:(NSDictionary *)params success:(void (^)(NSDictionary *))succesBlock failed:(void (^)(NSDictionary *))failBlock {
    
}

+ (NSURLSessionDataTask *)createGetRequest:(NSString *)host path:(NSString *)path params:(NSDictionary *)params success:(void(^)(NSDictionary *response)) successBlock failed:(void(^)(NSDictionary* response)) failBlock {
    
}

@end
