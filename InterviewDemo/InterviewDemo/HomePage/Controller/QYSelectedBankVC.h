//
//  QYSelectedBankVC.h
//  QYStaging
//
//  Created by wangkai on 2017/4/13.
//  Copyright © 2017年 wangkai. All rights reserved.
//  银行卡列表

#import "BaseViewController.h"

@protocol selectedItemDelegate <NSObject>

@required
/**
 *  选择银行卡
 */
- (void)selectedItemWithName:(NSString *)bankName andItemType:(NSString *)bankType;

@end

@interface QYSelectedBankVC : BaseViewController

@property (nonatomic, weak) id<selectedItemDelegate> selectedDelegate;
/* 银行卡数组  */
@property (nonatomic,strong)NSMutableArray *s_bankArray;
@end
