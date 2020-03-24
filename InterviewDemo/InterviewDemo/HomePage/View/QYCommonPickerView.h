//
//  QYCommonPickerView.h
//  QYStaging
//
//  Created by wangkai on 2017/4/11.
//  Copyright © 2017年 wangkai. All rights reserved.
//  通用选择

#import <UIKit/UIKit.h>

typedef void(^okBlock)(NSString *content);
typedef void(^cancelBlock)(NSString *content);

@interface QYCommonPickerView : UIView

/* 确定按钮 */
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

/** 数据源 */
@property (nonatomic,strong)NSMutableArray *s_dataArray;
/* 滚动view */
@property (weak, nonatomic) IBOutlet UIPickerView *m_pickerView;

/**
 *  点击事件
 */
- (void)onOkClicked:(okBlock)okClicked andCancelClicked:(cancelBlock)cancelClicked;

@end
