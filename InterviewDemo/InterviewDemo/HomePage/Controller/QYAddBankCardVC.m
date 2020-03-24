//
//  QYAddBankCardVC.m
//  QYStaging
//
//  Created by wangkai on 2017/4/13.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYAddBankCardVC.h"
#import "QYSelectedBankVC.h"

@interface QYAddBankCardVC ()<UITextFieldDelegate,selectedItemDelegate>

/* 持卡人名字*/
@property (weak, nonatomic) IBOutlet UILabel *m_nameLabel;
/* 银行名*/
@property (weak, nonatomic) IBOutlet UITextField *m_bankTextField;
/* 银行名*/
@property (copy, nonatomic) NSString *m_bankNameStr;
/* 卡号*/
@property (weak, nonatomic) IBOutlet UITextField *m_cardNumberTextField;
/* 下一步按钮*/
@property (weak, nonatomic) IBOutlet UIButton *m_nextButton;
/* 银行卡类别1储蓄卡  2信用卡*/
@property (copy, nonatomic) NSString *m_bankTypeStr;
/* 图片*/
@property (strong,nonatomic)UIImage *m_bankCardImage;
/* 图片id*/
@property (copy,nonatomic)NSString *m_swiftIdStr;

@end

@implementation QYAddBankCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //init UI
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //set nav title
    self.navigationItem.title = @"添加银行卡信息";
}

-(void)dealloc{
    [NotificationCenter removeObserver:self];
}

-(void)initUI{
    
    //restore keyboard response
    UITapGestureRecognizer *singleOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(becomeResponder:)];
    singleOne.numberOfTouchesRequired = 1;
    singleOne.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleOne];
    
    //set name
    UserInfo *info = [self queryInfo];
    self.m_nameLabel.text = info.personfullname;
    
    //set bankCard number
    [AppGlobal setGrayBtn:self.m_nextButton];
    self.m_cardNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.m_cardNumberTextField.delegate = self;
    [self.m_cardNumberTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    
    //save path
    [NotificationCenter addObserver:self selector:@selector(saveBankCardImg:) name:kBANKCARDPNGNotification object:nil];
}

/**
 监听输入框
 
 @param textField textField
 */
- (void)textFieldWithText:(UITextField *)textField {
    [self checkBtnStatus];
}

/**
 *  校验按钮状态
 */
- (void)checkBtnStatus {
    
    NSString* tempIdCardStr =  [AppGlobal repleaceBlankWithString:self.m_cardNumberTextField.text];
    if (self.m_bankTextField.text.length > 0 && tempIdCardStr.length > 0) {
        [AppGlobal setResetBtn:self.m_nextButton];
    }else{
        [AppGlobal setGrayBtn:self.m_nextButton];
    }
}

/**
 *  失去键盘响应
 */
-(void)becomeResponder:(id)sender {
    [self.m_bankTextField resignFirstResponder];
    [self.m_cardNumberTextField resignFirstResponder];
}

/**
 *  选择银行卡
 */
- (void)selectedItemWithName:(NSString *)bankName andItemType:(NSString *)bankType{
    NSString *tempStr = @"";
    if ([bankType isEqualToString:@"1"]) {
        tempStr = @"储蓄卡";
    }else{
        tempStr = @"信用卡";
    }
    self.m_bankTextField.text = [NSString stringWithFormat:@"%@(%@)",bankName,tempStr];
    self.m_bankNameStr = bankName;
    self.m_bankTypeStr = bankType;
    [self checkBtnStatus];
}

/**
 选择银行

 @param sender sender description
 */
- (IBAction)onSelectedBankClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    [self getBankCardList];
    
    sender.enabled = YES;
}


/**
 识别银行卡

 @param sender sender description
 */
- (IBAction)onCardNumberClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    // 是否开启相机
    if ([AppGlobal isCameraPermissions]) {
        BOOL bankcard = [MGBankCardManager getLicense];
        
        if (!bankcard) {
            [self showMessageWithString:@"网络不通畅,请重试"];
            return;
        }
        
        __unsafe_unretained QYAddBankCardVC *weakSelf = self;
        MGBankCardManager *cardManager = [[MGBankCardManager alloc] init];
        cardManager.viewType = MGBankCardViewCardBox;
        //        [cardManager setDebug:YES];//显示debug信息
        [cardManager CardStart:self finish:^(MGBankCardModel * _Nullable result) {
            weakSelf.m_cardNumberTextField.text = [AppGlobal getFormateBankNumberInPersonal:result.bankCardNumber];
            [weakSelf checkBtnStatus];
        }];
    } else {
        [AppGlobal openCameraPermissions];
    }
    
    sender.enabled = YES;
}


/**
 下一步

 @param sender sender description
 */
- (IBAction)onNextClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    //upload file
    [self uploadFile];
    
    sender.enabled = YES;
}

-(void)saveBankCardImg:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    NSString *myPath = dic[@"path"];
    UIImage *myImg = [UIImage imageWithContentsOfFile:myPath];
    //压缩图片
    self.m_bankCardImage = [UIImage generateDiyEditImage:myImg withSize:CGSizeMake(158, 108) andQuality:0.5f];
}

#pragma mark- textField delegate
- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"] || [string isEqualToString:@""]) {
        
        return YES;
    }
    
    if (self.m_cardNumberTextField == textField) {
        [self checkBtnStatus];
        return [UITextField bankNumberFormatTextField:self.m_cardNumberTextField
                        shouldChangeCharactersInRange:range
                                    replacementString:string];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ((self.m_cardNumberTextField == textField)) {
        [self checkBtnStatus];
    }
}

-(void)addBankCard {
    [self showLoading];
    
    NSString *tempCardTypeStr = @"0";
    if ([self.m_bankTypeStr isEqualToString:@"1"]) {
        tempCardTypeStr = @"0";
    }
    if ([self.m_bankTypeStr isEqualToString:@"2"]) {
        tempCardTypeStr = @"1";
    }
    NSString* tempCardNumberStr =  [AppGlobal repleaceBlankWithString:self.m_cardNumberTextField.text];
    NSString *url = [NSString stringWithFormat:@"%@%@",app_new_bankAdd,verison];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"bankName"] = self.m_bankNameStr;
    dic[@"cardType"] = tempCardTypeStr;
    dic[@"cardNum"] = tempCardNumberStr;
    if (self.m_swiftIdStr.length > 0) {
        dic[@"swiftId"] = self.m_swiftIdStr;
    }
    
    NSMutableDictionary *healder = [[NSMutableDictionary alloc]init];
    
    
    healder[@"traceId"] = [[NSUUID UUID] UUIDString];
    healder[@"parentId"] = [[NSUUID UUID] UUIDString];
    
    //网络监控开始时间戳和时间
    NSUInteger startMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
    NSString *startTime = [AppGlobal getCurrentTime];
    
     [[QYNetManager requestManagerHeader:healder baseUrl:myBaseUrl] post:url params:dic success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            [self addBankCardSucceeded:responseObject];
        } else {
            [self addBankCardFaile:responseObject];
        }
        [self dismissLoading];
         //接口监控
         NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
         NSString *endTime = [AppGlobal getCurrentTime];
         NSUInteger period = endMillSeconds - startMillSeconds;
         NSString *periods = [NSString stringWithFormat:@"%tu", period];
         
         [[KYMonitorManage sharedInstance] upLoadDataWithPhone:[self queryInfo].phoneNum andStatus:@"200" andArguments:dic andResult:responseObject andMethodName: NSStringFromSelector(_cmd) andClazz:NSStringFromClass([self class]) andBusiness:@"qyfq_app_new_bankAdd" andBusinessAlias:@"添加银行卡" andServiceStart:startTime andServiceEnd:endTime andElapsed:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    } failure:^(NSString * _Nullable errorString) {
        [self dismissLoading];
        [self showMessageWithString:kShowErrorMessage];
        //网络监控结束时间戳和时间
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        [self monitorReq:@"500" param:dic msg:errorString methodName:NSStringFromSelector(_cmd) className:NSStringFromClass([self class]) buName:@"qyfq_app_new_bankAdd" buAlias:@"添加银行卡" statTime:startTime endTime:endTime period:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    }];
}

/**
 成功
 
 @param responseObject responseObject description
 */
- (void)addBankCardSucceeded:(id)responseObject {
    NSString *tempCardTypeStr = @"0";
    if ([self.m_bankTypeStr isEqualToString:@"1"]) {
        tempCardTypeStr = @"0";
    }
    if ([self.m_bankTypeStr isEqualToString:@"2"]) {
        tempCardTypeStr = @"1";
    }
    
    NSString* tempCardNumberStr =  [AppGlobal repleaceBlankWithString:self.m_cardNumberTextField.text];
    UserInfo *info = [self queryInfo];
    QYBankCardModel *bankCardModel = [[QYBankCardModel alloc]init];
    bankCardModel.ssoId = info.token;
    bankCardModel.bankName = self.m_bankNameStr;
    bankCardModel.cardNum = tempCardNumberStr;
    bankCardModel.cardType = tempCardTypeStr;
    NSMutableArray *array = [NSMutableArray arrayWithArray:info.bankCards];
    [array addObject:bankCardModel];
    info.bankCards = array;
    [self updateInfo:info];
    
    //goto main
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 失败
 
 @param responseObject responseObject description
 */
- (void)addBankCardFaile:(id)responseObject {
    if ([responseObject objectForKey:@"message"]) {
        [self showMessageWithString:[responseObject objectForKey:@"message"]];
    }
}


/**
 获取银行列表
 */
-(void)getBankCardList {
    [self showLoading];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",app_new_getBanks,verison];
    
    NSMutableDictionary *healder = [[NSMutableDictionary alloc]init];
    
    
    healder[@"traceId"] = [[NSUUID UUID] UUIDString];
    healder[@"parentId"] = [[NSUUID UUID] UUIDString];
    
    //网络监控开始时间戳和时间
    NSUInteger startMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
    NSString *startTime = [AppGlobal getCurrentTime];
    
     [[QYNetManager requestManagerHeader:healder baseUrl:myBaseUrl] get:url params:nil success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            [self getBankCardListSucceeded:responseObject];
        } else {
            [self getBankCardListFaile:responseObject];
        }
        [self dismissLoading];
         //接口监控
         NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
         NSString *endTime = [AppGlobal getCurrentTime];
         NSUInteger period = endMillSeconds - startMillSeconds;
         NSString *periods = [NSString stringWithFormat:@"%tu", period];
         
         [[KYMonitorManage sharedInstance] upLoadDataWithPhone:[self queryInfo].phoneNum andStatus:@"200" andArguments:nil andResult:responseObject andMethodName: NSStringFromSelector(_cmd) andClazz:NSStringFromClass([self class]) andBusiness:@"qyfq_app_new_getBanks" andBusinessAlias:@"查询银行列表" andServiceStart:startTime andServiceEnd:endTime andElapsed:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    } failure:^(NSString * _Nullable errorString) {
        [self dismissLoading];
        [self showMessageWithString:kShowErrorMessage];
        //网络监控结束时间戳和时间
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        [self monitorReq:@"500" param:nil msg:errorString methodName:NSStringFromSelector(_cmd) className:NSStringFromClass([self class]) buName:@"qyfq_app_new_getBanks" buAlias:@"查询银行列表" statTime:startTime endTime:endTime period:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
        
    }];
}

/**
 成功
 
 @param responseObject responseObject description
 */
- (void)getBankCardListSucceeded:(id)responseObject {
    
    if([responseObject isKindOfClass:NSDictionary.class]){
        //selected bank
        QYSelectedBankVC *vc = [[UIStoryboard storyboardWithName:@"QYHomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"QYSelectedBankVC"];
        vc.s_bankArray =  [responseObject valueForKey:@"data"];
        vc.selectedDelegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}


/**
 失败
 
 @param responseObject responseObject description
 */
- (void)getBankCardListFaile:(id)responseObject {
    if ([responseObject objectForKey:@"message"]) {
        [self showMessageWithString:[responseObject objectForKey:@"message"]];
    }
}

#pragma mark- 图片上传
-(void)uploadFile{
    [self showLoading];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",app_new_uploadFile,verison];

    
    NSMutableDictionary *healder = [[NSMutableDictionary alloc]init];
    
    
    healder[@"traceId"] = [[NSUUID UUID] UUIDString];
    healder[@"parentId"] = [[NSUUID UUID] UUIDString];
    
    //网络监控开始时间戳和时间
    NSUInteger startMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
    NSString *startTime = [AppGlobal getCurrentTime];
    
     [[QYNetManager requestManagerHeader:healder baseUrl:myBaseUrl] uploadImage:self.m_bankCardImage withUrl:myBaseUrl withPicUrl:urlStr andParameters:nil success:^(NSString * _Nullable imageIDString) {

        self.m_swiftIdStr = [[imageIDString valueForKey:@"data"] valueForKey:@"fileId"];

        [self dismissLoading];

        //add bankCard
        [self addBankCard];
       //接口监控
          NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
          NSString *endTime = [AppGlobal getCurrentTime];
          NSUInteger period = startMillSeconds - startMillSeconds;
          NSString *periods = [NSString stringWithFormat:@"%tu", period];
          
          [[KYMonitorManage sharedInstance] upLoadDataWithPhone:[self queryInfo].phoneNum andStatus:@"200" andArguments:nil andResult:nil andMethodName: NSStringFromSelector(_cmd) andClazz:NSStringFromClass([self class]) andBusiness:@"qyfq_app_new_uploadFile" andBusinessAlias:@"文件上传" andServiceStart:startTime andServiceEnd:endTime andElapsed:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]]; 
    } failure:^(NSURLSessionDataTask * _Nullable task, NSString * _Nullable errorString) {
        [self dismissLoading];
        //网络监控结束时间戳和时间
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        [self monitorReq:@"500" param:nil msg:errorString methodName:NSStringFromSelector(_cmd) className:NSStringFromClass([self class]) buName:@"qyfq_app_new_uploadFile" buAlias:@"文件上传" statTime:startTime endTime:endTime period:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
        //add bankCard
        [self addBankCard];
        
    }];
}

@end
