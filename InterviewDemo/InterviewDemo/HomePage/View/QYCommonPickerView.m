//
//  QYCommonPickerView.m
//  QYStaging
//
//  Created by wangkai on 2017/4/11.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYCommonPickerView.h"

@interface QYCommonPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>

/** 确定 */
@property (nonatomic,strong)okBlock m_okBlock;
/** 取消 */
@property (nonatomic,strong)cancelBlock m_failBlock;
/** 选中 */
@property (nonatomic,copy)NSString *selectedStr;

@end

@implementation QYCommonPickerView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.m_pickerView.delegate = self;
    self.m_pickerView.dataSource = self;
    self.s_dataArray = [NSMutableArray array];
    
}

/**
 取消

 @param sender sender description
 */
- (IBAction)onCancelClicked:(id)sender {
    if (self.m_failBlock) {
        self.m_failBlock(@"取消");
    }
}


/**
 确定

 @param sender sender description
 */
- (IBAction)onOkClicked:(id)sender {
    if (self.m_okBlock) {
        if (!self.selectedStr && self.s_dataArray.count > 0) {
            self.selectedStr = [self.s_dataArray objectAtIndex:0];
        }
        NSString* selectedStr = @"";
        if (selectedStr.length <= 0 || !selectedStr) {
            selectedStr = self.selectedStr;
        }
        self.m_okBlock(selectedStr);
    }
}

/**
 *  点击事件
 */
- (void)onOkClicked:(okBlock)okClicked andCancelClicked:(cancelBlock)cancelClicked{
    self.m_okBlock = okClicked;
    self.m_failBlock = cancelClicked;
}

#pragma mark- delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectedStr = [self.s_dataArray objectAtIndex:row];
}


/**
 列

 @param pickerView pickerView description
 @return return value description
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}


/**
 行

 @param pickerView pickerView description
 @param component component description
 @return return value description
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.s_dataArray.count;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.s_dataArray objectAtIndex:row];
}

@end
