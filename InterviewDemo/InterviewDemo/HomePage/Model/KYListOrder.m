//
//  KYListOrder.m
//  QYStaging
//
//  Created by 张盖 on 2018/4/8.
//  Copyright © 2018年 wangkai. All rights reserved.
//  订单列表 

#import "KYListOrder.h"

@implementation KYListOrder

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goodsList" : [KYOrderGoodsList class]};
}

@end
