//
//  QYVideoAuthVC.m
//  QYStaging
//
//  Created by wangkai on 2017/4/26.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYVideoAuthVC.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import "QYVideoTipView.h"
#import "QYSignedResultVC.h"

typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);

@interface QYVideoAuthVC ()<AVCaptureFileOutputRecordingDelegate>

/* 视频背景*/
@property (weak, nonatomic) IBOutlet UIView *m_bgView;
/* 按下按钮*/
@property (weak, nonatomic) IBOutlet UIButton *m_upDownButton;
/* 按下文字*/
@property (weak, nonatomic) IBOutlet UILabel *m_upDownLabel;
/** 定时器 */
@property (strong, nonatomic) NSTimer *m_timer;
/** 定时时间 */
@property(nonatomic, assign) NSInteger m_times;
/** 进度条 */
@property (weak, nonatomic) IBOutlet UIProgressView *m_process;
/** 提示view */
@property (weak, nonatomic) IBOutlet UIView *m_tipView;
/** 视频是否录制完成 */
@property (assign,nonatomic)BOOL m_isCompleted;
/** 相机拍摄预览图层 */
@property (strong,nonatomic)AVCaptureVideoPreviewLayer *m_preview;
/** 负责从AVCaptureDevice获得输入数据 */
@property (strong,nonatomic)AVCaptureDeviceInput *m_input;
/** 负责输入和输出设备之间的数据传递 */
@property (strong,nonatomic)AVCaptureSession *m_session;
/** 视频文件输出流 */
@property (strong,nonatomic) AVCaptureMovieFileOutput *m_output;
/** 视后台任务标识 */
@property (assign,nonatomic) UIBackgroundTaskIdentifier m_backgroundTaskIdentifier;
/** 播放器对象 */
@property (nonatomic,strong) AVPlayer *m_player;
/** 总播放器对象 */
@property (nonatomic, strong)AVPlayerLayer *m_playerLayer;
/** 上部文字view */
@property (weak, nonatomic) IBOutlet UIView *m_topView;
/** 上部文字view1 */
@property (weak, nonatomic) IBOutlet UIView *m_topView1;
/** 中部view */
@property (weak, nonatomic) IBOutlet UIView *m_meidiumView;
/** 播放页view */
@property (weak, nonatomic) IBOutlet UIView *m_playView;
/** 视频是否正在录制 */
@property (assign,nonatomic)BOOL m_isRecording;
/** 重录 */
@property (weak, nonatomic) IBOutlet UIButton *m_recordButton;
/** 协议内容 */
@property (weak, nonatomic) IBOutlet UITextView *protocolLable;
/** 协议悲剧高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *protocolBgViewHeight;
/** 状态栏 */
@property (strong, nonatomic) UIView *m_topGradientView;

@end

@implementation QYVideoAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self getContractInfoRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self removeNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //set UI
    [self initUI];
    
    //set nav
    [self performSelector:@selector(hideNavBar) withObject:nil afterDelay:0.0];
    
    //默认未播放
    [self setPlayWithOn:NO];
    
    //添加提示
    [self addTipView];
    
    //设置状态栏
//    self.m_topGradientView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
//    self.m_topGradientView.backgroundColor= [UIColor colorWithHexString:@"000000" alpha:0.5];
//    [self.navigationController.view addSubview:self.m_topGradientView];
    
    //设置状态栏
    [self setStatusBarBackgroundColor:[UIColor blackColor]];
    
    //show bar
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.m_session stopRunning];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //导航栏状态栏恢复
    [self showNavigationBar];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    //reset bar
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    //设置状态栏
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    
//    if (self.m_topGradientView) {
//        [self.m_topGradientView removeFromSuperview];
//    }
}

- (IBAction)onBackClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
    
    sender.enabled = YES;
}

-(void) hideNavBar {
    if (self.navigationController.navigationBar.hidden == NO)
    {
        [self hideNavigationBar];
    }
}

/**
 添加提示
 */
- (void)addTipView {
    QYVideoTipView *tipView = [[[NSBundle mainBundle] loadNibNamed:@"QYVideoTipView"
                                                             owner:nil
                                                           options:nil] lastObject];
    tipView.frame = CGRectMake(0, 0, appWidth, appHeight);
    tipView.backgroundColor = [UIColor clearColor];
    tipView.tag =  kBLACKTAG;
    [[UIApplication sharedApplication].keyWindow addSubview:tipView];

    tipView.copyExistBlock = ^(){
        if (!self.protocolLable.text || self.protocolLable.text.length <= 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"朗读文案未加载成功，请返回上一页后重新进入" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }]];

            [self presentViewController:alert animated:YES completion:nil];
        }
    };
}

/**
 获取UITextView高度
 */
- (float)heightForString:(UITextView *)textView andWidth:(float)width {
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

- (void)initUI {
    //add button
    [self.m_upDownButton setImage:[UIImage imageNamed:@"HomePage_holdDown"] forState:UIControlStateNormal];
    [self.m_upDownButton setImage:[UIImage imageNamed:@"HomePage_upDown"] forState:UIControlStateSelected];
    [self.m_upDownButton addTarget:self action:@selector(onButtonTouchBegin:)forControlEvents:UIControlEventTouchDown];
    [self.m_upDownButton addTarget:self action:@selector(onButtonTouchEnd:)forControlEvents:UIControlEventTouchUpInside];
    [self.m_upDownButton addTarget:self action:@selector(onButtonTouchEnd:)forControlEvents:UIControlEventTouchUpOutside];
    self.m_isCompleted = NO;
    self.m_recordButton.hidden = YES;
    
    //set process
    self.m_process.backgroundColor = [UIColor clearColor];
    
    //set view
    self.m_tipView.layer.cornerRadius = 16;
    self.m_tipView.hidden = YES;
    
    // Device
    AVCaptureDevice *device = [self getCameraDeviceWithPosition:AVCaptureDevicePositionFront];
    
    // Input
    self.m_input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    // Output
    self.m_output = [[AVCaptureMovieFileOutput alloc] init];
    
    // Session
    self.m_session = [[AVCaptureSession alloc] init];
    [self.m_session setSessionPreset:AVCaptureSessionPresetMedium];
    
    //添加一个音频输入设备
    NSError *error=nil;
    AVCaptureDevice *audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    AVCaptureDeviceInput *audioCaptureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:audioCaptureDevice error:&error];
    if (error) {
        DLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    
    //将设备输入添加到会话中
    if ([self.m_session canAddInput:self.m_input]) {
        [self.m_session addInput:self.m_input];
        [self.m_session addInput:audioCaptureDeviceInput];
        AVCaptureConnection *captureConnection=[self.m_output connectionWithMediaType:AVMediaTypeVideo];
        if ([captureConnection isVideoStabilizationSupported ]) {
            captureConnection.preferredVideoStabilizationMode=AVCaptureVideoStabilizationModeAuto;
        }
    }
    if ([self.m_session canAddOutput:self.m_output]) {
        [self.m_session addOutput:self.m_output];
    }
    
    // Preview
    self.m_preview = [AVCaptureVideoPreviewLayer layerWithSession:self.m_session];
    CALayer *layer = self.m_bgView.layer;
    layer.masksToBounds = YES;
    CGRect tempFrame1 = layer.bounds;
    tempFrame1.size.height += 30;
    self.m_preview.frame = tempFrame1;
//    self.m_preview.frame = layer.bounds;
    self.m_preview.videoGravity = AVLayerVideoGravityResizeAspectFill;//填充模式
    if (iphone6Plus) {
        CGRect tempFrame = self.m_preview.frame;
        tempFrame.size.width += 40;
        tempFrame.size.height += 94;
        self.m_preview.frame = tempFrame;
    }
    //将视频预览层添加到界面中
    //[layer addSublayer:_captureVideoPreviewLayer];
//    [layer insertSublayer:_captureVideoPreviewLayer below:self.focusCursor.layer];
    
    [self addGenstureRecognizer];
    [self.m_bgView.layer insertSublayer:self.m_preview atIndex:0];
    [self.m_session startRunning];
    self.m_isRecording = NO;
}

/**
 设置播放器UI
 */
- (void)playerUI {
    
    //创建播放器层
    AVPlayerItem *playerItem=[self getPlayItem];
    self.m_player = [AVPlayer playerWithPlayerItem:playerItem];
    self.m_playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.m_player];
    self.m_playerLayer.frame = self.m_bgView.frame;
    self.m_playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.m_bgView.layer insertSublayer:self.m_playerLayer atIndex:1];
    
    //暂停播放
    [self.m_player pause];
}

/**
 *  根据视频索引取得AVPlayerItem对象
 *
 */
- (AVPlayerItem *)getPlayItem {

    NSString *outputFielPath=[NSTemporaryDirectory() stringByAppendingString:@"myMovie.mp4"];
//    NSString *outputFielPath = @"http://v1.mukewang.com/a45016f4-08d6-4277-abe6-bcfd5244c201/L.mp4";
    outputFielPath =[outputFielPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    DLog(@"输出路径: %@",outputFielPath);
    NSURL *url=[NSURL fileURLWithPath:outputFielPath];
    AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:url];
    
    //给AVPlayerItem添加播放完成通知
    [self addNotification];
    
    return playerItem;
}

/**
 *  添加播放器通知
 */
- (void)addNotification {
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.m_player.currentItem];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  播放完成通知
 *
 *  @param notification 通知对象
 */
- (void)playbackFinished:(NSNotification *)notification {
    DLog(@"视频播放完成.");
    self.m_playView.hidden = NO;
    [self.m_player seekToTime:CMTimeMake(0, 1)];
}

/**
 重新录制
 
 @param sender sender description
 */
- (IBAction)onRightClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    //重录
    [self.m_upDownButton setImage:[UIImage imageNamed:@"HomePage_holdDown"] forState:UIControlStateNormal];
    [self.m_upDownButton setImage:[UIImage imageNamed:@"HomePage_upDown"] forState:UIControlStateSelected];
    self.m_upDownLabel.text = @"按下";
    self.m_isCompleted = NO;
    self.m_isRecording = NO;
    self.m_recordButton.hidden = YES;
    self.m_process.progress = 0;
    [self setPlayWithOn:NO];
    
    sender.enabled = YES;
}

- (void)onButtonTouchBegin:(id)sender {
    if (!self.m_isCompleted) {
        [self startTimer];
        self.m_tipView.hidden = NO;
        self.m_recordButton.hidden = YES;
        
        if (self.m_times && self.m_times < 5) {
            [self showMessageWithString:@"录入时间过短"];
            [self.m_output stopRecording];//停止录制
            self.m_isRecording = NO;
            self.m_process.progress = 0;
            self.m_times = 0;
            [self stopTimer];
        }
    }else{
        NSString *outputFielPath=[NSTemporaryDirectory() stringByAppendingString:@"myMovie.mp4"];
        [self checkVideoWithPath:outputFielPath];
    }
}

- (void)onButtonTouchEnd:(id)sender {
    if (!self.m_isCompleted) {
        if (!self.m_times) {
            [self showMessageWithString:@"录入时间过短"];
            [self.m_output stopRecording];//停止录制
            self.m_isRecording = NO;
            self.m_times = 0;
            self.m_process.progress = 0;
            [self stopTimer];
            self.m_tipView.hidden = YES;
            return;
        }
        
        [self stopTimer];
        self.m_tipView.hidden = YES;
        
        if (self.m_times && self.m_times <= 5) {
            [self showMessageWithString:@"录入时间过短"];
            [self.m_output stopRecording];//停止录制
            self.m_isRecording = NO;
            self.m_times = 0;
            self.m_process.progress = 0;
            [self stopTimer];
        }
        if (self.m_times && self.m_times > 5) {
            self.m_isCompleted = YES;
            self.m_upDownLabel.text = @"";
            [self.m_upDownButton setImage:[UIImage imageNamed:@"HomePage_submit"] forState:UIControlStateNormal];
            [self.m_upDownButton setImage:[UIImage imageNamed:@"HomePage_submit"] forState:UIControlStateSelected];
            self.self.m_recordButton.hidden = NO;
            [self.m_output stopRecording];//停止录制
            self.m_isRecording = NO;
        }
    }
}

#pragma mark- 上传视频
-(void)uploadFileWithVideo:(NSURL *)url{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",app_new_videoAuthentication,verison];
    [self showLoading];
    
    
    NSMutableDictionary *healder = [[NSMutableDictionary alloc]init];
    
    
    healder[@"traceId"] = [[NSUUID UUID] UUIDString];
    healder[@"parentId"] = [[NSUUID UUID] UUIDString];
    
    //网络监控开始时间戳和时间
    NSUInteger startMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
    NSString *startTime = [AppGlobal getCurrentTime];
    
    
   
    
     [[QYNetManager requestManagerHeader:healder baseUrl:myBaseUrl] uploadVideoUrl:url params:nil urlString:urlStr success:^(id _Nullable responseObject) {
        [self dismissLoading];
        if (responseObject[@"data"]) {
            if ([[responseObject objectForKey:@"code"] intValue] == 10000) {
                NSDictionary *resultDic = [responseObject objectForKey:@"data"];
                NSInteger result = [[resultDic objectForKey:@"result"] intValue];
                if (result == 1) {
                    QYSignedResultVC *signedResultVC = [QYSignedResultVC vc];
                    [self.navigationController pushViewController:signedResultVC animated:YES];
                }else{
                    [self showMessageWithString:@"加载超时，请重试!"];
                }
            }else if (([[responseObject objectForKey:@"code"] intValue] == 10006)||([[responseObject objectForKey:@"code"] intValue] == 10008)){
                //不匹配
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"视频认证与实名认证照片不相符，请重新录制" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消录制" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"重新录制" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    //重录
                    [self.m_upDownButton setImage:[UIImage imageNamed:@"HomePage_holdDown"] forState:UIControlStateNormal];
                    [self.m_upDownButton setImage:[UIImage imageNamed:@"HomePage_upDown"] forState:UIControlStateSelected];
                    self.m_upDownLabel.text = @"按下";
                    self.m_isCompleted = NO;
                    self.m_isRecording = NO;
                    self.m_recordButton.hidden = YES;
                    self.m_process.progress = 0;
                    [self setPlayWithOn:NO];
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                [self showMessageWithString:[responseObject objectForKey:@"message"]];
            }
        }else{
            [self showMessageWithString:[responseObject objectForKey:@"message"]];
        }
         //接口监控
         NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
         NSString *endTime = [AppGlobal getCurrentTime];
         NSUInteger period = endMillSeconds - startMillSeconds;
         NSString *periods = [NSString stringWithFormat:@"%tu", period];
         
         [[KYMonitorManage sharedInstance] upLoadDataWithPhone:[self queryInfo].phoneNum andStatus:@"200" andArguments:nil andResult:responseObject andMethodName: NSStringFromSelector(_cmd) andClazz:NSStringFromClass([self class]) andBusiness:@"qyfq_app_new_videoAuthentication" andBusinessAlias:@"视频认证" andServiceStart:startTime andServiceEnd:endTime andElapsed:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSString * _Nullable errorString) {
        [self showMessageWithString:@"上传失败,请重试!"];
        
        [self dismissLoading];
        //网络监控结束时间戳和时间
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        [self monitorReq:@"500" param:nil msg:errorString methodName:NSStringFromSelector(_cmd) className:NSStringFromClass([self class]) buName:@"qyfq_app_new_videoAuthentication" buAlias:@"视频认证" statTime:startTime endTime:endTime period:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    }];
}

/**
 视频认证
 */
- (void)checkVideoWithPath:(NSString *)pathStr {
    NSURL *fileUrl=[NSURL fileURLWithPath:pathStr];
    [self uploadFileWithVideo:fileUrl];
}

/**
 是否播放

 @param isOn isOn description
 */
- (void)setPlayWithOn:(BOOL)isOn {
    self.m_topView.hidden = isOn;
    self.m_topView1.hidden = isOn;
    self.m_meidiumView.hidden = isOn;
    self.m_playerLayer.hidden = !isOn;
    self.m_playView.hidden = !isOn;
    if (isOn) {
        [self.m_session stopRunning];
    }else{
        [self.m_session startRunning];
        if (self.m_player) {
            [self.m_player pause];
        }
    }
}

/**
 开始播放

 @param sender sender description
 */
- (IBAction)onPlayClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    //开始播放
    [self.m_player play];
    self.m_playView.hidden = YES;
    
    sender.enabled = YES;
}

#pragma mark - 获取协议文案请求及处理
/**
 获取协议文案请求
 */
- (void)getContractInfoRequest {
    
    self.protocolLable.text = @"";
    self.protocolBgViewHeight.constant = 35;
    
    [self showLoading];
    NSString *url = [NSString stringWithFormat:@"%@%@",app_new_getContractInfo,verison];
    
    
    NSMutableDictionary *healder = [[NSMutableDictionary alloc]init];
    
    
    healder[@"traceId"] = [[NSUUID UUID] UUIDString];
    healder[@"parentId"] = [[NSUUID UUID] UUIDString];
    
    //网络监控开始时间戳和时间
    NSUInteger startMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
    NSString *startTime = [AppGlobal getCurrentTime];
    
    
   
    
     [[QYNetManager requestManagerHeader:healder baseUrl:myBaseUrl] get:url params:nil success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            [self requestContractInfoStatusSuccess:responseObject];
        } else {
            [self requestContractInfoStatusFail:responseObject];
        }
        [self dismissLoading];
         
         //接口监控
         NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
         NSString *endTime = [AppGlobal getCurrentTime];
         NSUInteger period = endMillSeconds - startMillSeconds;
         NSString *periods = [NSString stringWithFormat:@"%tu", period];
         
         [[KYMonitorManage sharedInstance] upLoadDataWithPhone:[self queryInfo].phoneNum andStatus:@"200" andArguments:nil andResult:responseObject andMethodName: NSStringFromSelector(_cmd) andClazz:NSStringFromClass([self class]) andBusiness:@"qyfq_app_new_getContractInfo" andBusinessAlias:@"根据ssoId查询朗读文案" andServiceStart:startTime andServiceEnd:endTime andElapsed:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
         
    } failure:^(NSString * _Nullable errorString) {
        [self dismissLoading];
        [self showMessageWithString:kShowErrorMessage];
        //网络监控结束时间戳和时间
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        [self monitorReq:@"500" param:nil msg:errorString methodName:NSStringFromSelector(_cmd) className:NSStringFromClass([self class]) buName:@"qyfq_app_new_getContractInfo" buAlias:@"根据ssoId查询朗读文案"  statTime:startTime endTime:endTime period:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    }];
}

/**
 协议文案请求成功处理
 */
- (void)requestContractInfoStatusSuccess:(id)responseObject {
    
    if ([responseObject objectForKey:@"data"]) {
        self.protocolLable.text = [responseObject objectForKey:@"data"];
        CGFloat width = appWidth - 5 - 10 - 10 - 66;
        CGFloat height = [self heightForString:self.protocolLable andWidth:width];
        self.protocolBgViewHeight.constant = height;
        self.protocolLable.textColor = [UIColor whiteColor];
    }
}

/**
 协议文案请求失败处理
 */
- (void)requestContractInfoStatusFail:(id)responseObject {
    if ([responseObject objectForKey:@"message"]) {
        [self showMessageWithString:[responseObject objectForKey:@"message"]];
    }
}

#pragma mark- 定时器
/**
 *   启动时钟
 */
- (void)startTimer {
    if (self.m_timer) {
        return;
    }
    self.m_times = 0;
    self.m_timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target:self
                                                  selector:@selector(execute)
                                                  userInfo:nil
                                                   repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.m_timer forMode:NSRunLoopCommonModes];
}

/**
 *   时钟执行
 */
- (void)execute {
    if (self.m_times == 35) {
        [self stopTimer];
        return;
    }
    self.m_times++;
    
    if (self.m_times >= 35) {
        self.m_upDownLabel.text = @"";
        [self.m_upDownButton setImage:[UIImage imageNamed:@"HomePage_submit"] forState:UIControlStateNormal];
        [self.m_upDownButton setImage:[UIImage imageNamed:@"HomePage_submit"] forState:UIControlStateSelected];
        [self stopTimer];
        [self.m_process setProgress:1 animated:NO];
        self.m_isRecording = NO;
        self.m_isCompleted = YES;
        [self.m_output stopRecording];//停止录制
        
        //重录
        self.m_recordButton.hidden = NO;
    }else{
        
        self.m_process.progress = self.m_times * 0.0286;
        if (self.m_times > 5) {
            self.m_tipView.hidden = YES;
        }
        
        if (self.m_times > 1 && !self.m_isRecording) {
            self.m_isRecording = YES;
            
            //根据设备输出获得连接
            AVCaptureConnection *captureConnection=[self.m_output connectionWithMediaType:AVMediaTypeVideo];
            //根据连接取得设备输出的数据
            if (![self.m_output isRecording]) {
                //如果支持多任务则则开始多任务
                if ([[UIDevice currentDevice] isMultitaskingSupported]) {
                    self.m_backgroundTaskIdentifier=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
                }
                //预览图层和视频方向保持一致
                captureConnection.videoOrientation=[self.m_preview connection].videoOrientation;
                NSString *outputFielPath = [NSTemporaryDirectory() stringByAppendingString:@"myMovie.mp4"];
                
                DLog(@"save path is :%@",outputFielPath);
                NSURL *fileUrl=[NSURL fileURLWithPath:outputFielPath];
                [self.m_output startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
            }
            else{
                self.m_isRecording = NO;
                [self.m_output stopRecording];//停止录制
            }
        }
    }
}

/**
 *   停止时钟
 */
- (void)stopTimer {
    [self.m_timer invalidate];
    self.m_timer = nil;
}

#pragma mark - 私有方法

/**
 *  取得指定位置的摄像头
 *
 *  @param position 摄像头位置
 *
 *  @return 摄像头设备
 */
- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position {
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position]==position) {
            return camera;
        }
    }
    return nil;
}

/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 */
- (void)changeDeviceProperty:(PropertyChangeBlock)propertyChange {
    AVCaptureDevice *captureDevice= [self.m_input device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }else{
        DLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

/**
 *  设置聚焦模式
 *
 *  @param focusMode 聚焦模式
 */
- (void)setFocusMode:(AVCaptureFocusMode )focusMode {
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}

/**
 *  设置曝光模式
 *
 *  @param exposureMode 曝光模式
 */
- (void)setExposureMode:(AVCaptureExposureMode)exposureMode {
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
    }];
}

/**
 *  设置聚焦点
 *
 *  @param point 聚焦点
 */
- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point {
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        }
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
    }];
}

/**
 *  添加点按手势，点按时聚焦
 */
- (void)addGenstureRecognizer {
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    [self.m_bgView addGestureRecognizer:tapGesture];
}

- (void)tapScreen:(UITapGestureRecognizer *)tapGesture {
    CGPoint point= [tapGesture locationInView:self.m_bgView];
    
    //将UI坐标转化为摄像头坐标
    CGPoint cameraPoint= [self.m_preview captureDevicePointOfInterestForPoint:point];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}

#pragma mark - 视频输出代理
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    DLog(@"开始录制...");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    DLog(@"视频录制完成.");
    self.m_isRecording = NO;
    
//    //TODO 此处为测试用
//    //视频录入完成之后在后台将视频存储到相簿
//    ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc]init];
//    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
//
//        DLog(@"成功保存视频到相簿.");
//    }];
    
    if (self.m_isCompleted) {
        //set player UI
        [self playerUI];
        
        //准备播放
        [self setPlayWithOn:YES];
    }

}

@end
