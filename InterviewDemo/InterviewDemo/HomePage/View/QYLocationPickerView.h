//
//  QYLocationPickerView.h
//  QYStaging
//
//  Created by wangkai on 2017/4/11.
//  Copyright © 2017年 wangkai. All rights reserved.
//  城市选择

#import <UIKit/UIKit.h>

typedef void(^singleOkBlock)(NSString *province,NSString *city,NSString *district);
typedef void(^cancelBlock)(NSString *content);

@interface QYLocationPickerView : UIView

/* 确定按钮 */
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

/* 滚动view */
@property (weak, nonatomic) IBOutlet UIPickerView *m_pickerView;

/**
 *  点击事件
 */
- (void)onOkClicked:(singleOkBlock)okClicked andCancelClicked:(cancelBlock)cancelClicked;
/**
 *  默认选中
 */
-(void)resetPickerSelectRow:(UIViewController *)viewController;

@end
