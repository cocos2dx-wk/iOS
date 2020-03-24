//
//  QYCreditEvluationAssetsVC.m
//  QYStaging
//
//  Created by MobileUser on 2017/4/10.
//  Copyright © 2017年 wangkai. All rights reserved.
//  

#import "QYCreditEvluationAssetsVC.h"
#import "QYCreditEvaluationContactVC.h"
#import "QYCommonPickerView.h"

@interface QYCreditEvluationAssetsVC ()

/** 其它收入 */
@property (weak, nonatomic) IBOutlet UITextField *m_otherIncomeTextField;
/** 月供金额 */
@property (weak, nonatomic) IBOutlet UITextField *m_monthlyAmountTextField;
/** 每月租金 */
@property (weak, nonatomic) IBOutlet UITextField *m_monthlyRentTextField;
/** 每月支出 */
@property (weak, nonatomic) IBOutlet UITextField *m_monthlySpendTextField;
/** 其它债务 */
@property (weak, nonatomic) IBOutlet UITextField *m_otherDebtTextField;
/** 下一步按钮 */
@property (weak, nonatomic) IBOutlet UIButton *m_nextBtn;
/** 财务信息img */
@property (weak, nonatomic) IBOutlet UIImageView *m_assetsImg;
/** 财务信息界面高 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_assetsViewHeight;
/* 其它收入数组*/
@property (strong, nonatomic) NSMutableArray *m_otherIncomeArray;
/* 月供金额数组*/
@property (strong, nonatomic) NSMutableArray *m_monthlyAmountArray;
/* 每月租金数组*/
@property (strong, nonatomic) NSMutableArray *m_monthlyRentArray;
/* 每月支出数组*/
@property (strong, nonatomic) NSMutableArray *m_monthlySpendArray;
/* 其它债务数组*/
@property (strong, nonatomic) NSMutableArray *m_otherDebtArray;
/* 5组数据临时数组*/
@property (strong, nonatomic) NSMutableArray *m_otherIncomeTempArray;
@property (strong, nonatomic) NSMutableArray *m_monthlyAmountTempArray;
@property (strong, nonatomic) NSMutableArray *m_monthlyRentTempArray;
@property (strong, nonatomic) NSMutableArray *m_monthlySpendTempArray;
@property (strong, nonatomic) NSMutableArray *m_otherDebtTempArray;

@end

@implementation QYCreditEvluationAssetsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.navigationItem.title = @"信用评估";
    
    if (iphone6Plus) {
        self.m_assetsViewHeight.constant = 736-64;
    } else if (iphone6) {
        self.m_assetsViewHeight.constant = 667-64;
    } else if (iphone5) {
        self.m_assetsViewHeight.constant = 578;
    } else {
        self.m_assetsViewHeight.constant = 568;
    }
    
    [self.m_nextBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithMacHexString:@"#575DFE"]] forState:UIControlStateNormal];
    [self.m_nextBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithMacHexString:@"#CCCCCC"]] forState:UIControlStateDisabled];
    
    [self.leftButton setAccessibilityIdentifier:@"rl_back_layout"];
    
    if ([[self queryInfo].job.jobType isEqualToString:@"0"]) {
        self.m_workType = QYWorkTypeOnJob;
    } else {
        self.m_workType = QYWorkTypeFree;
    }
    
    self.m_otherIncomeArray = [NSMutableArray array];
    self.m_monthlyAmountArray = [NSMutableArray array];
    self.m_monthlyRentArray = [NSMutableArray array];
    self.m_monthlySpendArray = [NSMutableArray array];
    self.m_otherDebtArray = [NSMutableArray array];
    self.m_otherIncomeTempArray = [NSMutableArray array];
    self.m_monthlyAmountTempArray = [NSMutableArray array];
    self.m_monthlyRentTempArray = [NSMutableArray array];
    self.m_monthlySpendTempArray = [NSMutableArray array];
    self.m_otherDebtTempArray = [NSMutableArray array];
    
    
    //info
    [self registerOrNotication];
    [self echoAssetsInfo];
    [self getQueryCreditDictionary];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self checkLoginBtnStatus];
}

#pragma mark - 注册及通知的实现
- (void)registerOrNotication {
    [self.m_otherIncomeTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    [self.m_monthlyAmountTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    [self.m_monthlyRentTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    [self.m_monthlySpendTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    [self.m_otherDebtTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldWithText:(UITextField *)textField {
    [self checkLoginBtnStatus];
}

#pragma mark - 私有方法
/**
 延迟修改按钮状态
 */
- (void)delayMethod {
    [self checkLoginBtnStatus];
}

/**
 判断下一步按钮状态
 */
- (void)checkLoginBtnStatus {
    
    if (self.m_otherIncomeTextField.text.length > 0 && self.m_monthlyAmountTextField.text.length > 0 && self.m_monthlyRentTextField.text.length > 0 && self.m_monthlySpendTextField.text.length > 0 && self.m_otherDebtTextField.text.length > 0) {
        self.m_nextBtn.enabled = YES;
    } else {
        self.m_nextBtn.enabled = NO;
    }
}

/**
 工作类型

 @param m_workType QYWorkType
 */
- (void)setM_workType:(QYWorkType)m_workType {
    _m_workType = m_workType;
}

/**
 信息回显
 */
- (void)echoAssetsInfo {
    //每月收入
    if ([self queryInfo].asset.userIncomesAllText.length > 0) {
        self.m_otherIncomeTextField.text = [self queryInfo].asset.userIncomesAllText;
    }

    //月供金额
    if ([self queryInfo].asset.monthlyHouseCostText.length > 0) {
        self.m_monthlyAmountTextField.text = [self queryInfo].asset.monthlyHouseCostText;
    }
    
    //每月租金
    if ([self queryInfo].asset.monthlyRentText.length > 0) {
        self.m_monthlyRentTextField.text = [self queryInfo].asset.monthlyRentText;
    }
    
    //每月支出
    if ([self queryInfo].asset.monthlyPayText.length > 0) {
        self.m_monthlySpendTextField.text = [self queryInfo].asset.monthlyPayText;
    }
    
    //其它债务
    if ([self queryInfo].asset.debtText.length > 0) {
        self.m_otherDebtTextField.text = [self queryInfo].asset.debtText;
    }
}

#pragma mark - 点击事件
/**
 点击下一步
 */
- (IBAction)onNextClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    [self.view endEditing:YES];
    
    //保存信息
    UserInfo *info = [self queryInfo];
    QYAssetModel *asset = [[QYAssetModel alloc] init];
    
    //每月收入
    asset.userIncomesAll = [self getAvgWithText:self.m_otherIncomeTextField.text andWithDataArray:self.m_otherIncomeTempArray];
    asset.userIncomesAllText = self.m_otherIncomeTextField.text;
    
    //月供金额
    asset.monthlyHouseCost = [self getAvgWithText:self.m_monthlyAmountTextField.text andWithDataArray:self.m_monthlyAmountTempArray];
    asset.monthlyHouseCostText = self.m_monthlyAmountTextField.text;
    
    //每月租金
    asset.monthlyRent = [self getAvgWithText:self.m_monthlyRentTextField.text andWithDataArray:self.m_monthlyRentTempArray];
    asset.monthlyRentText = self.m_monthlyRentTextField.text;
    
    //每月支出
    asset.monthlyPay = [self getAvgWithText:self.m_monthlySpendTextField.text andWithDataArray:self.m_monthlySpendTempArray];
    asset.monthlyPayText = self.m_monthlySpendTextField.text;
    
    //其它债务
    asset.debt = [self getAvgWithText:self.m_otherDebtTextField.text andWithDataArray:self.m_otherDebtTempArray];
    asset.debtText = self.m_otherDebtTextField.text;
    
    //更新
    info.asset = asset;
    [self updateInfo:info];
    
    QYCreditEvaluationContactVC *vc = [[UIStoryboard storyboardWithName:@"QYHomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"QYCreditEvaluationContactVC"];
    [self.navigationController pushViewController:vc animated:YES];
    
    sender.enabled = YES;
}


/**
 其他收入

 @param sender sender description
 */
- (IBAction)onOtherIncomeClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    //选择界面
    QYCommonPickerView* educationView = [[[NSBundle mainBundle] loadNibNamed:@"QYCommonPickerView"
                                                                       owner:nil
                                                                     options:nil] lastObject];
    educationView.frame = CGRectMake(0, 0, appWidth, 267);
    educationView.backgroundColor = [UIColor clearColor];
    educationView.s_dataArray = self.m_otherIncomeArray;
    [blackView addSubview:educationView];
    blackView.tag = kBLACKTAG;
    
    //自动化id
    [educationView.sureBtn setAccessibilityIdentifier:@"btnSubmit"];
    
    [[UIApplication sharedApplication].keyWindow addSubview:blackView];
    educationView.frame = CGRectMake(0,  rect.size.height,  width, educationView.frame.size.height);
    [UIView animateWithDuration:0.3
                     animations:^{
                         educationView.frame=CGRectMake(0,  rect.size.height -   educationView.frame.size.height,  width, educationView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    [educationView onOkClicked:^(NSString *content) {
        [blackView removeFromSuperview];
        NSString *tempStr = self.m_otherIncomeTextField.text;
        if (content) {
            self.m_otherIncomeTextField.text = content;
        }else{
            self.m_otherIncomeTextField.text = tempStr;
        }
        
        //check button status
        [self checkLoginBtnStatus];
    } andCancelClicked:^(NSString *content) {
        [blackView removeFromSuperview];
    }];
    
    sender.enabled = YES;
}


/**
 月供金额

 @param sender sender description
 */
- (IBAction)onMonthAmountClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    //选择界面
    QYCommonPickerView* educationView = [[[NSBundle mainBundle] loadNibNamed:@"QYCommonPickerView"
                                                                       owner:nil
                                                                     options:nil] lastObject];
    educationView.frame = CGRectMake(0, 0, appWidth, 267);
    educationView.backgroundColor = [UIColor clearColor];
    educationView.s_dataArray = self.m_monthlyAmountArray;
    [blackView addSubview:educationView];
    blackView.tag = kBLACKTAG;
    
    //自动化id
    [educationView.sureBtn setAccessibilityIdentifier:@"btnSubmit"];
    
    [[UIApplication sharedApplication].keyWindow addSubview:blackView];
    educationView.frame = CGRectMake(0,  rect.size.height,  width, educationView.frame.size.height);
    [UIView animateWithDuration:0.3
                     animations:^{
                         educationView.frame=CGRectMake(0,  rect.size.height -   educationView.frame.size.height,  width, educationView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    [educationView onOkClicked:^(NSString *content) {
        [blackView removeFromSuperview];
        NSString *tempStr = self.m_monthlyAmountTextField.text;
        if (content) {
            self.m_monthlyAmountTextField.text = content;
        }else{
            self.m_monthlyAmountTextField.text = tempStr;
        }
        
        //check button status
        [self checkLoginBtnStatus];
    } andCancelClicked:^(NSString *content) {
        [blackView removeFromSuperview];
    }];
    
    sender.enabled = YES;
}


/**
 每月租金

 @param sender sender description
 */
- (IBAction)onMonthRentCliceked:(UIButton *)sender {
    sender.enabled = NO;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    //选择界面
    QYCommonPickerView* educationView = [[[NSBundle mainBundle] loadNibNamed:@"QYCommonPickerView"
                                                                       owner:nil
                                                                     options:nil] lastObject];
    educationView.frame = CGRectMake(0, 0, appWidth, 267);
    educationView.backgroundColor = [UIColor clearColor];
    educationView.s_dataArray = self.m_monthlyRentArray;
    [blackView addSubview:educationView];
    blackView.tag = kBLACKTAG;
    
    //自动化id
    [educationView.sureBtn setAccessibilityIdentifier:@"btnSubmit"];
    
    [[UIApplication sharedApplication].keyWindow addSubview:blackView];
    educationView.frame = CGRectMake(0,  rect.size.height,  width, educationView.frame.size.height);
    [UIView animateWithDuration:0.3
                     animations:^{
                         educationView.frame=CGRectMake(0,  rect.size.height -   educationView.frame.size.height,  width, educationView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    [educationView onOkClicked:^(NSString *content) {
        [blackView removeFromSuperview];
        NSString *tempStr = self.m_monthlyRentTextField.text;
        if (content) {
            self.m_monthlyRentTextField.text = content;
        }else{
            self.m_monthlyRentTextField.text = tempStr;
        }
        
        //check button status
        [self checkLoginBtnStatus];
    } andCancelClicked:^(NSString *content) {
        [blackView removeFromSuperview];
    }];
    
    sender.enabled = YES;
}


/**
 每月支出

 @param sender sender description
 */
- (IBAction)onMonthExpendClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    //选择界面
    QYCommonPickerView* educationView = [[[NSBundle mainBundle] loadNibNamed:@"QYCommonPickerView"
                                                                       owner:nil
                                                                     options:nil] lastObject];
    educationView.frame = CGRectMake(0, 0, appWidth, 267);
    educationView.backgroundColor = [UIColor clearColor];
    educationView.s_dataArray = self.m_monthlySpendArray;
    [blackView addSubview:educationView];
    blackView.tag = kBLACKTAG;
    
    //自动化id
    [educationView.sureBtn setAccessibilityIdentifier:@"btnSubmit"];
    
    [[UIApplication sharedApplication].keyWindow addSubview:blackView];
    educationView.frame = CGRectMake(0,  rect.size.height,  width, educationView.frame.size.height);
    [UIView animateWithDuration:0.3
                     animations:^{
                         educationView.frame=CGRectMake(0,  rect.size.height -   educationView.frame.size.height,  width, educationView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    [educationView onOkClicked:^(NSString *content) {
        [blackView removeFromSuperview];
        NSString *tempStr = self.m_monthlySpendTextField.text;
        if (content) {
            self.m_monthlySpendTextField.text = content;
        }else{
            self.m_monthlySpendTextField.text = tempStr;
        }
        
        //check button status
        [self checkLoginBtnStatus];
    } andCancelClicked:^(NSString *content) {
        [blackView removeFromSuperview];
    }];
    
    sender.enabled = YES;
}


/**
 其他债务

 @param sender sender description
 */
- (IBAction)onOtherDebt:(UIButton *)sender {
    sender.enabled = NO;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    //选择界面
    QYCommonPickerView* educationView = [[[NSBundle mainBundle] loadNibNamed:@"QYCommonPickerView"
                                                                       owner:nil
                                                                     options:nil] lastObject];
    educationView.frame = CGRectMake(0, 0, appWidth, 267);
    educationView.backgroundColor = [UIColor clearColor];
    educationView.s_dataArray = self.m_otherDebtArray;
    [blackView addSubview:educationView];
    blackView.tag = kBLACKTAG;
    
    //自动化id
    [educationView.sureBtn setAccessibilityIdentifier:@"btnSubmit"];
    
    [[UIApplication sharedApplication].keyWindow addSubview:blackView];
    educationView.frame = CGRectMake(0,  rect.size.height,  width, educationView.frame.size.height);
    [UIView animateWithDuration:0.3
                     animations:^{
                         educationView.frame=CGRectMake(0,  rect.size.height -   educationView.frame.size.height,  width, educationView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    [educationView onOkClicked:^(NSString *content) {
        [blackView removeFromSuperview];
        NSString *tempStr = self.m_otherDebtTextField.text;
        if (content) {
            self.m_otherDebtTextField.text = content;
        }else{
            self.m_otherDebtTextField.text = tempStr;
        }
        
        //check button status
        [self checkLoginBtnStatus];
    } andCancelClicked:^(NSString *content) {
        [blackView removeFromSuperview];
    }];
    
    sender.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 取avg

 @param textStr 范围描述
 @return avg
 */
-(NSString *)getAvgWithText:(NSString *)textStr andWithDataArray:(NSMutableArray *)array{
    NSString *avg = @"0";
    for (NSDictionary *keyDic in array) {
        NSString *tempStr = [keyDic valueForKey:@"text"];
        if ([tempStr isEqualToString:textStr]) {
            avg = [keyDic valueForKey:@"avg"];
            break;
        }
    }
    return avg;
}

#pragma mark- 根据信用评估金额类型查询对应的金额字典
-(void)getQueryCreditDictionary {
    [self showLoading];
    NSString *url = [NSString stringWithFormat:@"%@%@?type=all",app_new_queryCreditDictionary,verison];
    
    [[QYNetManager requestManagerWithBaseUrl:myBaseUrl] get:url params:nil success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            [self getQueryCreditDictionarySucceeded:responseObject];
        } else {
            [self getQueryCreditDictionaryFaile:responseObject];
        }
        [self dismissLoading];
    } failure:^(NSString * _Nullable errorString) {
        [self dismissLoading];
        [self showMessageWithString:kShowErrorMessage];
    }];
}

/**
成功
 
 @param responseObject responseObject description
 */
- (void)getQueryCreditDictionarySucceeded:(id)responseObject {
    if([responseObject isKindOfClass:NSDictionary.class]){
        
        [self.m_otherIncomeArray removeAllObjects];
        [self.m_monthlyAmountArray removeAllObjects];
        [self.m_monthlyRentArray removeAllObjects];
        [self.m_monthlySpendArray removeAllObjects];
        [self.m_otherDebtArray removeAllObjects];
        [self.m_otherIncomeTempArray removeAllObjects];
        [self.m_monthlyAmountTempArray removeAllObjects];
        [self.m_monthlyRentTempArray removeAllObjects];
        [self.m_monthlySpendTempArray removeAllObjects];
        [self.m_otherDebtTempArray removeAllObjects];
        NSDictionary *dic = [responseObject valueForKey:@"data"];
        for (NSDictionary *keyDic in [dic valueForKey:@"otherIncomeRange"]) {
            [self.m_otherIncomeArray addObject:[keyDic valueForKey:@"text"]];
            [self.m_otherIncomeTempArray addObject:keyDic];
        }
        for (NSDictionary *keyDic in [dic valueForKey:@"monthlyAmount"]) {
            [self.m_monthlyAmountArray addObject:[keyDic valueForKey:@"text"]];
            [self.m_monthlyAmountTempArray addObject:keyDic];
        }
        for (NSDictionary *keyDic in [dic valueForKey:@"monthlyRent"]) {
            [self.m_monthlyRentArray addObject:[keyDic valueForKey:@"text"]];
             [self.m_monthlyRentTempArray addObject:keyDic];
        }
        for (NSDictionary *keyDic in [dic valueForKey:@"monthlyPayment"]) {
            [self.m_monthlySpendArray addObject:[keyDic valueForKey:@"text"]];
            [self.m_monthlySpendTempArray addObject:keyDic];
        }
        for (NSDictionary *keyDic in [dic valueForKey:@"otherDebt"]) {
            [self.m_otherDebtArray addObject:[keyDic valueForKey:@"text"]];
            [self.m_otherDebtTempArray addObject:keyDic];
        }
    }
}


/**
失败
 
 @param responseObject responseObject description
 */
- (void)getQueryCreditDictionaryFaile:(id)responseObject {
    if ([responseObject objectForKey:@"message"]) {
        [self showMessageWithString:[responseObject objectForKey:@"message"]];
    }
}

@end
