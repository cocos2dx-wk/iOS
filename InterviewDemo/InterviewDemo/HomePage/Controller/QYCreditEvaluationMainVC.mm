//
//  QYCreditEvaluationMainVC.m
//  QYStaging
//
//  Created by wangkai on 2017/4/7.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYCreditEvaluationMainVC.h"
#import "QYCreditBankCardCell.h"
#import "QYCreditEvaluationWorkVC.h"
#import "QYCommonPickerView.h"
#import "QYLocationPickerView.h"
#import "QYAddBankCardVC.h"
#import "QYSelectedIdCardVC.h"
#import "QYConfirmIdCardVC.h"
#import "QYWebViewVC.h"
#import "QYRegisterSuccessVC.h"


@interface QYCreditEvaluationMainVC ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,CLLocationManagerDelegate>

/* 滚动页面*/
@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;
/* 背景高度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_bgViewHeightConstraint;
/* 选中点*/
@property (weak, nonatomic) IBOutlet UIImageView *m_selectedCircleImg;
/* 下一步*/
@property (weak, nonatomic) IBOutlet UIButton *m_nextButton;

/* ----------------身份证信息------------*/
/* 已认证身份证view*/
@property (weak, nonatomic) IBOutlet UIView *m_correctView;
/* 名字和身份证号码*/
@property (weak, nonatomic) IBOutlet UILabel *m_nameAndIdCardLabel;
/* 适配*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_toLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_toRightConstraint;
/* 活体检测view*/
@property (weak, nonatomic) IBOutlet UIView *m_detectionView;
/* 人脸识别最优图片*/
@property (strong, nonatomic) UIImage *m_faceImg;
/* 是否面部识别0：未认证 1：已认证*/
@property (nonatomic,copy)NSString *m_isFaceAuthStr;
/* 是否上传过身份证照片 */
@property (nonatomic,copy)NSString *m_isHaveIdCardPhoto;
/* 审核状态 */
@property (nonatomic,copy) NSString *isAuditStatus;
/* 身份证icon*/
@property (weak, nonatomic) IBOutlet UIImageView *m_idCardIconImg;

/* ----------------个人信息------------*/
/* 是否已婚*/
@property (weak, nonatomic) IBOutlet UITextField *m_marriageTextField;
/* 学历*/
@property (weak, nonatomic) IBOutlet UITextField *m_educationTextField;
/* 学历信息*/
@property (strong, nonatomic) NSMutableArray *m_educationArray;
/* 所在城市*/
@property (weak, nonatomic) IBOutlet UITextField *m_cityTextField;
/* 详细地址*/
@property (weak, nonatomic) IBOutlet UITextField *m_detailLocationTextField;
/* 省*/
@property (copy, nonatomic) NSString *m_privinceStr;
/* 市*/
@property (copy, nonatomic) NSString *m_cityStr;
/* 区*/
@property (copy, nonatomic) NSString *m_districtStr;

/* ----------------银行卡信息------------*/
/* 银行卡信息高度 无卡高度100*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_bankInfoHeightConstraint;
/* 银行卡列表高度 一行84 改为50*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_bankListHeightConstraint;
/* 身份认证后才可添加银行卡 */
@property (weak, nonatomic) IBOutlet UILabel *m_bankInfoLabel;
/* 绑定银行卡 */
@property (weak, nonatomic) IBOutlet UIButton *m_selectedBankButton;
/* 银行卡列表  */
@property (weak, nonatomic) IBOutlet UITableView *m_bankCardtableView;
/* 银行卡数组  */
@property (nonatomic,strong)NSMutableArray *m_bankArray;
/* 5张银行卡隐藏该view 高度：45  */
@property (weak, nonatomic) IBOutlet UIView *m_bankDesc1View;
/* 5张银行卡隐藏该view 高度：58  */
@property (weak, nonatomic) IBOutlet UIView *m_bankDesc2View;
/* 银行卡描述  */
@property (weak, nonatomic) IBOutlet UILabel *m_bankDescLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_bankDescConstraint;

/** 地图管理器 */
@property(nonatomic,strong)CLLocationManager *locMgr;
/** 纬度 */
@property(nonatomic, assign) CLLocationDegrees latitude;
/** 经度 */
@property(nonatomic, assign) CLLocationDegrees longitude;
/* 定位获取的省 */
@property (copy, nonatomic) NSString *privinceStr;
/* 定位获取的市 */
@property (copy, nonatomic) NSString *cityStr;
/* 定位获取的区 */
@property (copy, nonatomic) NSString *districtStr;
/** 设置定位次数 */
@property (nonatomic,assign) BOOL exist;
// 根据权限设置定位
@property (nonatomic,assign) BOOL isLocation;


@end

@implementation QYCreditEvaluationMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLocation];
    
    [self.leftButton setAccessibilityIdentifier:@"rl_back_layout"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //set nav color
    self.navigationItem.title = @"信用评估";
     self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    //init UI
    [self initUI];
    if (self.m_bankCardtableView) {
        [self.m_bankCardtableView reloadData];
    }
    
    //是否活体检测
    self.m_detectionView.hidden = YES;
    [self faceAuthCheck];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 懒加载
- (CLLocationManager *)locMgr {
    if (_locMgr == nil) {
        _locMgr = [[CLLocationManager alloc]init];
        _locMgr.delegate = self;
    }
    return _locMgr;
}

#pragma mark - 私有方法
- (void)initUI {
    //set adapter
    if (iphone5 || iphone4s) {
        self.m_toLeftConstraint.constant = -10;
        self.m_toRightConstraint.constant = 10;
        self.m_bankDescLabel.font = [UIFont systemFontOfSize:12];
        self.m_bankDescConstraint.constant = 5;
    }
    
    //set bankInfo
    [AppGlobal setGrayBtn:self.m_nextButton];
    self.m_bankArray = [NSMutableArray array];
    self.m_bankInfoHeightConstraint.constant = 100;
    self.m_bankListHeightConstraint.constant = 0;
    self.m_bankCardtableView.dataSource = self;
    self.m_bankCardtableView.delegate = self;
    [self.m_bankCardtableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    UserInfo *info = [self queryInfo];
    self.m_bankArray = info.bankCards;
    if (self.m_bankArray.count > 0) {
        self.m_bankListHeightConstraint.constant = [self getListHeight];
        self.m_bankInfoHeightConstraint.constant = 100 + self.m_bankListHeightConstraint.constant;
    }
    
    //set personal info
    self.m_educationArray = [NSMutableArray arrayWithObjects:@"小学",@"初中",@"中技",@"高中",@"中专",@"大专",@"本科",@"硕士",@"MBA",@"EMBA",@"博士 ",@"其他", nil];
    self.m_detailLocationTextField.delegate = self;
    if (info.user.address.length > 0) {
        self.m_detailLocationTextField.text = info.user.address;
    }
    if (info.user.married.length > 0) {
        self.m_marriageTextField.text = [info.user.married isEqualToString:@"1"] ? @"已婚" : @"未婚";
    }
    if (info.user.education.length > 0) {
        self.m_educationTextField.text = [self getEducationWithType:info.user.education];
    }
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@",info.user.province,info.user.city?info.user.city:@"",info.user.district?info.user.district:@""];
    self.m_cityTextField.text = info.user.province ? tempStr : @"";
    if (self.m_cityTextField.text.length <= 0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSString stringWithFormat:@"%d",0] forKey:@"_provinceIndex"];
        [defaults setObject:[NSString stringWithFormat:@"%d",0] forKey:@"_cityIndex"];
        [defaults setObject:[NSString stringWithFormat:@"%d",0] forKey:@"_districtIndex"];
        [defaults synchronize];
    }else{
        self.m_privinceStr = info.user.province;
        self.m_cityStr = info.user.city;
        self.m_districtStr = info.user.district;
    }
    self.m_correctView.hidden = YES;
    self.m_bankInfoLabel.hidden = NO;
    self.m_idCardIconImg.image = [UIImage imageNamed:@"HomePage_idCardIconNormal"];
    if ([info.isAuth isEqualToString:@"1"]) {
        self.m_idCardIconImg.image = [UIImage imageNamed:@"HomePage_idCardIconSelected"];
        self.m_correctView.hidden = NO;
        self.m_bankInfoLabel.hidden = YES;
        NSString *idCardStr = [AppGlobal repleaceBlankWithString:[self queryInfo].personIdCardCode];
        NSInteger count = idCardStr.length;
        if (count > 0) {
            NSString *centerStr = @"****";
            NSString *tempStr = [idCardStr stringByReplacingCharactersInRange:NSMakeRange (1, count - 2) withString:centerStr];
            self.m_nameAndIdCardLabel.text = [NSString stringWithFormat:@"%@/%@",info.personfullname,tempStr];
        }
    }
    float defaultF = 612;
    if (self.m_bankArray.count >= 5) {
        self.m_bankDesc1View.hidden = YES;
        self.m_bankDesc2View.hidden = YES;
        float tempHeight = self.m_bankInfoHeightConstraint.constant;
        self.m_bankInfoHeightConstraint.constant = tempHeight - 45 - 58;
        self.m_bgViewHeightConstraint.constant = defaultF + [self getListHeight] - 100;
    }else{
        self.m_bgViewHeightConstraint.constant = defaultF + [self getListHeight];
    }
    [self.m_detailLocationTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    
    //set scrollview
    self.m_scrollView.showsVerticalScrollIndicator = FALSE;
    [self.m_scrollView setContentSize:CGSizeMake(appWidth, defaultF + [self getListHeight])];
    [self setScrollEnable];
    
    //restore keyboard response
    UITapGestureRecognizer *singleOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(becomeResponder:)];
    singleOne.numberOfTouchesRequired = 1;
    singleOne.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleOne];
    
    //check status
    [self checkBtnStatus];
}

#pragma mark- location
- (void)setLocation {
    
    if ([AppGlobal getLocationServicesEnabled] == 0) {
        self.isLocation = YES;
    } else if ([AppGlobal getLocationServicesEnabled] == 2) {
        self.isLocation = YES;
        [self.locMgr requestWhenInUseAuthorization];
    } else {
        self.isLocation = NO;
        [self.locMgr startUpdatingLocation];
        self.locMgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    }
}

/**
 监听输入框
 */
- (void)textFieldWithText:(UITextField *)textField {
    [self checkBtnStatus];
}

/**
 *  校验按钮状态
 */
- (void)checkBtnStatus {
    
    if (self.m_marriageTextField.text.length > 0 && self.m_educationTextField.text.length > 0 && self.m_bankArray.count > 0 && self.m_cityTextField.text.length > 0 && self.m_detailLocationTextField.text.length > 0 && [self.m_isFaceAuthStr isEqualToString:@"1"]) {
        [AppGlobal setResetBtn:self.m_nextButton];
    }else{
        [AppGlobal setGrayBtn:self.m_nextButton];
    }
}

/**
 设置可滚动
 */
- (void)setScrollEnable {
    
    //默认612 无添加银行卡
    float defaultF = 612;
    float listHeight = [self getListHeight];//列表高度
    float total = defaultF + listHeight;
    if (total > appHeight) {
        self.m_scrollView.scrollEnabled = YES;
    }else{
        self.m_scrollView.scrollEnabled = NO;
    }
    if (self.m_bankArray.count > 0) {
        self.m_scrollView.scrollEnabled = YES;
    }
    
}

/**
 返回银行卡列表高度
 */
- (float)getListHeight {
    float height = 0;
    
    //每行高度84,现在50
    UserInfo *info = [self queryInfo];
    self.m_bankArray = info.bankCards;
    if (self.m_bankArray.count > 0) {
        height = 50 * self.m_bankArray.count;
    }
    
    return height;
}

/**
 *  失去键盘响应
 */
- (void)becomeResponder:(id)sender {
    [self.m_detailLocationTextField resignFirstResponder];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

/**
 alert 字体颜色
 */
- (void)addActionTarget:(UIAlertController *)alertController title:(NSString *)title color:(UIColor *)color action:(void(^)(UIAlertAction *action))actionTarget {
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        actionTarget(action);
    }];
    if (IOS_VERSION >= 9.0) {
        [action setValue:color forKey:@"_titleTextColor"];
    }
    
    [alertController addAction:action];
}

/**
 alert 取消重写
 */
- (void)addCancelActionTarget:(UIAlertController*)alertController title:(NSString *)title {
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    if (IOS_VERSION >= 9.0) {
        [action setValue:[UIColor colorWithHexString:@"575DFE"] forKey:@"_titleTextColor"];
    }
    
    [alertController addAction:action];
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
 学历，0：小学、1：初中、2、中计、3：高中、4：中专、5：大专、6：本科、7：硕士、8：MBA、9：EMBA、10：博士、11：其他
 @return 学历
 */
- (NSString *)getEducationWithType:(NSString *)typeStr {
    NSString *tempStr = @"";
    if ([typeStr isEqualToString:@"0"]) {
        tempStr = @"小学";
    }else if([typeStr isEqualToString:@"1"]){
        tempStr = @"初中";
    }else if([typeStr isEqualToString:@"2"]){
        tempStr = @"中技";
    }else if([typeStr isEqualToString:@"3"]){
        tempStr = @"高中";
    }else if([typeStr isEqualToString:@"4"]){
        tempStr = @"中专";
    }else if([typeStr isEqualToString:@"5"]){
        tempStr = @"大专";
    }else if([typeStr isEqualToString:@"6"]){
        tempStr = @"本科";
    }else if([typeStr isEqualToString:@"7"]){
        tempStr = @"硕士";
    }else if([typeStr isEqualToString:@"8"]){
        tempStr = @"MBA";
    }else if([typeStr isEqualToString:@"9"]){
        tempStr = @"EMBA";
    }else if([typeStr isEqualToString:@"10"]){
        tempStr = @"博士";
    }else if([typeStr isEqualToString:@"11"]){
        tempStr = @"其他";
    }
    
    
    return tempStr;
}

/**
 默认选中学历
 */
- (NSInteger)getIndexWithEducationLabel:(NSString *)tempStr {
    NSInteger index = 0;
    if (tempStr.length <= 0) {
        index = 0;
    }
    
    if ([tempStr isEqualToString:@"小学"]) {
        index = 0;
    }else if ([tempStr isEqualToString:@"初中"]){
        index = 1;
    }else if ([tempStr isEqualToString:@"中技"]){
        index = 2;
    }else if ([tempStr isEqualToString:@"高中"]){
        index = 3;
    }else if ([tempStr isEqualToString:@"中专"]){
        index = 4;
    }else if ([tempStr isEqualToString:@"大专"]){
        index = 5;
    }else if ([tempStr isEqualToString:@"本科"]){
        index = 6;
    }else if ([tempStr isEqualToString:@"硕士"]){
        index = 7;
    }else if ([tempStr isEqualToString:@"MBA"]){
        index = 8;
    }else if ([tempStr isEqualToString:@"EMBA"]){
        index = 9;
    }else if ([tempStr isEqualToString:@"博士"]){
        index = 10;
    }else if ([tempStr isEqualToString:@"其他"]){
        index = 11;
    }
    
    return index;
}

#pragma mark - 按钮活动
/**
 身份证点击识别
 */
- (IBAction)onIdCardClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    //update userInfo
    NSString *tempMarriageStr = @"0";
    if ([self.m_marriageTextField.text isEqualToString:@"已婚"]) {
        tempMarriageStr = @"1";
    }else if ([self.m_marriageTextField.text isEqualToString:@"未婚"]) {
        tempMarriageStr = @"0";
    }else if (self.m_marriageTextField.text.length <= 0) {
        tempMarriageStr = @"";
    }
    UserInfo *info = [self queryInfo];
    QYResumeModel *userModel = [[QYResumeModel alloc]init];
    userModel.married = tempMarriageStr;
    if (self.m_educationTextField.text.length > 0) {
        userModel.education = [NSString stringWithFormat:@"%ld",(long)[self getIndexWithEducationLabel:self.m_educationTextField.text]];
    }
    userModel.province = self.m_privinceStr;
    userModel.city = self.m_cityStr;
    userModel.district = self.m_districtStr;
    userModel.address = self.m_detailLocationTextField.text;
    info.user = userModel;
    info.bankCards = self.m_bankArray;
    [self updateInfo:info];
    
    //scan idcard
    QYSelectedIdCardVC *vc = [[UIStoryboard storyboardWithName:@"QYHomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"QYSelectedIdCardVC"];
    [self.navigationController pushViewController:vc animated:YES];
    
    sender.enabled = YES;
}

/**
 去活体检测
 */
- (IBAction)m_detectionClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    if ([self.m_isHaveIdCardPhoto isEqualToString:@"0"]) {
        
        //update userInfo
        NSString *tempMarriageStr = @"0";
        if ([self.m_marriageTextField.text isEqualToString:@"已婚"]) {
            tempMarriageStr = @"1";
        }else if ([self.m_marriageTextField.text isEqualToString:@"未婚"]) {
            tempMarriageStr = @"0";
        }else if (self.m_marriageTextField.text.length <= 0) {
            tempMarriageStr = @"";
        }
        UserInfo *info = [self queryInfo];
        QYResumeModel *userModel = [[QYResumeModel alloc]init];
        userModel.married = tempMarriageStr;
        if (self.m_educationTextField.text.length > 0) {
            userModel.education = [NSString stringWithFormat:@"%ld",(long)[self getIndexWithEducationLabel:self.m_educationTextField.text]];
        }
        userModel.province = self.m_privinceStr;
        userModel.city = self.m_cityStr;
        userModel.district = self.m_districtStr;
        userModel.address = self.m_detailLocationTextField.text;
        info.user = userModel;
        info.bankCards = self.m_bankArray;
        [self updateInfo:info];
        //scan idcard
        QYSelectedIdCardVC *vc = [[UIStoryboard storyboardWithName:@"QYHomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"QYSelectedIdCardVC"];
        if ([self.m_isFaceAuthStr isEqualToString:@"0"]) {
            vc.photoOrFace = @"photoAndFace";
        } else if ([self.m_isFaceAuthStr isEqualToString:@"1"] && ([self.isAuditStatus isEqualToString:@"3"] || [self.isAuditStatus isEqualToString:@"0"])) {
            vc.photoOrFace = @"photo";
        }
        vc.auditStatus = self.isAuditStatus;
        [self.navigationController pushViewController:vc animated:YES];
        
        sender.enabled = YES;
        return;
    }
    
    // 是否开启相机
    if ([AppGlobal isCameraPermissions]) {
        //update userInfo
        NSString *tempMarriageStr = @"0";
        if ([self.m_marriageTextField.text isEqualToString:@"已婚"]) {
            tempMarriageStr = @"1";
        }else if ([self.m_marriageTextField.text isEqualToString:@"未婚"]) {
            tempMarriageStr = @"0";
        }else if (self.m_marriageTextField.text.length <= 0) {
            tempMarriageStr = @"";
        }
        UserInfo *info = [self queryInfo];
        QYResumeModel *userModel = [[QYResumeModel alloc]init];
        userModel.married = tempMarriageStr;
        if (self.m_educationTextField.text.length > 0) {
            userModel.education = [NSString stringWithFormat:@"%ld",(long)[self getIndexWithEducationLabel:self.m_educationTextField.text]];
        }
        userModel.province = self.m_privinceStr;
        userModel.city = self.m_cityStr;
        userModel.district = self.m_districtStr;
        userModel.address = self.m_detailLocationTextField.text;
        info.user = userModel;
        info.bankCards = self.m_bankArray;
        [self updateInfo:info];
        
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
    } else {
        [AppGlobal openCameraPermissions];
    }
    
    sender.enabled = YES;
}

/**
 婚姻状况
 */
- (IBAction)onMarriageClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    [self.m_detailLocationTextField resignFirstResponder];
    
    if (IOS_VERSION > 8) {
        UIColor *color1 = [UIColor colorWithHexString:@"4c4c4c"];
        UIColor *color2 = [UIColor colorWithHexString:@"4c4c4c"];
        if ([self.m_marriageTextField.text isEqualToString:@"已婚"]) {
            color1 = [UIColor colorWithHexString:@"fe6b6b"];
        }
        if ([self.m_marriageTextField.text isEqualToString:@"未婚"]) {
            color2 = [UIColor colorWithHexString:@"fe6b6b"];
        }
        
        __weak QYCreditEvaluationMainVC *weakSelf = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [self addActionTarget:alert title:@"已婚" color: color1 action:^(UIAlertAction *action) {
            weakSelf.m_marriageTextField.text = @"已婚";
            
            //check button status
            [weakSelf checkBtnStatus];
        }];
        [self addActionTarget:alert title:@"未婚" color: color2 action:^(UIAlertAction *action) {
            weakSelf.m_marriageTextField.text = @"未婚";
            
            //check button status
            [weakSelf checkBtnStatus];
        }];
        [self addCancelActionTarget:alert title:@"取消"];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        UIActionSheet *marriageActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"已婚", @"未婚", nil];
        [marriageActionSheet showInView:self.view];
    }
    sender.enabled = YES;
}

/**
 系统返回
 */
- (void)goBack:(UIButton *)sender {
    if ([self.previousViewController isKindOfClass:[QYRegisterSuccessVC class]]) {
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        [AppGlobal gotoHomePage];
    }else {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [AppGlobal gotoHomePage];
    }
}

/**
 学历信息
 */
- (IBAction)onEducationClicked:(UIButton *)sender {
    sender.enabled = NO;
    [self.m_detailLocationTextField resignFirstResponder];
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    //选择学历界面
    QYCommonPickerView* educationView = [[[NSBundle mainBundle] loadNibNamed:@"QYCommonPickerView"
                                                                       owner:nil
                                                                     options:nil] lastObject];
    educationView.frame = CGRectMake(0, 0, appWidth, 267);
    educationView.backgroundColor = [UIColor clearColor];
    educationView.s_dataArray = self.m_educationArray;
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
    __weak QYCreditEvaluationMainVC *weakSelf = self;
    [educationView onOkClicked:^(NSString *content) {
        [blackView removeFromSuperview];
        NSString *tempStr = self.m_educationTextField.text;
        if (content) {
            weakSelf.m_educationTextField.text = content;
        }else{
            weakSelf.m_educationTextField.text = tempStr;
        }
        
        //check button status
        [weakSelf checkBtnStatus];
    } andCancelClicked:^(NSString *content) {
        [blackView removeFromSuperview];
    }];
    
    sender.enabled = YES;
}

/**
 所在城市
 */
- (IBAction)onCityClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    [self.m_detailLocationTextField resignFirstResponder];
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
    
    __weak QYCreditEvaluationMainVC *weakSelf = self;
    [locationView onOkClicked:^(NSString *province,NSString *city,NSString *district) {
        [blackView removeFromSuperview];
        NSString *tempStr = self.m_cityTextField.text;
        if (province && city && district ) {
            weakSelf.m_cityTextField.text = [NSString stringWithFormat:@"%@%@%@",province,city,district];
            weakSelf.m_privinceStr = province;
            weakSelf.m_cityStr = city;
            weakSelf.m_districtStr = district;
        }else{
            weakSelf.m_cityTextField.text = tempStr;
        }
        
        //check button status
        [weakSelf checkBtnStatus];
    } andCancelClicked:^(NSString *content) {
        [blackView removeFromSuperview];
    }];
    
    sender.enabled = YES;
}

/**
 绑定银行卡
 */
- (IBAction)onbindingBankCardClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    //goto addBankCard
    if ([[self queryInfo].isAuth isEqualToString:@"1"]) {
        
        if ([self.m_isHaveIdCardPhoto isEqualToString:@"0"]) {//未上传过身份证照片
            [self showMessageWithString:@"请补录身份证照片"];
            sender.enabled = YES;
            return;
        }
        
        if([self.m_isFaceAuthStr isEqualToString:@"0"]){//未活体检测,已实名认证
            [self showMessageWithString:@"请完成活体检测"];
            sender.enabled = YES;
            return;
        }
        
        //update userInfo
        NSString *tempMarriageStr = @"0";
        if ([self.m_marriageTextField.text isEqualToString:@"已婚"]) {
            tempMarriageStr = @"1";
        }else if ([self.m_marriageTextField.text isEqualToString:@"未婚"]) {
            tempMarriageStr = @"0";
        }else if (self.m_marriageTextField.text.length <= 0) {
            tempMarriageStr = @"";
        }
        UserInfo *info = [self queryInfo];
        QYResumeModel *userModel = [[QYResumeModel alloc]init];
        userModel.married = tempMarriageStr;
        if (self.m_educationTextField.text.length > 0) {
            userModel.education = [NSString stringWithFormat:@"%ld",(long)[self getIndexWithEducationLabel:self.m_educationTextField.text]];
        }
        userModel.province = self.m_privinceStr;
        userModel.city = self.m_cityStr;
        userModel.district = self.m_districtStr;
        userModel.address = self.m_detailLocationTextField.text;
        info.user = userModel;
        info.bankCards = self.m_bankArray;
        [self updateInfo:info];
        
        QYAddBankCardVC *vc = [[UIStoryboard storyboardWithName:@"QYHomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"QYAddBankCardVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self showMessageWithString:@"请完成身份信息认证"];
        sender.enabled = YES;
        return;
    }
    sender.enabled = YES;
}

/**
 点击隐私协议
 */
- (IBAction)onProtocalClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    //update userInfo
    NSString *tempMarriageStr = @"0";
    if ([self.m_marriageTextField.text isEqualToString:@"已婚"]) {
        tempMarriageStr = @"1";
    }else if ([self.m_marriageTextField.text isEqualToString:@"未婚"]) {
        tempMarriageStr = @"0";
    }else if (self.m_marriageTextField.text.length <= 0) {
        tempMarriageStr = @"";
    }
    UserInfo *info = [self queryInfo];
    QYResumeModel *userModel = [[QYResumeModel alloc]init];
    userModel.married = tempMarriageStr;
    if (self.m_educationTextField.text.length > 0) {
        userModel.education = [NSString stringWithFormat:@"%ld",(long)[self getIndexWithEducationLabel:self.m_educationTextField.text]];
    }
    userModel.province = self.m_privinceStr;
    userModel.city = self.m_cityStr;
    userModel.district = self.m_districtStr;
    userModel.address = self.m_detailLocationTextField.text;
    info.user = userModel;
    info.bankCards = self.m_bankArray;
    [self updateInfo:info];

    NSString *url = [NSString stringWithFormat:@"%@%@%@?token=%@",myBaseUrl,app_new_personnalPage,verison,info.token];
    
    QYWebViewVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QYWebViewVC"];
    vc.s_urlStr = url;
    vc.s_viewControler = self;
    [self.navigationController pushViewController:vc animated:YES];
    
    sender.enabled = YES;
}

/**
 下一步
 */
- (IBAction)onNextClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    //update userInfo
    NSString *tempMarriageStr = @"0";
    if ([self.m_marriageTextField.text isEqualToString:@"已婚"]) {
        tempMarriageStr = @"1";
    }else if ([self.m_marriageTextField.text isEqualToString:@"未婚"]) {
        tempMarriageStr = @"0";
    }
    UserInfo *info = [self queryInfo];
    QYResumeModel *userModel = [[QYResumeModel alloc]init];
    userModel.married = tempMarriageStr;
    if (self.m_educationTextField.text.length > 0) {
        userModel.education = [NSString stringWithFormat:@"%ld",(long)[self getIndexWithEducationLabel:self.m_educationTextField.text]];
    }
    userModel.province = self.m_privinceStr;
    userModel.city = self.m_cityStr;
    userModel.district = self.m_districtStr;
    userModel.address = self.m_detailLocationTextField.text;
    info.user = userModel;
    info.bankCards = self.m_bankArray;
    [self updateInfo:info];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"locationInfo"];
    [defaults synchronize];
    if (self.latitude && self.longitude && self.privinceStr && self.cityStr) {
        //是否有地理位置信息，最后一步上传，必须拿到地理位置才可走下一步
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        dict[@"latitude"] = [NSString stringWithFormat:@"%f",self.latitude];
        dict[@"longitude"] = [NSString stringWithFormat:@"%f",self.longitude];
        dict[@"privince"] = self.privinceStr;
        dict[@"city"] = self.cityStr;
        [defaults setObject:dict forKey:@"locationInfo"];
        [defaults synchronize];
        
        QYCreditEvaluationWorkVC *vc = [[UIStoryboard storyboardWithName:@"QYHomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"QYCreditEvaluationWorkVC"];
        [self.navigationController pushViewController:vc animated:YES];
        sender.enabled = YES;
    } else {
        if ([AppGlobal getLocationServicesEnabled] == 0) {
            self.isLocation = YES;
        } else if ([AppGlobal getLocationServicesEnabled] == 2) {
            self.isLocation = YES;
            [self.locMgr requestWhenInUseAuthorization];
        } else {
            self.isLocation = NO;
            [self.locMgr startUpdatingLocation];
            self.locMgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            [self showMessageWithString:@"未获取到定位信息"];
        }
        sender.enabled = YES;
    }
}

#pragma mark- textField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        return YES;
    }
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length > 50) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.m_bankArray.count > 0) {
        self.m_scrollView.scrollEnabled = YES;
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //locations数组里边存放的是CLLocation对象，一个CLLocation对象就代表着一个位置
    CLLocation *loc = [locations firstObject];
    
    if (!self.exist) {
        self.exist = YES;
    } else {
        return;
    }
    
    self.latitude = loc.coordinate.latitude;
    self.longitude = loc.coordinate.longitude;
    [self.locMgr stopUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> *_Nullable placemarks, NSError * _Nullable error) {
        
        for (CLPlacemark *place in placemarks) {
            
            if (place.administrativeArea) {
                self.privinceStr = place.administrativeArea;
            } else {
                NSString *privinceStr = place.locality;
                if([privinceStr rangeOfString:@"市"].location != NSNotFound) {
                    NSArray *array = [privinceStr componentsSeparatedByString:@"市"];
                    if (array.count > 1) {
                        self.privinceStr = array[0];
                    } else {
                        self.privinceStr = place.locality;
                    }
                } else {
                    self.privinceStr = place.locality;
                }
            }
            
            self.cityStr = place.locality;
            self.districtStr = place.subLocality;
            UserInfo *info = [self queryInfo];
            if ((!info.user.province) || (!info.user.city) || (!info.user.district)) {
                self.m_cityTextField.text = [NSString stringWithFormat:@"%@%@%@",self.privinceStr,self.cityStr,self.districtStr];
                self.m_privinceStr = self.privinceStr;
                self.m_cityStr = self.cityStr;
                self.m_districtStr = self.districtStr;
            }
            [self checkBtnStatus];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    CLAuthorizationStatus CLstatus = [CLLocationManager authorizationStatus];
    switch (CLstatus) {
        case kCLAuthorizationStatusAuthorizedAlways:
            //定位服务授权状态已经被用户允许在任何状态下获取位置信息"
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {//定位服务授权状态仅被允许在使用应用程序的时候
            if (self.isLocation) {
                [self.locMgr startUpdatingLocation];
                self.locMgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
                self.isLocation = NO;
            }
            break;
        }
        case kCLAuthorizationStatusDenied:
            //用户禁止访问地址
            
            break;
        case kCLAuthorizationStatusNotDetermined:
            //定位服务授权状态是用户没有决定是否使用定位服务
            break;
        case kCLAuthorizationStatusRestricted:
            //定位服务授权状态是受限制的
            break;
        default:
            break;
    }
}

#pragma mark- action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        self.m_marriageTextField.text = @"已婚";
    }else if (buttonIndex == 1){
        self.m_marriageTextField.text = @"未婚";
    }
    
    //check button status
    [self checkBtnStatus];
}

#pragma mark- tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.m_bankArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QYCreditBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYCreditBankCardCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"QYCreditBankCardCell" owner:nil options:nil] lastObject];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    QYBankCardModel *bankModel = [QYBankCardModel mj_objectWithKeyValues:[self.m_bankArray objectAtIndex:indexPath.row]];
    NSString *string = @"";
    if (bankModel.cardNum.length > 4) {
        string = [bankModel.cardNum substringWithRange:NSMakeRange(bankModel.cardNum.length - 4, 4)];
    }
    cell.m_bankNameLabel.text = [NSString stringWithFormat:@"%@(**%@)",bankModel.bankName,string];
    cell.m_typeLabel.text = [bankModel.cardType isEqualToString:@"0"] ? @"储蓄卡" : @"信用卡";
    if (indexPath.row == self.m_bankArray.count - 1) {
        cell.m_lineView.hidden = YES;
    }else{
        cell.m_lineView.hidden = NO;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return;
}

#pragma mark- 验证会员是否已经做了实名认证和人脸识别
/**
 人脸识别
 */
- (void)faceRecognition {
    
    [self showLoading];
    NSString* name = [[self queryInfo].personfullname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?idCardName=%@&idCardNo=%@",app_new_faceRecognition,verison,name,[self queryInfo].personIdCardCode];
    
    [[QYNetManager requestManagerWithBaseUrl:myBaseUrl] uploadImage:self.m_faceImg withUrl:myBaseUrl withPicUrl:urlStr andParameters:nil success:^(NSString * _Nullable imageIDString) {
        [self dismissLoading];
        
        //人脸成功后
        self.m_detectionView.hidden = YES;
        [self showMessageWithString:@"活体检测成功" imageName:@"Common_correct"];
        [self faceAuthCheck];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSString * _Nullable errorString) {
        [self dismissLoading];
        
        [self showMessageWithString:errorString];
    }];
}

/**
 验证会员是否已经做了实名认证和人脸识别和已上传身份证正反面照片
 */
- (void)faceAuthCheck {
    [self showLoading];
    NSString *url = [NSString stringWithFormat:@"%@%@",app_new_faceAuthCheck,verison];
    
    [[QYNetManager requestManagerWithBaseUrl:myBaseUrl] get:url params:nil success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            [self faceAuthCheckSuccess:responseObject];
        } else {
            [self faceAuthCheckFail:responseObject];
        }
        [self dismissLoading];
    } failure:^(NSString * _Nullable errorString) {
        [self dismissLoading];
        [self showMessageWithString:kShowErrorMessage];
    }];
}

/**
 成功
 */
- (void)faceAuthCheckSuccess:(id)responseObject {
    if([responseObject isKindOfClass:NSDictionary.class]){
        NSDictionary *dic =  [responseObject valueForKey:@"data"];
        NSInteger result = [[dic objectForKey:@"isFaceAuth"] intValue];
        self.m_isFaceAuthStr = [NSString stringWithFormat:@"%ld",(long)result];
        
        NSInteger idCardPhoto = [[dic objectForKey:@"isHaveIdCardPhoto"] intValue];
        self.m_isHaveIdCardPhoto = [NSString stringWithFormat:@"%ld",(long)idCardPhoto];
        
        NSInteger auditStatus = [[dic objectForKey:@"auditStatus"] intValue];
        self.isAuditStatus = [NSString stringWithFormat:@"%ld",(long)auditStatus];
        
        if ([self.m_isFaceAuthStr isEqualToString:@"0"] || [self.m_isHaveIdCardPhoto isEqualToString:@"0"]) {
            self.m_bankInfoLabel.hidden = NO;
            self.m_detectionView.hidden = NO;
            self.m_idCardIconImg.image = [UIImage imageNamed:@"HomePage_idCardIconNormal"];
        }else{
            self.m_detectionView.hidden = YES;
            self.m_bankInfoLabel.hidden = YES;
            self.m_idCardIconImg.image = [UIImage imageNamed:@"HomePage_idCardIconSelected"];
        }
        [self checkBtnStatus];
    }
}

/**
 失败
 */
- (void)faceAuthCheckFail:(id)responseObject {
    if ([responseObject objectForKey:@"message"]) {
        [self showMessageWithString:[responseObject objectForKey:@"message"]];
    }
}

@end

