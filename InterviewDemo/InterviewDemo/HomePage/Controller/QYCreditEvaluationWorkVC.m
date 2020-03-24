//
//  QYCreditEvaluationWorkVC.m
//  QYStaging
//
//  Created by wangkai on 2017/4/11.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYCreditEvaluationWorkVC.h"
#import "QYCreditEvluationAssetsVC.h"
#import "QYCommonPickerView.h"
#import "QYDatePickerView.h"
#import "QYLocationPickerView.h"

@interface QYCreditEvaluationWorkVC ()<UIActionSheetDelegate,UITextFieldDelegate>
/* 选中点*/
@property (weak, nonatomic) IBOutlet UIImageView *m_selectedCircleImg;
@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;
/* 背景高度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_bgHeightConstraint;
/* 工作情况*/
@property (weak, nonatomic) IBOutlet UILabel *m_workDescLabel;
/* 工作类别*/
@property (nonatomic,assign) WorkType m_workType;
/* 在职员工view*/
@property (weak, nonatomic) IBOutlet UIView *m_staffView;
/* 经营者view*/
@property (weak, nonatomic) IBOutlet UIView *m_magageView;
/* 下一步距上 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_nextBtnToTopConstraint;
/* 下一步按钮 */
@property (weak, nonatomic) IBOutlet UIButton *m_nextButton;
/* ----------------在职员工------------*/
/* 公司名称 */
@property (weak, nonatomic) IBOutlet UITextField *m_companyNameTextField;
/* 公司性质 */
@property (weak, nonatomic) IBOutlet UITextField *m_companyNatureTextField;
/* 所属行业 */
@property (weak, nonatomic) IBOutlet UITextField *m_companyIndustryTextField;
/* 公司地址 */
@property (weak, nonatomic) IBOutlet UITextField *m_companyLocationTextField;
/* 公司详细地址 */
@property (weak, nonatomic) IBOutlet UITextField *m_companyAddressTextField;
/* 公司电话 */
@property (weak, nonatomic) IBOutlet UITextField *m_companyPhoneTextField;
/* 入职时间 */
@property (weak, nonatomic) IBOutlet UITextField *m_inductionTimeTextField;
/* 公司性质数组*/
@property (strong, nonatomic) NSMutableArray *m_natureArray;
/* 所属行业数组*/
@property (strong, nonatomic) NSMutableArray *m_industryArray;
/* 省*/
@property (copy, nonatomic) NSString *m_privinceStr;
/* 市*/
@property (copy, nonatomic) NSString *m_cityStr;
/* 区*/
@property (copy, nonatomic) NSString *m_districtStr;
/* 年*/
@property (copy, nonatomic) NSString *m_yearStr;
/* 月*/
@property (copy, nonatomic) NSString *m_monthStr;
/* ----------------个体经营------------*/
/* 经营者 */
@property (weak, nonatomic) IBOutlet UITextField *m_manageNewNameTextField;
/* 经营名 */
@property (weak, nonatomic) IBOutlet UITextField *m_manageNameTextField;
/* 注册号 */
@property (weak, nonatomic) IBOutlet UITextField *m_registerNumberTextField;
/* 经营收入 */
@property (weak, nonatomic) IBOutlet UITextField *m_manageSalaryTextField;
/* 适配 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_toLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_toRightConstraint;

@end

@implementation QYCreditEvaluationWorkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //initUI
    [self initUI];
    
    [self.leftButton setAccessibilityIdentifier:@"rl_back_layout"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //set nav title
    self.navigationItem.title = @"工作信息";
}

-(void)initUI{
    //adpter
    self.m_toLeftConstraint.constant = -10;
    self.m_toRightConstraint.constant = 10;
    
    //work desc
    UserInfo *info = [self queryInfo];
    [AppGlobal setGrayBtn:self.m_nextButton];
    if (info.job.jobType.length > 0) {
        /** 工作类型：0：在职员工、1：个体经营者、2：自由职业 */
        if ([info.job.jobType isEqualToString:@"0"]) {
            self.m_workDescLabel.text = @"在职员工";
            [self setUIwithWorkType:WorkTypeeOnJob];
        }else if ([info.job.jobType isEqualToString:@"1"]){
            self.m_workDescLabel.text = @"个体经营";
            [self setUIwithWorkType:WorkTypeIndividual];
        }else if ([info.job.jobType isEqualToString:@"2"]){
            self.m_workDescLabel.text = @"自由职业";
            [self setUIwithWorkType:WorkTypeFree];
        }
        self.m_workDescLabel.textColor = [UIColor colorWithHexString:@"4c4c4c"];
    }else{
        self.m_workDescLabel.text = @"请选择";
        self.m_workDescLabel.textColor = [UIColor grayColor];
        [self setUIwithWorkType:WorkTypeNone];
        [AppGlobal setGrayBtn:self.m_nextButton];
    }
}


/**
 根据类型布局

 @param workType workType description
 */
-(void)setUIwithWorkType:(WorkType)workType{
    self.m_staffView.hidden = YES;
    self.m_magageView.hidden = YES;
    float defaultFloat = 27;
    float baseFloat = 94 + 52 + 27 + 45 + 45;
    UserInfo *info = [self queryInfo];
    [self.m_companyNameTextField resignFirstResponder];
    [self.m_companyAddressTextField resignFirstResponder];
    [self.m_companyPhoneTextField resignFirstResponder];
    [self.m_manageNameTextField resignFirstResponder];
    [self.m_registerNumberTextField resignFirstResponder];
    [self.m_manageSalaryTextField resignFirstResponder];
//    self.m_companyNameTextField.text = @"";
//    self.m_companyNatureTextField.text = @"";
//    self.m_companyIndustryTextField.text = @"";
//    self.m_companyLocationTextField.text = @"";
//    self.m_companyAddressTextField.text = @"";
//    self.m_companyPhoneTextField.text = @"";
//    self.m_inductionTimeTextField.text = @"";
//    self.m_manageNameTextField.text = @"";
//    self.m_registerNumberTextField.text = @"";
//    self.m_manageSalaryTextField.text = @"";
    
    self.m_workDescLabel.textColor = [UIColor colorWithHexString:@"4c4c4c"];
    if (workType == WorkTypeeOnJob) {//在职员工
        self.m_staffView.hidden = NO;
        self.m_nextBtnToTopConstraint.constant = defaultFloat + self.m_staffView.frame.size.height;
        self.m_bgHeightConstraint.constant = baseFloat + self.m_staffView.frame.size.height;
        
        //set default UI
        self.m_companyNameTextField.delegate = self;
        if (info.job.companyName.length > 0) {
            self.m_companyNameTextField.text = info.job.companyName;
        }
        self.m_companyAddressTextField.delegate = self;
        self.m_natureArray = [NSMutableArray arrayWithObjects:@"国企",@"外商独资",@"代表处",@"合资",@"民营",@"股份制企业",@"上市公司",@"国家机关",@"事业单位",@"其他", nil];
        if (info.job.entryTime.length > 0) {
            self.m_companyNatureTextField.text = [self getNatureWithType:info.job.companyType];
        }
        self.m_industryArray = [NSMutableArray arrayWithObjects:@"互联网",@"金融业",@"房地产/建筑业",@"商业服务",@"服务业",@"政府/非盈利机构",@"贸易/批发/零售/租赁业",@"文体教育/工艺美术",@"文化/传媒/娱乐/体育",@"生产/加工/制造",@"其他", nil];
        if (info.job.entryTime.length > 0) {
            self.m_companyIndustryTextField.text = [self getIndustryWithType:info.job.industry];
        }
        if (info.job.province.length > 0) {
            NSString *tempStr = [NSString stringWithFormat:@"%@%@%@",info.job.province,info.job.city?info.job.city:@"",info.job.district?info.job.district:@""];
            self.m_companyLocationTextField.text = tempStr;
        }
        if (self.m_companyLocationTextField.text.length <= 0) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSString stringWithFormat:@"%d",0] forKey:@"work_provinceIndex"];
            [defaults setObject:[NSString stringWithFormat:@"%d",0] forKey:@"work_cityIndex"];
            [defaults setObject:[NSString stringWithFormat:@"%d",0] forKey:@"work_districtIndex"];
            [defaults synchronize];
        }else{
            self.m_privinceStr = info.job.province;
            self.m_cityStr = info.job.city;
            self.m_districtStr = info.job.district;
        }
        if (info.job.address.length > 0) {
            self.m_companyAddressTextField.text = info.job.address;
        }
        if (info.job.companyPhone.length > 0) {
            self.m_companyPhoneTextField.text = info.job.companyPhone;
        }
        if (info.job.entryTime.length > 0) {
            self.m_inductionTimeTextField.text = [AppGlobal timeWithTimeIntervalString:info.job.entryTime];
        }
        self.m_companyPhoneTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        
        //set delegate
        [self.m_companyNameTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        [self.m_companyNatureTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        [self.m_companyIndustryTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        [self.m_companyLocationTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        [self.m_companyAddressTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        [self.m_companyPhoneTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        [self.m_inductionTimeTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    }else if(workType == WorkTypeIndividual){//个体经营
        self.m_magageView.hidden = NO;
        self.m_nextBtnToTopConstraint.constant = defaultFloat + self.m_magageView.frame.size.height;
        self.m_bgHeightConstraint.constant = baseFloat + self.m_magageView.frame.size.height;
        
        //set default UI
        self.m_manageNameTextField.delegate = self;
        self.m_registerNumberTextField.delegate = self;
        self.m_registerNumberTextField.keyboardType = UIKeyboardTypeASCIICapable;
        self.m_manageSalaryTextField.delegate = self;
        self.m_manageSalaryTextField.keyboardType = UIKeyboardTypeDecimalPad;
        [self.m_manageNameTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        [self.m_registerNumberTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        [self.m_manageSalaryTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        if (info.personfullname.length > 0) {
            self.m_manageNewNameTextField.text = info.personfullname;
        }
        if (info.job.ManagementName.length > 0) {
            self.m_manageNameTextField.text = info.job.ManagementName;
        }
        if (info.job.businessLicenseNum.length > 0) {
            self.m_registerNumberTextField.text = info.job.businessLicenseNum;
        }
        if (info.job.salary.length > 0) {
            self.m_manageSalaryTextField.text = info.job.salary;
        }
    }else if(workType == WorkTypeFree){//无业
        self.m_nextBtnToTopConstraint.constant = defaultFloat;
        self.m_bgHeightConstraint.constant = baseFloat;
    }else if(workType == WorkTypeNone){
        self.m_workDescLabel.textColor = [UIColor grayColor];
        self.m_nextBtnToTopConstraint.constant = defaultFloat;
        self.m_bgHeightConstraint.constant = baseFloat;
    }
    self.m_workType = workType;
    
    //设置滚动
    self.m_scrollView.showsVerticalScrollIndicator = FALSE;
    [self.m_scrollView setContentSize:CGSizeMake(appWidth, self.m_bgHeightConstraint.constant)];
    if (self.m_bgHeightConstraint.constant > appHeight) {
        self.m_scrollView.scrollEnabled = YES;
    }else{
        self.m_scrollView.scrollEnabled = NO;
    }
    
    //check status
    [self checkBtnStatus];
}

/**
 监听输入框
 
 @param textField textField
 */
- (void)textFieldWithText:(UITextField *)textField {
    [self checkBtnStatus];
}

/**
 工作情况

 @param sender sender description
 */
- (IBAction)onSelectedWorkClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    UIActionSheet *workDescActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"在职员工", @"个体经营", @"自由职业", nil];
    [workDescActionSheet showInView:self.view];
    
    sender.enabled = YES;
}


/**
 下一步

 @param sender sender description
 */
- (IBAction)onNextClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    [self.view endEditing:YES];
    
    if (self.m_workType == WorkTypeIndividual) {
        //check 注册号
        if (!self.m_registerNumberTextField.text.checkingUserName) {
            [self showMessageWithString:@"注册号格式错误，请输入由数字或数字加字母组合的小于等于18位的字符"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                         (int64_t)(kShowMessageTime * NSEC_PER_SEC)),
                           dispatch_get_main_queue(), ^{
                               [self.m_registerNumberTextField becomeFirstResponder];
                           });
            sender.enabled = YES;
            return;
        }
    }else if(self.m_workType == WorkTypeeOnJob){
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
        NSInteger year = [dateComponent year];
        NSInteger month = [dateComponent month];
        if (([self.m_yearStr integerValue] == year) && ([self.m_monthStr integerValue] > month)) {
            [self showMessageWithString:@"入职时间格式错误,不能选择未来时间"];
            sender.enabled = YES;
            return;
        }
    }

    
    //update userInfo
    UserInfo *info = [self queryInfo];
    QYJobModel *jobModel = [[QYJobModel alloc] init];
    NSString *workType = @"0";// 工作类型：2：无业、0：在职、1：个体经营者 */
    if (self.m_workType == WorkTypeeOnJob) {
        workType = @"0";
    }else if (self.m_workType == WorkTypeIndividual) {
        workType = @"1";
    }else if (self.m_workType == WorkTypeFree) {
        workType = @"2";
    }
    jobModel.jobType =  workType;
    if (self.m_companyNameTextField.text.length > 0) {
        jobModel.companyName =  self.m_companyNameTextField.text;
    }
    if (self.m_manageNameTextField.text.length > 0) {
        jobModel.ManagementName = self.m_manageNameTextField.text;
    }
    jobModel.companyType = [NSString stringWithFormat:@"%ld",(long)[self getIndexWithNatureLabel:self.m_companyNatureTextField.text]];
    jobModel.industry = [NSString stringWithFormat:@"%ld",(long)[self getIndexWithIndustry:self.m_companyIndustryTextField.text]];
    jobModel.address = self.m_companyAddressTextField.text;
    jobModel.companyPhone = self.m_companyPhoneTextField.text;
    if (self.m_inductionTimeTextField.text.length > 0) {
       jobModel.entryTime = [AppGlobal timeIntervalWithDate:self.m_inductionTimeTextField.text];
    }
    jobModel.province = self.m_privinceStr;
    jobModel.city = self.m_cityStr;
    jobModel.district = self.m_districtStr;
    jobModel.salary = self.m_manageSalaryTextField.text;
    jobModel.businessLicenseNum = self.m_registerNumberTextField.text;
    info.job = jobModel;
    [self updateInfo:info];
    
    //goto CreditEvluationAssets
    QYCreditEvluationAssetsVC *vc = [[UIStoryboard storyboardWithName:@"QYHomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"QYCreditEvluationAssetsVC"];
    [self.navigationController pushViewController:vc animated:YES];
    
    sender.enabled = YES;
}

#pragma mark- action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        self.m_workDescLabel.text = @"在职员工";
        [self setUIwithWorkType:WorkTypeeOnJob];
    }else if (buttonIndex == 1){
        self.m_workDescLabel.text = @"个体经营者";
        [self setUIwithWorkType:WorkTypeIndividual];
    }else if (buttonIndex == 2){
        self.m_workDescLabel.text = @"自由职业";
        [self setUIwithWorkType:WorkTypeFree];
    }
}


/**
 公司性质

 @param sender sender description
 */
- (IBAction)onCompanyNatureClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    [self.m_companyNameTextField resignFirstResponder];
    [self.m_companyAddressTextField resignFirstResponder];
    [self.m_companyPhoneTextField resignFirstResponder];
    
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
    educationView.s_dataArray = self.m_natureArray;
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
        NSString *tempStr = self.m_companyNatureTextField.text;
        if (content) {
            self.m_companyNatureTextField.text = content;
        }else{
            self.m_companyNatureTextField.text = tempStr;
        }
        
        //check button status
        [self checkBtnStatus];
    } andCancelClicked:^(NSString *content) {
        [blackView removeFromSuperview];
    }];
    
    
    sender.enabled = YES;
}


/**
 所属行业

 @param sender sender description
 */
- (IBAction)onCompanyIndustryClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    [self.m_companyNameTextField resignFirstResponder];
    [self.m_companyAddressTextField resignFirstResponder];
    [self.m_companyPhoneTextField resignFirstResponder];
    
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
    educationView.s_dataArray = self.m_industryArray;
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
        NSString *tempStr = self.m_companyIndustryTextField.text;
        if (content) {
            self.m_companyIndustryTextField.text = content;
        }else{
            self.m_companyIndustryTextField.text = tempStr;
        }
        
        //check button status
        [self checkBtnStatus];
    } andCancelClicked:^(NSString *content) {
        [blackView removeFromSuperview];
    }];
    
    
    sender.enabled = YES;
}


/**
 公司地址

 @param sender sender description
 */
- (IBAction)onLocationClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    [self.m_companyNameTextField resignFirstResponder];
    [self.m_companyNatureTextField resignFirstResponder];
    [self.m_companyIndustryTextField resignFirstResponder];
    [self.m_companyAddressTextField resignFirstResponder];
    [self.m_companyPhoneTextField resignFirstResponder];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    //选择城市界面
    QYLocationPickerView* locationView = [[[NSBundle mainBundle] loadNibNamed:@"QYLocationPickerView"
                                                                        owner:nil
                                                                      options:nil] lastObject];
    locationView.frame = CGRectMake(0, 0, appWidth, 267);
    locationView.backgroundColor = [UIColor clearColor];
    [blackView addSubview:locationView];
    blackView.tag = kBLACKTAG;
    
    //自动化id
    [locationView.sureBtn setAccessibilityIdentifier:@"btnSubmit"];
    
    [locationView resetPickerSelectRow:self];
    [[UIApplication sharedApplication].keyWindow addSubview:blackView];
    locationView.frame = CGRectMake(0,  rect.size.height,  width, locationView.frame.size.height);
    [UIView animateWithDuration:0.3
                     animations:^{
                         locationView.frame=CGRectMake(0,  rect.size.height -   locationView.frame.size.height,  width, locationView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    __weak QYCreditEvaluationWorkVC *weakSelf = self;
    [locationView onOkClicked:^(NSString *province,NSString *city,NSString *district) {
        [blackView removeFromSuperview];
        NSString *tempStr = self.m_companyLocationTextField.text;
        if (province && city && district ) {
            weakSelf.m_companyLocationTextField.text = [NSString stringWithFormat:@"%@%@%@",province,city,district];
            weakSelf.m_privinceStr = province;
            weakSelf.m_cityStr = city;
            weakSelf.m_districtStr = district;
        }else{
            weakSelf.m_companyLocationTextField.text = tempStr;
        }
        
        //check button status
        [weakSelf checkBtnStatus];
    } andCancelClicked:^(NSString *content) {
        [blackView removeFromSuperview];
    }];
    
    sender.enabled = YES;
}

/**
 入职时间

 @param sender sender description
 */
- (IBAction)onIndustryTimeClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    [self.m_companyNameTextField resignFirstResponder];
    [self.m_companyAddressTextField resignFirstResponder];
    [self.m_companyPhoneTextField resignFirstResponder];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    //选择界面
    QYDatePickerView* dateView = [[[NSBundle mainBundle] loadNibNamed:@"QYDatePickerView"
                                                                       owner:nil
                                                                     options:nil] lastObject];
    dateView.frame = CGRectMake(0, 0, appWidth, 267);
    dateView.backgroundColor = [UIColor clearColor];
    [blackView addSubview:dateView];
    blackView.tag = kBLACKTAG;
    [[UIApplication sharedApplication].keyWindow addSubview:blackView];
    dateView.frame = CGRectMake(0,  rect.size.height,  width, dateView.frame.size.height);
    [UIView animateWithDuration:0.3
                     animations:^{
                         dateView.frame=CGRectMake(0,  rect.size.height -   dateView.frame.size.height,  width, dateView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    [dateView onOkClicked:^(NSString *yearStr, NSString *monthStr) {
        [blackView removeFromSuperview];
        NSString *tempStr = self.m_companyNatureTextField.text;
        if (yearStr) {
            self.m_inductionTimeTextField.text = [NSString stringWithFormat:@"%@-%02d",yearStr,[monthStr intValue]];
            self.m_yearStr = yearStr;
            self.m_monthStr = monthStr;
        }else{
            self.m_companyNatureTextField.text = tempStr;
        }
        
        //check button status
        [self checkBtnStatus];
    } andCancelClicked:^(NSString *content) {
        [blackView removeFromSuperview];
    }];
    
    sender.enabled = YES;
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        
        return YES;
    }
    
    
    // 限制最大输入位数
    NSString *toBeString =
    [textField.text stringByReplacingCharactersInRange:range
                                            withString:string];
    
    if (self.m_manageSalaryTextField == textField) {
        self.m_manageSalaryTextField.clearsOnBeginEditing = NO;
        NSScanner      *scanner    = [NSScanner scannerWithString:string];
        NSCharacterSet *numbers;
        NSRange         pointRange = [textField.text rangeOfString:@"."];
        
        if ( (pointRange.length > 0) && (pointRange.location < range.location  || pointRange.location > range.location + range.length) )
        {
            numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        }
        else
        {
            numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        }
        
        if ( [textField.text isEqualToString:@""] && [string isEqualToString:@"."] )
        {
            return NO;
        }
        
        short remain = 2; //默认保留2位小数
        
        NSString *tempStr = [textField.text stringByAppendingString:string];
        NSUInteger strlen = [tempStr length];
        if(pointRange.length > 0 && pointRange.location > 0){ //判断输入框内是否含有“.”。
            if([string isEqualToString:@"."]){ //当输入框内已经含有“.”时，如果再输入“.”则被视为无效。
                return NO;
            }
            if(strlen > 0 && (strlen - pointRange.location) > remain+1){ //当输入框内已经含有“.”，当字符串长度减去小数点前面的字符串长度大于需要要保留的小数点位数，则视当次输入无效。
                return NO;
            }
        }
        
        NSRange zeroRange = [textField.text rangeOfString:@"0"];
        if(zeroRange.length == 1 && zeroRange.location == 0){ //判断输入框第一个字符是否为“0”
            if(![string isEqualToString:@"0"] && ![string isEqualToString:@"."] && [textField.text length] == 1){ //当输入框只有一个字符并且字符为“0”时，再输入不为“0”或者“.”的字符时，则将此输入替换输入框的这唯一字符。
                textField.text = string;
                return NO;
            }else{
                if(pointRange.length == 0 && pointRange.location > 0){ //当输入框第一个字符为“0”时，并且没有“.”字符时，如果当此输入的字符为“0”，则视当此输入无效。
                    if([string isEqualToString:@"0"]){
                        return NO;
                    }
                }
            }
        }
        
        NSString *buffer;
        if ( ![scanner scanCharactersFromSet:numbers intoString:&buffer] && ([string length] != 0) )
        {
            return NO;
        }
        
        return YES;
    }
    
    if (self.m_companyNameTextField == textField) {
        if ([toBeString length] > 50) {
            textField.text = [toBeString substringToIndex:50];
            
            return NO;
        }
    }
    if (self.m_companyAddressTextField == textField) {
        if ([toBeString length] > 50) {
            textField.text = [toBeString substringToIndex:50];
            
            return NO;
        }
    }
    if (self.m_manageNameTextField == textField) {
        if ([toBeString length] > 50) {
            textField.text = [toBeString substringToIndex:50];
            
            return NO;
        }
    }
    if (self.m_registerNumberTextField == textField) {
        if ([toBeString length] > 18) {
            textField.text = [toBeString substringToIndex:18];
            
            return NO;
        }
    }
    
    
    return YES;
}

/**
 *  校验按钮状态
 */
- (void)checkBtnStatus {
    [AppGlobal setGrayBtn:self.m_nextButton];
    if(self.m_workType == WorkTypeeOnJob){
        if (self.m_companyNameTextField.text.length > 0 && self.m_companyNatureTextField.text.length > 0 && self.m_companyIndustryTextField.text.length > 0 && self.m_companyAddressTextField.text.length > 0 && self.m_inductionTimeTextField.text.length > 0 && self.m_companyLocationTextField.text.length > 0) {
            [AppGlobal setResetBtn:self.m_nextButton];
        }
    }else if (self.m_workType == WorkTypeIndividual){
        if (self.m_manageNameTextField.text.length > 0 && self.m_registerNumberTextField.text.length > 0 && self.m_manageSalaryTextField.text.length > 0 && ![self.m_manageSalaryTextField.text isEqualToString:@"0"]) {
            [AppGlobal setResetBtn:self.m_nextButton];
        }
    }else if (self.m_workType == WorkTypeFree){
        [AppGlobal setResetBtn:self.m_nextButton];
    }else {
        [AppGlobal setResetBtn:self.m_nextButton];
    }
}

/**
 0：国企、1：外商独资、2：代表处、3：合资、4：民营、5：股份制企业、6：上市公司、7：国家机关、8：事业单位、9：其他
 
 @param typeStr typeStr description
 */
-(NSString *)getNatureWithType:(NSString *)typeStr {
    NSString *tempStr = @"";
    if ([typeStr isEqualToString:@"0"]) {
        tempStr = @"国企";
    }else if([typeStr isEqualToString:@"1"]){
        tempStr = @"外商独资";
    }else if([typeStr isEqualToString:@"2"]){
        tempStr = @"代表处";
    }else if([typeStr isEqualToString:@"3"]){
        tempStr = @"合资";
    }else if([typeStr isEqualToString:@"4"]){
        tempStr = @"民营";
    }else if([typeStr isEqualToString:@"5"]){
        tempStr = @"股份制企业";
    }else if([typeStr isEqualToString:@"6"]){
        tempStr = @"上市公司";
    }else if([typeStr isEqualToString:@"7"]){
        tempStr = @"国家机关";
    }else if([typeStr isEqualToString:@"8"]){
        tempStr = @"事业单位";
    }else if([typeStr isEqualToString:@"9"]){
        tempStr = @"其他";
    }
    
    
    return tempStr;
}


/**
 默认选中公司性质
 0：国企、1：外商独资、2：代表处、3：合资、4：民营、5：股份制企业、6：上市公司、7：国家机关、8：事业单位、9：其他
 @param tempStr tempStr description
 @return return value description
 */
-(NSInteger)getIndexWithNatureLabel:(NSString *)tempStr {
    NSInteger index = 0;
    if (tempStr.length <= 0) {
        index = 0;
    }
    
    if ([tempStr isEqualToString:@"国企"]) {
        index = 0;
    }else if ([tempStr isEqualToString:@"外商独资"]){
        index = 1;
    }else if ([tempStr isEqualToString:@"代表处"]){
        index = 2;
    }else if ([tempStr isEqualToString:@"合资"]){
        index = 3;
    }else if ([tempStr isEqualToString:@"民营"]){
        index = 4;
    }else if ([tempStr isEqualToString:@"股份制企业"]){
        index = 5;
    }else if ([tempStr isEqualToString:@"上市公司"]){
        index = 6;
    }else if ([tempStr isEqualToString:@"国家机关"]){
        index = 7;
    }else if ([tempStr isEqualToString:@"事业单位"]){
        index = 8;
    }else if ([tempStr isEqualToString:@"其他"]){
        index = 9;
    }
    
    return index;
}

/**
 行业：0：互联网、1：金融业、2：房地产/建筑业、3：商业服务、4：服务业、5：政府/非盈利机构、6：贸易/批发/零售/租赁业、7：文体教育/工艺美术、8：文化/传媒/娱乐/体育、9：生产/加工/制造、10：其他
 
 @param typeStr typeStr description
 */
-(NSString *)getIndustryWithType:(NSString *)typeStr {
    NSString *tempStr = @"";
    if ([typeStr isEqualToString:@"0"]) {
        tempStr = @"互联网";
    }else if([typeStr isEqualToString:@"1"]){
        tempStr = @"金融业";
    }else if([typeStr isEqualToString:@"2"]){
        tempStr = @"房地产/建筑业";
    }else if([typeStr isEqualToString:@"3"]){
        tempStr = @"商业服务";
    }else if([typeStr isEqualToString:@"4"]){
        tempStr = @"服务业";
    }else if([typeStr isEqualToString:@"5"]){
        tempStr = @"政府/非盈利机构";
    }else if([typeStr isEqualToString:@"6"]){
        tempStr = @"贸易/批发/零售/租赁业";
    }else if([typeStr isEqualToString:@"7"]){
        tempStr = @"文体教育/工艺美术";
    }else if([typeStr isEqualToString:@"8"]){
        tempStr = @"文化/传媒/娱乐/体育";
    }else if([typeStr isEqualToString:@"9"]){
        tempStr = @"生产/加工/制造";
    }else if([typeStr isEqualToString:@"10"]){
        tempStr = @"其他";
    }
    
    
    return tempStr;
}


/**
 默认选中行业
 行业：0：互联网、1：金融业、2：房地产/建筑业、3：商业服务、4：服务业、5：政府/非盈利机构、6：贸易/批发/零售/租赁业、7：文体教育/工艺美术、8：文化/传媒/娱乐/体育、9：生产/加工/制造、10：其他
 @param tempStr tempStr description
 @return return value description
 */
-(NSInteger)getIndexWithIndustry:(NSString *)tempStr {
    NSInteger index = 0;
    if (tempStr.length <= 0) {
        index = 0;
    }
    
    if ([tempStr isEqualToString:@"互联网"]) {
        index = 0;
    }else if ([tempStr isEqualToString:@"金融业"]){
        index = 1;
    }else if ([tempStr isEqualToString:@"房地产/建筑业"]){
        index = 2;
    }else if ([tempStr isEqualToString:@"商业服务"]){
        index = 3;
    }else if ([tempStr isEqualToString:@"服务业"]){
        index = 4;
    }else if ([tempStr isEqualToString:@"政府/非盈利机构"]){
        index = 5;
    }else if ([tempStr isEqualToString:@"贸易/批发/零售/租赁业"]){
        index = 6;
    }else if ([tempStr isEqualToString:@"文体教育/工艺美术"]){
        index = 7;
    }else if ([tempStr isEqualToString:@"文化/传媒/娱乐/体育"]){
        index = 8;
    }else if ([tempStr isEqualToString:@"生产/加工/制造"]){
        index = 9;
    }else if ([tempStr isEqualToString:@"其他"]){
        index = 10;
    }
    
    return index;
}



@end
