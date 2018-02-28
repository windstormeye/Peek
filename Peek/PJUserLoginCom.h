//
//  PJUserLoginCom.h
//  Peek
//
//  Created by pjpjpj on 2018/2/28.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PJUserLoginCom : NSObject

- (void)sendUserParams:(NSDictionary *)params
               success:(void (^)(NSMutableDictionary *parmDict)) success
                  fail:(void (^)(NSDictionary *error)) fail;

@end
