//
//  QYDatePickerView.m
//  QYStaging
//
//  Created by wangkai on 2017/4/15.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYDatePickerView.h"

@interface QYDatePickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSInteger _yearIndex;   // 年
    NSInteger _monthIndex;   // 月
}
/** 确定 */
@property (nonatomic,strong)dateOkBlock m_okBlock;
/** 取消 */
@property (nonatomic,strong)cancelBlock m_failBlock;
/** 数据源数组 */
@property (strong,nonatomic) NSMutableArray *monthArray;
@property (strong,nonatomic) NSMutableArray *yearArray;
/** 年 */
@property (copy,nonatomic) NSString *m_yearStr;
/** 月 */
@property (copy,nonatomic) NSString *m_monthStr;
/* 滚动view */
@property (weak, nonatomic) IBOutlet UIPickerView *m_pickerView;

@end

@implementation QYDatePickerView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // set delegate
    self.m_pickerView.delegate = self;
    self.m_pickerView.dataSource = self;
    
    // 默认Picker状态
    [self resetPickerSelectRow];
}


/**
 恢复状态
 */
-(void)resetPickerSelectRow
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger myYearIndex = [[defaults objectForKey:@"dateYear"] integerValue];
    NSInteger myMonthIndex = [[defaults objectForKey:@"dateMonth"] integerValue];
    
    if(myYearIndex > 0){
        _yearIndex = myYearIndex;
        _monthIndex = myMonthIndex;
    }else{
        _yearIndex = 0;
        _monthIndex = 0;
    }
    
    [self.m_pickerView selectRow:myYearIndex inComponent:0 animated:NO];
    [self.m_pickerView selectRow:myMonthIndex inComponent:1 animated:NO];
    
    [self.m_pickerView reloadComponent:0];
    [self.m_pickerView reloadComponent:1];
    
    if(!myYearIndex)
        myYearIndex = 0;
    self.m_yearStr = [self.yearArray[myYearIndex] stringByReplacingOccurrencesOfString:@"年" withString:@""];
    self.m_monthStr = [self.monthArray[myMonthIndex] stringByReplacingOccurrencesOfString:@"月" withString:@""];
}

- (IBAction)onCancelClicked:(id)sender {
    if (self.m_failBlock) {
        self.m_failBlock(@"取消");
    }
}

- (IBAction)onOkClicked:(id)sender {
    if (self.m_okBlock) {
        if (!self.m_yearStr) {
            self.m_yearStr = [self.yearArray[_yearIndex] stringByReplacingOccurrencesOfString:@"年" withString:@""];
        }
        if (!self.m_monthStr) {
            self.m_monthStr = [self.monthArray[_monthIndex] stringByReplacingOccurrencesOfString:@"月" withString:@""];
        }
        self.m_okBlock(self.m_yearStr,self.m_monthStr);
    }
}

/**
 *  点击事件
 */
- (void)onOkClicked:(dateOkBlock)okClicked andCancelClicked:(cancelBlock)cancelClicked{
    self.m_okBlock = okClicked;
    self.m_failBlock = cancelClicked;
}

#pragma mark- delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    // 暂存当前选中项
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (component == 0) {
        self.m_yearStr = [self.yearArray[row] stringByReplacingOccurrencesOfString:@"年" withString:@""];
        [defaults setObject:[NSString stringWithFormat:@"%ld",(long)row] forKey:@"dateYear"];
    }else{
        self.m_monthStr = [self.monthArray[row] stringByReplacingOccurrencesOfString:@"月" withString:@""];
        [defaults setObject:[NSString stringWithFormat:@"%ld",(long)row] forKey:@"dateMonth"];
    }
    [defaults synchronize];
    
    
}


/**
 列
 
 @param pickerView pickerView description
 @return return value description
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}


/**
 行
 
 @param pickerView pickerView description
 @param component component description
 @return return value description
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return 2018 - 1971 + 1;
    }else {
        return 12;
    }
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return  self.yearArray[row];
    }else {
        return  self.monthArray[row];
    }
}

-(NSMutableArray *)monthArray{
    if (!_monthArray) {
        self.monthArray = [[NSMutableArray alloc]init];
        for (int i = 1; i< 13; i++) {
            NSString *str = [NSString stringWithFormat:@"%d%@",i,@"月"];
            [self.monthArray addObject:str];
        }
    }
    return _monthArray;
}
-(NSMutableArray *)yearArray{
    if (!_yearArray) {
        self.yearArray = [[NSMutableArray alloc]init];
        for (int i = 1971; i<= 2018; i++) {
            NSString *str = [NSString stringWithFormat:@"%d%@",i,@"年"];
            [self.yearArray addObject:str];
        }
    }
    return _yearArray;
}

@end
