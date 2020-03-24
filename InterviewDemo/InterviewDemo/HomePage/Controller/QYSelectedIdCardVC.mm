//
//  QYSelectedIdCardVC.m
//  QYStaging
//
//  Created by wangkai on 2017/4/13.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYSelectedIdCardVC.h"
#import "QYIdCardInfoModel.h"
#import "QYConfirmIdCardVC.h"
#import "QYCreditEvaluationMainVC.h"
#import "QYHomePageVC.h"

@interface QYSelectedIdCardVC ()
/* 正面 */
@property (weak, nonatomic) IBOutlet UIButton *m_frontButton;
/* 反面 */
@property (weak, nonatomic) IBOutlet UIButton *m_backButton;
/* 扫身份证正面标识*/
@property (assign, nonatomic) BOOL m_frontFlag;
/* 扫身份证背面标识*/
@property (assign, nonatomic) BOOL m_backFlag;
/* 正面身份证路径*/
@property (copy, nonatomic) NSString *m_frontPathStr;
/* 适配*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_toLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_toBottomConstraint;
/* 保存正反面图片*/
@property (nonatomic,strong)UIImage *m_frontImg;
@property (nonatomic,strong)UIImage *m_backImg;
/* 描述信息*/
@property (weak, nonatomic) IBOutlet UILabel *m_descLabel;
/* 人脸识别照片 */
@property (nonatomic,strong) UIImage *m_faceImg;

@end

@implementation QYSelectedIdCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set default
    self.m_frontFlag = NO;
    self.m_backFlag = NO;
    
    //id card scanner notification
    [NotificationCenter addObserver:self selector:@selector(idCardFinished:) name:IDCARDFINISHEDSUCCESS object:nil];
    [NotificationCenter addObserver:self selector:@selector(idCardFailed:) name:IDCARDFAILED object:nil];
    
    //adapter
    if (iphone5) {
        self.m_toLeftConstraint.constant = 70;
        self.m_toBottomConstraint.constant = -4;
    }else if(iphone6 && IOS_VERSION < 10){
        self.m_toBottomConstraint.constant = 5;
    }else if(iphone6Plus){
        self.m_toBottomConstraint.constant = 2;
    }
    
    //set desc
    NSString *defaultStr = @"仅用于全国公民身份查询中心,核实身份拍摄时确保身份证边框完整、字迹清晰、亮度均衡";
    NSString *currentStr = @"边框完整、字迹清晰、亮度均衡";
    self.m_descLabel.text = defaultStr;
    [AppGlobal changeRichTextColor:self.m_descLabel defaultColor:@"9f9f9f" currentColor:@"000000" defaultText:defaultStr currentText:currentStr];
    
    [self.leftButton setAccessibilityIdentifier:@"iv_title_left_icon"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //set nav title
    self.navigationItem.title = @"身份认证";
}

- (void)dealloc {
    [NotificationCenter removeObserver:self];
}

/**
 扫正面

 @param sender sender description
 */
- (IBAction)onFrontClicked:(UIButton *)sender {
    sender.enabled = NO;

    if ([AppGlobal isCameraPermissions]) {
        //启用授权
        [MGLicenseManager licenseForNetWokrFinish:^(bool License) {
            if (License) {
                DLog(@"授权成功");
            }else{
                DLog(@"授权失败");
            }
            
            __unsafe_unretained QYSelectedIdCardVC *weakSelf = self;
            BOOL idcard = [MGIDCardManager getLicense];
            if (!idcard) {
                [self showMessageWithString:@"网络不通畅,请重试"];
                return;
            }
            
            MGIDCardManager *cardManager = [[MGIDCardManager alloc] init];
            [cardManager IDCardStartDetection:self IdCardSide:IDCARD_SIDE_FRONT
                                       finish:^(MGIDCardModel *model) {
                                           
                                           //拿到图片
                                           NSString *path_document = NSHomeDirectory();
                                           //设置一个图片的存储路径
                                           self.m_frontPathStr = [path_document stringByAppendingString:@"/Documents/idCard_front.png"];
                                           //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
                                           [UIImagePNGRepresentation([model croppedImageOfIDCard]) writeToFile:self.m_frontPathStr atomically:YES];
                                           [weakSelf.m_frontButton setBackgroundImage:[model croppedImageOfIDCard] forState:UIControlStateNormal];
                                           [weakSelf.m_frontButton setBackgroundImage:[model croppedImageOfIDCard] forState:UIControlStateHighlighted];
                                           weakSelf.m_frontImg = [model croppedImageOfIDCard];
                                           
                                           weakSelf.m_frontFlag = YES;
                                           
                                           if (weakSelf.m_frontFlag && weakSelf.m_backFlag) {
                                               //上传图片
                                               [weakSelf uploadFile];
                                           }
                                       }
                                         errr:^(MGIDCardError) {
                                             
                                         }];
        }];
    } else {
        [AppGlobal openCameraPermissions];
    }
    
    sender.enabled = YES;
}

/**
 扫背面

 @param sender sender description
 */
- (IBAction)onBackClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    // 是否开启相机
    if ([AppGlobal isCameraPermissions]) {
        //启用授权
        [MGLicenseManager licenseForNetWokrFinish:^(bool License) {
            if (License) {
                DLog(@"授权成功");
            }else{
                DLog(@"授权失败");
            }
            
            __unsafe_unretained QYSelectedIdCardVC *weakSelf = self;
            BOOL idcard = [MGIDCardManager getLicense];
            if (!idcard) {
                [self showMessageWithString:@"网络不通畅,请重试"];
                return;
            }
            
            MGIDCardManager *cardManager = [[MGIDCardManager alloc] init];
            [cardManager IDCardStartDetection:self IdCardSide:IDCARD_SIDE_BACK
                                       finish:^(MGIDCardModel *model) {
                                           
                                           //拿到图片
                                           NSString *path_document = NSHomeDirectory();
                                           //设置一个图片的存储路径
                                           NSString *imagePath = [path_document stringByAppendingString:@"/Documents/idCard_back.png"];
                                           //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
                                           [UIImagePNGRepresentation([model croppedImageOfIDCard]) writeToFile:imagePath atomically:YES];
                                           [weakSelf.m_backButton setBackgroundImage:[model croppedImageOfIDCard] forState:UIControlStateNormal];
                                           [weakSelf.m_backButton setBackgroundImage:[model croppedImageOfIDCard] forState:UIControlStateHighlighted];
                                           weakSelf.m_backImg = [model croppedImageOfIDCard];
                                           
                                           weakSelf.m_backFlag = YES;
                                           
                                           if (weakSelf.m_frontFlag && weakSelf.m_backFlag) {
                                               //上传图片服务器
                                               [weakSelf uploadFile];
                                           }
                                       }
                                         errr:^(MGIDCardError) {
                                             
                                         }];
        }];
    } else {
        [AppGlobal openCameraPermissions];
    }
    
    sender.enabled = YES;
}

#pragma mark- 图片上传
- (void)uploadFile {
    [self showLoading];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",app_new_uploadFile,verison];
    
    [[QYNetManager requestManagerWithBaseUrl:myBaseUrl] uploadImage:self.m_frontImg withUrl:myBaseUrl withPicUrl:urlStr andParameters:nil success:^(NSString * _Nullable imageIDString) {
        
        NSString *frontStr = [[imageIDString valueForKey:@"data"] valueForKey:@"fileId"];
        
        [[QYNetManager requestManagerWithBaseUrl:myBaseUrl] uploadImage:self.m_backImg withUrl:myBaseUrl withPicUrl:urlStr andParameters:nil success:^(NSString * _Nullable imageIDString) {
            
            NSString *backStr = [[imageIDString valueForKey:@"data"] valueForKey:@"fileId"];
            
            //保存图片id 用于实名认证
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:frontStr forKey:@"frontSwiftId"];
            [defaults setObject:backStr forKey:@"backSwiftId"];
            [defaults synchronize];
            [self dismissLoading];
            //仅未传身份证照片,不在请求身份证信息。
            if ([_photoOrFace isEqualToString:@"photo"]) {//直接拍照，上传身份证补录信息
                [self collectionIdCardInfo];
            } else if ([_photoOrFace isEqualToString:@"photoAndFace"]) {//活体检测后，一起上传身份证补录信息
                [self goToFace];
            } else {
                //请求身份证信息
                [self checkImgWithPath];
            }
            
//            if ([_photoOrFace isEqualToString:@"photoAndFace"] || [_photoOrFace isEqualToString:@"photo"]) {
//                [self collectionIdCardInfo];
//            } else {
//                //请求身份证信息
//                [self checkImgWithPath];
//            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSString * _Nullable errorString) {
            [self dismissLoading];
            [self showMessageWithString:errorString];
            
            //token失效
            if([errorString rangeOfString:@"重新登录"].location !=NSNotFound)
            {
                [AppGlobal gotoNewLoginVC:self];
            }
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSString * _Nullable errorString) {
        [self dismissLoading];
        [self showMessageWithString:errorString];
        
        //token失效
        if([errorString rangeOfString:@"重新登录"].location !=NSNotFound)
        {
            [AppGlobal gotoNewLoginVC:self];
        }
    }];
}

#pragma mark- 补录身份信息
- (void)collectionIdCardInfo {
    [self showLoading];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *frontSwiftId = [defaults objectForKey:@"frontSwiftId"];
    NSString *backSwiftId = [defaults objectForKey:@"backSwiftId"];
    
    NSString *urlStr = nil;
    if ([self.auditStatus isEqualToString:@"3"]) {
        urlStr = [NSString stringWithFormat:@"%@%@?frontFileId=%@&backFileId=%@&reCommit=1",app_new_addIdCard,verison,frontSwiftId,backSwiftId];
    } else {
        urlStr = [NSString stringWithFormat:@"%@%@?frontFileId=%@&backFileId=%@&reCommit=0",app_new_addIdCard,verison,frontSwiftId,backSwiftId];
    }
    
    
    [[QYNetManager requestManagerWithBaseUrl:myBaseUrl] get:urlStr params:nil success:^(id  _Nullable responseObject) {
        [self dismissLoading];
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            
            if ([_photoOrFace isEqualToString:@"photo"]) {
                
                //补录身份完事后，添加上补充资料标签
                if ([self.vc isKindOfClass:[QYHomePageVC class]]) {
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:@"1" forKey:@"floatLayerPop"];
                    [defaults synchronize];
                }
                //更新首页状态
                [NotificationCenter postNotificationName:kREFRESHHOMENotification object:nil];
                
                //补录身份证成功不做处理,回到首页
                [self.navigationController popViewControllerAnimated:YES];
            } else if ([_photoOrFace isEqualToString:@"photoAndFace"]) {
                
                //人脸成功后,补录身份信息，返回信用评估首页
                for (UIViewController *controller in self.navigationController
                     .viewControllers) {
                    if ([controller isKindOfClass:QYCreditEvaluationMainVC.class]) {
                        QYCreditEvaluationMainVC *vc = (QYCreditEvaluationMainVC *)controller;
                        [self.navigationController popToViewController:vc animated:true];
                        break;
                    }
                }
            }
        } else {
            [self showMessageWithString:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSString * _Nullable errorString) {
        [self dismissLoading];
        [self showMessageWithString:errorString];
    }];
}

#pragma mark- 身份证照片上传
- (void)checkImgWithPath {
    [self showLoading];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",myBaseUrl,app_new_ocrIdCard,verison];
    [[TFFileUploadManager shareInstance] uploadFileWithURL:urlStr params:nil fileKey:@"image" filePath:self.m_frontPathStr completeHander:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
    }];
}

- (void)idCardFinished:(NSNotification *)notification {
    [self dismissLoading];
    NSDictionary *dic = notification.userInfo;
    NSString *jsonStr = dic[@"data"];
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if ([[tempDic objectForKey:@"code"] intValue] == 10000) {
        QYIdCardInfoModel *idCardInfo = [tempDic objectForKey:@"data"];
        
        QYConfirmIdCardVC *vc = [[UIStoryboard storyboardWithName:@"QYHomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"QYConfirmIdCardVC"];
        vc.s_cardInfoModel = [QYIdCardInfoModel mj_objectWithKeyValues:idCardInfo];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        [self showMessageWithString:[tempDic objectForKey:@"message"]];
    }
}

- (void)idCardFailed:(NSNotification *)notification {
    
    [self dismissLoading];
    [self showMessageWithString:@"加载超时，请重试!"];
}

#pragma mark - 活体检测
/**
 去人脸识别
 */
- (void)goToFace {
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
}

/**
 人脸识别
 */
- (void)faceRecognition {
    
    [self showLoading];
    NSString* tempIdCardStr =  [AppGlobal repleaceBlankWithString:[self queryInfo].personIdCardCode];
    NSString* name = [[self queryInfo].personfullname  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?idCardName=%@&idCardNo=%@",app_new_faceRecognition,verison,name,tempIdCardStr];
    
    [[QYNetManager requestManagerWithBaseUrl:myBaseUrl] uploadImage:self.m_faceImg withUrl:myBaseUrl withPicUrl:urlStr andParameters:nil success:^(NSString * _Nullable imageIDString) {
        [self dismissLoading];
        //补录身份证信息
        if ([_photoOrFace isEqualToString:@"photoAndFace"]) {
            [self collectionIdCardInfo];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSString * _Nullable errorString) {
        [self dismissLoading];
        [self showMessageWithString:errorString];
    }];
}

- (void)showErrorString:(MGLivenessDetectionFailedType)errorType {
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

@end
