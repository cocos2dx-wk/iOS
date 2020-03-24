//
//  ViewController.m
//  InterviewDemo
//
//  Created by 王凯 on 2020/3/20.
//  Copyright © 2020 王凯. All rights reserved.
//

#import "ViewController.h"
#import "BViewController.h"
#import "MsgSDK.framework/Headers/MsgSDK.h"
#import "MsgStaticSDK/MsgStaticSDK.h"

@interface ViewController ()

@end

@implementation ViewController


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
   self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    NSLog(@"%s",__func__);
    return self;
}

-(instancetype)init{
    self = [super init];
    NSLog(@"%s",__func__);
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    NSLog(@"%s",__func__);
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    NSLog(@"%s",__func__);
}

-(void)loadView{
    [super loadView];
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"A viewDidLoad 载入完成");//1
    
    [MsgUtil sayHelloMsg:@"wangkai"];
    
    [MsgStaticSDK sayStaticHello:@"hi"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"A viewWillAppear 视图即将出现");//2
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSLog(@"A viewDidAppear 视图已经渲染完成");//3
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    NSLog(@"A viewWillDisappear 视图将被移除");
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    NSLog(@"A viewDidDisappear 视图已经被移除");
}

-(void)dealloc{
    NSLog(@"A dealloc");
}

- (IBAction)onAPushClicked:(UIButton *)sender {
//    sender.enabled = NO;
    
    BViewController *bViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BViewController"];
//    [bViewController loadView];
    bViewController.m_titleLabel.text = @"改变文字";
    [self.navigationController pushViewController:bViewController animated:YES];
    NSLog(@"push");
    
//    sender.enabled = YES;
}

@end
