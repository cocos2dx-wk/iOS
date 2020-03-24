//
//  QYCustomVerificationCodeAlert.h
//  QYStaging
//
//  Created by MobileUser on 2017/5/1.
//  Copyright © 2017年 wangkai. All rights reserved.
//  订单协议验证

#import <UIKit/UIKit.h>

typedef void(^successBlock)(id responseObject);
typedef void(^alertBlock)(NSString *alertTitle);
typedef void(^failBlock)(NSString *error);

@interface QYCustomVerificationCodeAlert : UIView

/**
 *初始化弹框
 */
+ (instancetype)customVerificationCodeAlert;

/**
 *  获取验证过程中各种回调处理
 */
- (void)verifyWithPhone:(NSString *)phoneNumber token:(NSString *)token orderId:(NSString *)orderId alertBlock:(alertBlock)alertBlock auccess:(successBlock)successBlock fail:(failBlock)failBlock;

@end
