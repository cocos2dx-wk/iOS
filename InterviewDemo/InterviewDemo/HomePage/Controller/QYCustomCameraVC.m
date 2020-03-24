//
//  QYCustomCameraVC.m
//  QYStaging
//
//  Created by Jyawei on 2017/8/21.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYCustomCameraVC.h"

@interface QYCustomCameraVC ()

@property (nonatomic, strong)AVCaptureSession *session;
/** AVCaptureSession对象来执行输入设备和输出设备之间的数据传递 */
@property (nonatomic, strong)AVCaptureDeviceInput *videoInput;
/** AVCaptureDeviceInput对象是输入流 */
@property (nonatomic, strong)AVCaptureStillImageOutput *stillImageOutput;
/** 照片输出流对象 */
@property (nonatomic, strong)AVCaptureVideoPreviewLayer *previewLayer;
/** 拍照按钮 */
@property (nonatomic, strong)UIButton *shutterButton;
/** 取消按钮 */
@property (nonatomic, strong)UIButton *cancelButton;

@property (nonatomic, strong)UIView *cameraShowView;

@property (nonatomic,strong) UIImage *image;

@end

@implementation QYCustomCameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置横竖屏配置
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = 1;
    
    [self initialSession];
    
    //放置预览图层的View
    _cameraShowView = [[UIView alloc]init];
    _cameraShowView.frame = CGRectMake(0, 0 ,appHeight, appWidth);
    [self.view addSubview:_cameraShowView];
    
    //取消按钮
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame = CGRectMake(appHeight - 80, 50, 50, 50);
    self.cancelButton.centerY = appWidth/4 - 20;
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.view addSubview:self.cancelButton];
    
    [self.cancelButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    
    //拍照按钮
    self.shutterButton = [[UIButton alloc] initWithFrame:CGRectMake(appHeight - 80, 150, 50, 50)];
    self.shutterButton.centerY = appWidth/2;
    [self.shutterButton setImage:[UIImage imageNamed:@"Common_camera"] forState:UIControlStateNormal];
    [self.view addSubview:self.shutterButton];
    
    [self.shutterButton addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
    
    //自动化测试id
    [self.cancelButton setAccessibilityIdentifier:@"tv_cancel"];
    [self.shutterButton setAccessibilityIdentifier:@"take_pic"];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setUpCameraLayer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: animated];
    
    if (self.session) {
        [self.session stopRunning];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initialSession {
    
    //这个方法的执行我放在init方法里了
    self.session = [[AVCaptureSession alloc] init];
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:nil];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    //这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    [self.session startRunning];
    
    AVCaptureConnection *output2VideoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    output2VideoConnection.videoOrientation = [self videoOrientationFromCurrentDeviceOrientation];
}

- (void)setUpCameraLayer {
    
    if (self.previewLayer == nil) {
        
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        UIView *view = self.cameraShowView;
        CALayer *viewLayer = [view layer];
        [viewLayer setMasksToBounds:YES];
        
        [self.previewLayer setFrame:CGRectMake(0, 0, appWidth, appHeight)];
        [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
        self.previewLayer.connection.videoOrientation = [self videoOrientationFromCurrentDeviceOrientation];
        
        [viewLayer insertSublayer:self.previewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
    }
}

- (AVCaptureVideoOrientation) videoOrientationFromCurrentDeviceOrientation {
    
    switch (self.interfaceOrientation) {
        case UIInterfaceOrientationPortrait: {
            return AVCaptureVideoOrientationPortrait;
            break;
        }
        case UIInterfaceOrientationLandscapeLeft: {
            return AVCaptureVideoOrientationLandscapeLeft;
            break;
        }
        case UIInterfaceOrientationLandscapeRight: {
            return AVCaptureVideoOrientationLandscapeRight;
            break;
        }
        case UIInterfaceOrientationPortraitUpsideDown: {
            return AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        }
        default:
            break;
    }
    
    return AVCaptureVideoOrientationLandscapeLeft;
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice *)frontCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

- (void)closeView {
    
    //设置横竖屏配置
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    delegate.allowRotation = 0;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)toggleCamera {
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        NSError *error;
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = [[_videoInput device] position];
        
        if (position == AVCaptureDevicePositionBack)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:&error];
        else if (position == AVCaptureDevicePositionFront)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:&error];
        else
            return;
        
        if (newVideoInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:self.videoInput];
            if ([self.session canAddInput:newVideoInput]) {
                [self.session addInput:newVideoInput];
                [self setVideoInput:newVideoInput];
            } else {
                [self.session addInput:self.videoInput];
            }
            [self.session commitConfiguration];
        } else if (error) {
            DLog(@"toggle carema failed, error = %@", error);
        }
    }
}

- (void)shutterCamera {
    
    AVCaptureConnection * videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        DLog(@"take photo failed!");
        return;
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage * image = [UIImage imageWithData:imageData];
        self.image = image;
        [self finishPicking:image];
    }];
}

- (void)finishPicking:(UIImage *)image {
    self.photoBlock(image);
    [self closeView];
}


#pragma mark Orientations

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation != UIInterfaceOrientationLandscapeLeft
            || interfaceOrientation != UIInterfaceOrientationLandscapeRight);
}


#pragma mark - Navigation
 

@end
