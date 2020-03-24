//
//  BViewController.m
//  InterviewDemo
//
//  Created by 王凯 on 2020/3/20.
//  Copyright © 2020 王凯. All rights reserved.
//

#import "BViewController.h"

@interface BViewController ()


@end

@implementation BViewController

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
    
    NSLog(@"B viewDidLoad 载入完成");
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"B viewWillAppear 视图即将出现");
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSLog(@"B viewDidAppear 视图已经渲染完成");
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    NSLog(@"B viewWillDisappear 视图将被移除");
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    NSLog(@"B viewDidDisappear 视图已经被移除");
}

-(void)dealloc{
    NSLog(@"B dealloc");
}


- (IBAction)onPopClicked:(id)sender {
    NSLog(@"pop");
    [self.navigationController popViewControllerAnimated:YES];
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
