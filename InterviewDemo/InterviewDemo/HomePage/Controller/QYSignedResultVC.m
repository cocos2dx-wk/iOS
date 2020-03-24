//
//  QYSignedResultVC.m
//  QYStaging
//
//  Created by Jyawei on 2017/7/17.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYSignedResultVC.h"

@interface QYSignedResultVC ()

/** 时间 */
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
/** 定时器 */
@property (strong, nonatomic) NSTimer *timer;
/** 定时时间 */
@property(nonatomic, assign) NSInteger times;

@end

@implementation QYSignedResultVC

+ (instancetype)vc {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"QYHomePage" bundle:nil];
    return [sb instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set title
    self.navigationItem.title = @"订单分期";
    
    self.leftButton.hidden = YES;
    
    //完成按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClicked:)];
    self.navigationItem.rightBarButtonItem.tintColor = color_blueButtonColor;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    //自动化测试id
    [self.navigationItem.rightBarButtonItem setAccessibilityIdentifier:@"tv_title_right_text"];
    
    [self startTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 点击完成
 */
- (void)rightButtonClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    [self stopTimer];
    
    sender.enabled = YES;
}

#pragma mark- 定时器
/**
 *   启动时钟
 */
- (void)startTimer {
    if (self.timer) {
        return;
    }
    self.times = 3;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target:self
                                                  selector:@selector(execute)
                                                  userInfo:nil
                                                   repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 *   时钟执行
 */
- (void)execute {
    if (self.times == 0) {
        [self stopTimer];
        return;
    }
    self.times--;
    self.timeLable.text = [NSString stringWithFormat:@"%ld秒",(long)self.times];
    if (self.times <= 0) {
        [self stopTimer];
    }
}

/**
 *   停止时钟
 */
- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
    [self.navigationController popToRootViewControllerAnimated:YES] ;
    
    [AppGlobal gotoHomePage];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
