//
//  QYCreditEvluationAssetsVC.h
//  QYStaging
//
//  Created by MobileUser on 2017/4/10.
//  Copyright © 2017年 wangkai. All rights reserved.
//  财务信息

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QYWorkType) {
    QYWorkTypeOnJob = 0,// 在职员工
//    QYWorkTypeIndividual,//个体经营
    QYWorkTypeFree,//自由职业
};

@interface QYCreditEvluationAssetsVC : BaseViewController

@property (nonatomic,assign) QYWorkType m_workType;

@end
