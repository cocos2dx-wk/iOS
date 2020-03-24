//
//  QYConfirmIdCardVC.m
//  QYStaging
//
//  Created by wangkai on 2017/4/13.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYConfirmIdCardVC.h"
#import "QYCreditEvaluationMainVC.h"

@interface QYConfirmIdCardVC ()<UITextFieldDelegate>

/* 姓名*/
@property (weak, nonatomic) IBOutlet UITextField *m_nameTextField;
/* 身份证*/
@property (weak, nonatomic) IBOutlet UITextField *m_idCardTextField;
/* 下一步按钮*/
@property (weak, nonatomic) IBOutlet UIButton *m_nextButton;
/* 人脸识别最优图片*/
@property (strong, nonatomic) UIImage *m_faceImg;

@end

@implementation QYConfirmIdCardVC

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
    self.navigationItem.title = @"确认身份信息";
}

/**
 * 返回
 */
- (void)goBack:(UIButton *)sender{
    //goto main
    for (UIViewController *controller in self.navigationController
         .viewControllers) {
        if ([controller isKindOfClass:QYCreditEvaluationMainVC.class]) {
            QYCreditEvaluationMainVC *vc = (QYCreditEvaluationMainVC *)controller;
            [self.navigationController popToViewController:vc animated:true];
            break;
        }
    }
}

/**
 初始化ui
 */
-(void)initUI{

    [AppGlobal setGrayBtn:self.m_nextButton];
    
    //restore keyboard response
    UITapGestureRecognizer *singleOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(becomeResponder:)];
    singleOne.numberOfTouchesRequired = 1;
    singleOne.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleOne];
    
    //set delegate
    self.m_nameTextField.delegate = self;
    self.m_idCardTextField.delegate = self;
    [self.m_nameTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    [self.m_idCardTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    
    //set model
    self.m_nameTextField.text = self.s_cardInfoModel.name;
    self.m_idCardTextField.text = [AppGlobal newgetFormateIdCard:self.s_cardInfoModel.id_card_number];
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
 *  校验按钮状态
 */
- (void)checkBtnStatus {
    
    NSString* tempIdCardStr =  [AppGlobal repleaceBlankWithString:self.m_idCardTextField.text];
    if (self.m_nameTextField.text.length > 0 && tempIdCardStr.length > 0) {
        [AppGlobal setResetBtn:self.m_nextButton];
    }else{
        [AppGlobal setGrayBtn:self.m_nextButton];
    }
}

/**
 点击下一步

 @param sender sender description
 */
- (IBAction)onNextClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    [self.view endEditing:YES];
    
    //check name
    if (self.m_nameTextField.text.length > 16 || !self.m_nameTextField.text.checkingChineseName) {
        [self showMessageWithString:@"姓名格式错误，请重新输入"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                     (int64_t)(kShowMessageTime * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           [self.m_nameTextField becomeFirstResponder];
                       });
        sender.enabled = YES;
        return;
    }
    
    //check id card
    NSString* tempIdCardStr =  [AppGlobal repleaceBlankWithString:self.m_idCardTextField.text];
    if (tempIdCardStr.length < 15 || tempIdCardStr.length > 18) {
        [self showMessageWithString:@"身份证号码应为15或18位字符"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                     (int64_t)(kShowMessageTime * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           [self.m_idCardTextField becomeFirstResponder];
                       });
        sender.enabled = YES;
        return;
    }else if (![[AppGlobal repleaceBlankWithString:self.m_idCardTextField.text] checkingIdentityCard]) {
        [self showMessageWithString:@"身份证号码格式错误，请核对"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                     (int64_t)(kShowMessageTime * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           [self.m_idCardTextField becomeFirstResponder];
                       });
        sender.enabled = YES;
        return;
    }
    
    //启用授权
    [MGLicenseManager licenseForNetWokrFinish:^(bool License) {
        if (License) {
            DLog(@"授权成功");
        }else{
            DLog(@"授权失败");
        }
        
        //活体检测
        if (![MGLiveManager getLicense]) {
            DLog(@"SDK授权失败，请检查");
            sender.enabled = YES;
            return;
        }
        
        MGLiveManager *manager = [[MGLiveManager alloc] init];
        manager.detectionWithMovier = NO;
        manager.actionCount = 3;
        
        [manager startFaceDecetionViewController:self finish:^(FaceIDData *finishDic, UIViewController *viewController) {
            [viewController dismissViewControllerAnimated:YES completion:nil];
            
            NSData *header = [[finishDic images] valueForKey:@"image_best"];
            self.m_faceImg = [UIImage imageWithData:header];
            
            //活体检测成功后人脸识别
            [self faceRecognition];
            
        } error:^(MGLivenessDetectionFailedType errorType, UIViewController *viewController) {
            [viewController dismissViewControllerAnimated:YES completion:nil];
            
            [self showErrorString:errorType];
        }];
    }];
    
    sender.enabled = YES;
}

/**
 *  失去键盘响应
 */
-(void)becomeResponder:(id)sender {
    [self.m_nameTextField resignFirstResponder];
    [self.m_idCardTextField resignFirstResponder];
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
    if (self.m_nameTextField == textField) {
        if ([toBeString length] > 16) {
            textField.text = [toBeString substringToIndex:16];
            
            return NO;
        }
        if ([toBeString isEqualToString:@"·"]) {
            return NO;
        }
        if ([string isEqualToString:@"."]) {
            return NO;
        }
    }
    if (self.m_idCardTextField == textField) {
        NSString *tempStr = toBeString;
        tempStr = [AppGlobal repleaceBlankWithString:toBeString];
        if ([tempStr length] > 18) {
            textField.text = [tempStr substringToIndex:18];
            
            return NO;
        }
    }

    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.m_idCardTextField && self.m_idCardTextField.text.length >= 15) {
        self.m_idCardTextField.text = [AppGlobal newgetFormateIdCard:self.m_idCardTextField.text];
    }
    
    if (self.m_idCardTextField.text.length > 0 && self.m_nameTextField.text.length > 0) {
        [AppGlobal setResetBtn:self.m_nextButton];
    }
}

- (void)showErrorString:(MGLivenessDetectionFailedType)errorType{
    switch (errorType) {
        case DETECTION_FAILED_TYPE_ACTIONBLEND:
        {
            [self showMessageWithString:@"    活体检测未成功\n请按照提示完成动作"];
        }
            break;
        case DETECTION_FAILED_TYPE_NOTVIDEO:
        {
            [self showMessageWithString:@"活体检测未成功"];
        }
            break;
        case DETECTION_FAILED_TYPE_TIMEOUT:
        {
            [self showMessageWithString:@"    活体检测未成功\n请在规定时间内完成动作"];
        }
            break;
        default:
        {
            [self showMessageWithString:@"检测失败"];
        }
            break;
    }
}

/**
 实名认证
 */
-(void)personalAuthAfterCheck {
    [self showLoading];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *frontSwiftId = [defaults objectForKey:@"frontSwiftId"];
    NSString *backSwiftId = [defaults objectForKey:@"backSwiftId"];
    
    NSString* tempIdCardStr =  [AppGlobal repleaceBlankWithString:self.m_idCardTextField.text];
    NSString *url = [NSString stringWithFormat:@"%@%@",app_new_toauth,verison];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"token"] = [self queryInfo].token;
    dic[@"name"] = self.m_nameTextField.text;
    dic[@"identity"] = tempIdCardStr;
    dic[@"obverseId"] = frontSwiftId;//正面
    dic[@"reverseId"] = backSwiftId;//反面
    
    
    NSMutableDictionary *healder = [[NSMutableDictionary alloc]init];
    
    
    healder[@"traceId"] = [[NSUUID UUID] UUIDString];
    healder[@"parentId"] = [[NSUUID UUID] UUIDString];
    
    //网络监控开始时间戳和时间
    NSUInteger startMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
    NSString *startTime = [AppGlobal getCurrentTime];
    
    
    
    
    [[QYNetManager requestManagerHeader:healder baseUrl:myBaseUrl] post:url params:dic success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            [self personalAuthAfterCheckSucceeded:responseObject];
        } else {
            [self personalAuthAfterCheckFaile:responseObject];
        }
        [self dismissLoading];
        //接口监控
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        
        [[KYMonitorManage sharedInstance] upLoadDataWithPhone:[self queryInfo].phoneNum andStatus:@"200" andArguments:dic andResult:responseObject andMethodName: NSStringFromSelector(_cmd) andClazz:NSStringFromClass([self class]) andBusiness:@"qyfq_app_new_toauth" andBusinessAlias:@"实名认证接口" andServiceStart:startTime andServiceEnd:endTime andElapsed:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    } failure:^(NSString * _Nullable errorString) {
        [self dismissLoading];
        [self showMessageWithString:kShowErrorMessage];
        //网络监控结束时间戳和时间
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        [self monitorReq:@"500" param:dic msg:errorString methodName:NSStringFromSelector(_cmd) className:NSStringFromClass([self class]) buName:@"qyfq_app_new_toauth" buAlias:@"实名认证接口" statTime:startTime endTime:endTime period:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    }];
}


/**
 实名认证成功
 
 @param responseObject responseObject description
 */
- (void)personalAuthAfterCheckSucceeded:(id)responseObject {
    [self showMessageWithString:@"身份信息认证成功" imageName:@"Common_correct"];

    //goto main
    for (UIViewController *controller in self.navigationController
         .viewControllers) {
        if ([controller isKindOfClass:QYCreditEvaluationMainVC.class]) {
            NSString* tempIdCardStr =  [AppGlobal repleaceBlankWithString:self.m_idCardTextField.text];
            UserInfo *info = [self queryInfo];
            info.isAuth = @"1";
             info.personfullname = self.m_nameTextField.text;
            info.personIdCardCode = tempIdCardStr;
            [self updateInfo:info];
            QYCreditEvaluationMainVC *vc = (QYCreditEvaluationMainVC *)controller;
            [self.navigationController popToViewController:vc animated:true];
            break;
        }
    }
}


/**
 实名认证失败
 
 @param responseObject responseObject description
 */
- (void)personalAuthAfterCheckFaile:(id)responseObject {
    if ([responseObject objectForKey:@"message"]) {
        [self showMessageWithString:[responseObject objectForKey:@"message"]];
    }
}

/**
 人脸识别
 */
-(void)faceRecognition {

    [self showLoading];
    NSString* tempIdCardStr =  [AppGlobal repleaceBlankWithString:self.m_idCardTextField.text];
    NSString* name = [self.m_nameTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?idCardName=%@&idCardNo=%@",app_new_faceRecognition,verison,name,tempIdCardStr];
    
    NSMutableDictionary *healder = [[NSMutableDictionary alloc]init];
    
    
    healder[@"traceId"] = [[NSUUID UUID] UUIDString];
    healder[@"parentId"] = [[NSUUID UUID] UUIDString];
    
    //网络监控开始时间戳和时间
    NSUInteger startMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
    NSString *startTime = [AppGlobal getCurrentTime];
    
    
     [[QYNetManager requestManagerHeader:healder baseUrl:myBaseUrl] uploadImage:self.m_faceImg withUrl:myBaseUrl withPicUrl:urlStr andParameters:nil success:^(NSString * _Nullable imageIDString) {
        
        //人脸成功后实名认证
        [self personalAuthAfterCheck];
         //接口监控
         NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
         NSString *endTime = [AppGlobal getCurrentTime];
         NSUInteger period = endMillSeconds - startMillSeconds;
         NSString *periods = [NSString stringWithFormat:@"%tu", period];
         
         [[KYMonitorManage sharedInstance] upLoadDataWithPhone:[self queryInfo].phoneNum andStatus:@"200" andArguments:nil andResult:nil andMethodName: NSStringFromSelector(_cmd) andClazz:NSStringFromClass([self class]) andBusiness:@"qyfq_app_new_faceRecognition" andBusinessAlias:@"人脸识别" andServiceStart:startTime andServiceEnd:endTime andElapsed:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSString * _Nullable errorString) {
        [self dismissLoading];
        
        [self showMessageWithString:errorString];
        //网络监控结束时间戳和时间
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        [self monitorReq:@"500" param:nil msg:errorString methodName:NSStringFromSelector(_cmd) className:NSStringFromClass([self class]) buName:@"qyfq_app_new_faceRecognition" buAlias:@"人脸识别" statTime:startTime endTime:endTime period:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    }];
}

@end
