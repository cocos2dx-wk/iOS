//
//  QYAllOrderMainVC.m
//  QYStaging
//
//  Created by wangkai on 2017/4/24.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYAllOrderMainVC.h"
#import "ZJSegmentStyle.h"
#import "ZJScrollPageView.h"
#import "QYAllOrderListVC.h"

@interface QYAllOrderMainVC ()<ZJScrollPageViewDelegate>

@property (nonatomic,strong) NSArray *m_titles;

@end

@implementation QYAllOrderMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self.leftButton setAccessibilityIdentifier:@"iv_title_left_icon"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //set title
    self.navigationItem.title = @"我的订单";
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

-(void)initUI{
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    
    //显示滚动条
    style.showLine = YES;
    
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    style.scrollTitle = NO;
    style.normalTitleColor = [UIColor colorWithHexString:@"333333"];
    style.selectedTitleColor = [UIColor colorWithHexString:@"7363EB"];
    style.scrollLineColor = [UIColor colorWithHexString:@"7363EB"];
    style.scrollLineHeight = 3.f;
    style.titleFont = [UIFont systemFontOfSize:15];
    style.segmentHeight = 50;
    style.contentViewBounces = NO;
    self.m_titles = @[@"全部",@"待审核",@"待签约",@"已完成",@"已取消"];
    
    style.adjustCoverOrLineWidth = YES ;
    
    // 初始化
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64.0) segmentStyle:style titles:self.m_titles parentViewController:self delegate:self];
        
    [self.view addSubview:scrollPageView];
    [scrollPageView setSelectedIndex:0 animated:YES];
}

#pragma mark - ZJScrollPageViewDelegate
- (NSInteger)numberOfChildViewControllers {
    return self.m_titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    QYAllOrderListVC<ZJScrollPageViewChildVcDelegate> *childVc = (QYAllOrderListVC*)reuseViewController;
    
    if (!childVc) {
        childVc = [[UIStoryboard storyboardWithName:@"QYHomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"QYAllOrderListVC"];
        [childVc updateStatus:index];
    }else{
        [childVc updateStatus:index];
    }
    
    return childVc;
}

@end
