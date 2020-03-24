//
//  QYSelectedBankVC.m
//  QYStaging
//
//  Created by wangkai on 2017/4/13.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYSelectedBankVC.h"
#import "QYBankListCell.h"

@interface QYSelectedBankVC ()<UITableViewDelegate,UITableViewDataSource>

/* 储蓄卡描述*/
@property (weak, nonatomic) IBOutlet UILabel *m_tab1Label;
/* 信用卡描述*/
@property (weak, nonatomic) IBOutlet UILabel *m_tab2Label;
/* 储蓄卡标图*/
@property (weak, nonatomic) IBOutlet UIImageView *m_selected1Img;
/* 信用卡标图*/
@property (weak, nonatomic) IBOutlet UIImageView *m_selected2Img;
/* 列表*/
@property (weak, nonatomic) IBOutlet UITableView *m_tableView;
/* 当前选中*/
@property (assign,nonatomic) int m_selectedIndex;


@end

@implementation QYSelectedBankVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化UI
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //set nav title
    self.navigationItem.title = @"选择银行";
}


/**
 初始化UI
 */
-(void)initUI{
    //默认储蓄卡
    [self selectedTabWithType:1];
    self.m_selectedIndex = 1;
    
    //set delegate
    self.m_tableView.delegate = self;
    self.m_tableView.dataSource = self;
    self.m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.m_tableView.showsVerticalScrollIndicator = NO;
    //自动化测试id
    [self.m_tableView setAccessibilityIdentifier:@"lv_bank"];
}

/**
 点击储蓄卡

 @param sender sender description
 */
- (IBAction)onTab1Clicked:(UIButton *)sender {
    sender.enabled = NO;
    
    if (self.m_selectedIndex != 1) {
        [self selectedTabWithType:1];
    }
    
    sender.enabled = YES;
}


/**
 点击信用卡

 @param sender sender description
 */
- (IBAction)onTab2Clicked:(UIButton *)sender {
    sender.enabled = NO;
    
    if (self.m_selectedIndex != 2) {
        [self selectedTabWithType:2];
    }
    
    sender.enabled = YES;
}


/**
 tab控制
1,储蓄卡 2,信用卡
 @param index 选中的tabIndex
 */
-(void)selectedTabWithType:(int)index{
    self.m_tab1Label.textColor = [UIColor colorWithMacHexString:@"333333"];
    self.m_tab2Label.textColor = [UIColor colorWithMacHexString:@"333333"];
    self.m_selected1Img.hidden = YES;
    self.m_selected2Img.hidden = YES;
    
    if (index == 1) {//储蓄卡
        self.m_tab1Label.textColor = color_blueButtonColor;
        self.m_selected1Img.hidden = NO;
    }else if (index == 2){//信用卡
        self.m_tab2Label.textColor = color_blueButtonColor;
        self.m_selected2Img.hidden = NO;
    }
    self.m_selectedIndex = index;
}

#pragma mark- tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.s_bankArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QYBankListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYBankListCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"QYBankListCell" owner:nil options:nil] lastObject];
    }
    cell.s_bankNameLabel.text = [self.s_bankArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.selectedDelegate respondsToSelector:@selector(selectedItemWithName:andItemType:)]) {
        [self.selectedDelegate selectedItemWithName:[self.s_bankArray objectAtIndex:indexPath.row] andItemType:[NSString stringWithFormat:@"%d",self.m_selectedIndex]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
