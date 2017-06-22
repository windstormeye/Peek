//
//  BmobPay.h
//  BmobSDK
//
//  Created by 陈超邦 on 2016/12/29.
//  Copyright © 2016年 Bmob. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 错误码含义
 
 |错误码 |含义        |
 |------|:---------:|
 | 4000 | 支付类型错误 |
 | 4001 | 返回可用数据为空 |
 | 4002 | 查询不到订单号 |
 | 4004 | 网络错误 |
 | 4005 | 应用未安装 |
 | 4006 | 取消付款 |
 | 4007 | 价格超出限额 |
 | 4008 | 获取支付参数错误，请稍后重试 |
 --------------------
 | 其他  | - 请查看返回信息 - |
 */

@interface BmobPay : NSObject

/**
 支付类型选择
 
 - BmobWechat: 微信付款
 - BmobAlipay: 支付宝付款
 */
typedef NS_ENUM(NSInteger, BmobPayType) {
    BmobWechat = 5,
    BmobAlipay = 3
};

/**
 调用支付接口
 
 @param payType 支付类型选择
 @param price 订单价格，限额 0-5000
 @param orderName 订单名称
 @param describe 订单描述
 @param result 支付结果回调
 */
+ (void)payWithPayType:(BmobPayType)payType
                 price:(NSNumber *)price
             orderName:(NSString *)orderName
              describe:(NSString *)describe
                result:(void(^)(BOOL isSuccessful, NSError *error))result;

/**
 订单信息回调
 
 @param orderInfoCallback 回调block
  */
+ (void)orderInfoCallback:(void(^)(NSDictionary *orderInfo))orderInfoCallback;

/**
 支付结果自助查询

 @param orderNumber 订单号
 @param result 回调block
 */
+ (void)queryWithOrderNumber:(NSString *)orderNumber
                      result:(void(^)(NSDictionary *resultDic, NSError *error))result;

@end
