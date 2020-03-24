//
//  QYLocationPickerView.m
//  QYStaging
//
//  Created by wangkai on 2017/4/11.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYLocationPickerView.h"
#import "QYCreditEvaluationMainVC.h"
#import "QYCreditEvaluationWorkVC.h"

@interface QYLocationPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSInteger _provinceIndex;   // 省份选择 记录
    NSInteger _cityIndex;       // 市选择 记录
    NSInteger _districtIndex;   // 区选择 记录
}
/** 确定 */
@property (nonatomic,strong)singleOkBlock m_okBlock;
/** 取消 */
@property (nonatomic,strong)cancelBlock m_failBlock;
/** 数据源 */
@property (nonatomic, strong) NSArray * arrayDS;
@property (nonatomic,strong)UIViewController *m_viewController;
@end

@implementation QYLocationPickerView


- (void)awakeFromNib {
    [super awakeFromNib];
    
    // set delegate
    self.m_pickerView.delegate = self;
    self.m_pickerView.dataSource = self;
    
    //set default data
    [self initData];
}

-(void)initData
{
    _provinceIndex = _cityIndex = _districtIndex = 0;
}

-(void)resetPickerSelectRow:(UIViewController *)viewController
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([viewController isKindOfClass:[QYCreditEvaluationMainVC class]]) {
        NSInteger myProvinceIndex = [[defaults objectForKey:@"_provinceIndex"] integerValue];
        NSInteger myCityIndex = [[defaults objectForKey:@"_cityIndex"] integerValue];
        NSInteger myDistrictIndex = [[defaults objectForKey:@"_districtIndex"] integerValue];
        
        _provinceIndex = myProvinceIndex;
        _cityIndex = myCityIndex;
        _districtIndex = myDistrictIndex;
        
        [self.m_pickerView selectRow:myProvinceIndex inComponent:0 animated:NO];
        [self.m_pickerView selectRow:myCityIndex inComponent:1 animated:NO];
        [self.m_pickerView selectRow:myDistrictIndex inComponent:2 animated:NO];
    }else if ([viewController isKindOfClass:[QYCreditEvaluationWorkVC class]]) {
        NSInteger myProvinceIndex = [[defaults objectForKey:@"work_provinceIndex"] integerValue];
        NSInteger myCityIndex = [[defaults objectForKey:@"work_cityIndex"] integerValue];
        NSInteger myDistrictIndex = [[defaults objectForKey:@"work_districtIndex"] integerValue];
        
        _provinceIndex = myProvinceIndex;
        _cityIndex = myCityIndex;
        _districtIndex = myDistrictIndex;
        
        [self.m_pickerView selectRow:myProvinceIndex inComponent:0 animated:NO];
        [self.m_pickerView selectRow:myCityIndex inComponent:1 animated:NO];
        [self.m_pickerView selectRow:myDistrictIndex inComponent:2 animated:NO];
    }
    self.m_viewController = viewController;

    [self.m_pickerView reloadComponent:0];
    [self.m_pickerView reloadComponent:1];
    [self.m_pickerView reloadComponent:2];
}

// 读取本地Plist加载数据源
-(NSArray *)arrayDS
{
    if(!_arrayDS){
        NSString * path = [[NSBundle mainBundle] pathForResource:@"Province" ofType:@"plist"];
        _arrayDS = [[NSArray alloc] initWithContentsOfFile:path];
    }
    return _arrayDS;
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
        // 暂存当前选中项
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([self.m_viewController isKindOfClass:[QYCreditEvaluationMainVC class]]) {
            [defaults setObject:[NSString stringWithFormat:@"%ld",(long)_provinceIndex] forKey:@"_provinceIndex"];
            [defaults setObject:[NSString stringWithFormat:@"%ld",(long)_cityIndex] forKey:@"_cityIndex"];
            [defaults setObject:[NSString stringWithFormat:@"%ld",(long)_districtIndex] forKey:@"_districtIndex"];
        }else if([self.m_viewController isKindOfClass:[QYCreditEvaluationWorkVC class]]){
            [defaults setObject:[NSString stringWithFormat:@"%ld",(long)_provinceIndex] forKey:@"work_provinceIndex"];
            [defaults setObject:[NSString stringWithFormat:@"%ld",(long)_cityIndex] forKey:@"work_cityIndex"];
            [defaults setObject:[NSString stringWithFormat:@"%ld",(long)_districtIndex] forKey:@"work_districtIndex"];
        }
        
        [defaults synchronize];
        
        self.m_okBlock(self.arrayDS[_provinceIndex][@"province"],self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"city"],self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"districts"][_districtIndex]);
    }
    
}

/**
 *  点击事件
 */
- (void)onOkClicked:(singleOkBlock)okClicked andCancelClicked:(cancelBlock)cancelClicked{
    self.m_okBlock = okClicked;
    self.m_failBlock = cancelClicked;
}

#pragma mark- delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(component == 0){
        _provinceIndex = row;
        _cityIndex = 0;
        _districtIndex = 0;
        
        [self.m_pickerView reloadComponent:1];
        [self.m_pickerView reloadComponent:2];
    }
    else if (component == 1){
        _cityIndex = row;
        _districtIndex = 0;
        
        [self.m_pickerView reloadComponent:2];
    }
    else{
        _districtIndex = row;
    }
    
    //update UI
    [self.m_pickerView selectRow:_provinceIndex inComponent:0 animated:YES];
    [self.m_pickerView selectRow:_cityIndex inComponent:1 animated:YES];
    [self.m_pickerView selectRow:_districtIndex inComponent:2 animated:YES];
}


/**
 列
 
 @param pickerView pickerView description
 @return return value description
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}


/**
 行
 
 @param pickerView pickerView description
 @param component component description
 @return return value description
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component == 0){
        return self.arrayDS.count;
    }
    else if (component == 1){
        return [self.arrayDS[_provinceIndex][@"citys"] count];
    }
    else{
        return [self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"districts"] count];
    }
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0){
        return self.arrayDS[row][@"province"];
    }
    else if (component == 1){
        return self.arrayDS[_provinceIndex][@"citys"][row][@"city"];
    }
    else{
        return self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"districts"][row];
    }
}

@end
