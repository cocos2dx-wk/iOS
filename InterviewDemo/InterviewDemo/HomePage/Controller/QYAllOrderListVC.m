//
//  QYAllOrderListVC.m
//  QYStaging
//
//  Created by wangkai on 2017/4/24.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYAllOrderListVC.h"
#import "KYOrderListCell.h"
#import "QYOrderDetailVC.h"
#import "KYOrderListHeaderView.h"
#import "KYOrderListFooterView.h"
#import "KYListOrder.h"
#import "KYOrderGoodsList.h"
#import "QYNetManager+Certificate.h"
#import "QYNetSignProtocolVC.h"

@interface QYAllOrderListVC ()<UITableViewDelegate,UITableViewDataSource>

/* 列表*/
@property (weak, nonatomic) IBOutlet UITableView *m_tableView;
/** 订单状态 "*/
@property (assign,nonatomic) OrderStatusType m_tatusType;
/** 当前页数 */
@property(nonatomic , assign) NSInteger m_pageIndex;
/** 总数量 */
@property(nonatomic, assign) NSInteger m_totalCount;
/** 平台类型*/
@property(nonatomic, copy) NSString *m_platForm;
/** 订单列表 */
@property (strong,nonatomic) NSMutableArray *m_orderArray;

@end

@implementation QYAllOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(NSMutableArray *) m_orderArray{
    if (_m_orderArray == nil) {
        _m_orderArray = [NSMutableArray array];
    }
    return _m_orderArray ;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initUI]; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

-(void)initUI{
    //update tabeview
    self.m_tableView.delegate = self;
    self.m_tableView.dataSource = self;
    [self.m_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.m_tableView.mj_header = [WJRefresh headerWithRefreshingTarget:self refreshingAction:@selector(headerLoadOrderList)];
    self.m_tableView.mj_footer = [WJRefresh footerWithRefreshingTarget:self refreshingAction:@selector(footerLoadData)];
}

/**
 更新状态
 
 @param index index description
 */
-(void)updateStatus:(NSInteger)index{
    int indexValue = [[NSString stringWithFormat:@"%ld",(long)index] intValue];
    
    if (indexValue == 0) {
        self.m_tatusType = OrderStatusType_All;
    }else if(indexValue == 1){
        self.m_tatusType = OrderStatusType_Pending;
    }
    else if(indexValue == 2){
        self.m_tatusType = OrderStatusType_ToBeSign;
    }
    else if(indexValue == 3){
        self.m_tatusType = OrderStatusType_Completed;
    }
    else if(indexValue == 4){
        self.m_tatusType = OrderStatusType_Cancel;
    }
    [self headerLoadOrderList];
}

#pragma mark- tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [((KYListOrder *)self.m_orderArray[section]).goodsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KYOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KYOrderListCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"KYOrderListCell" owner:nil options:nil] lastObject];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    KYListOrder *tempModel = [self.m_orderArray safe_ObjectAtIndex:indexPath.section];
    if (tempModel ) {
        NSMutableArray *goodlistArray =tempModel.goodsList;
        KYOrderGoodsList *detailModel = [goodlistArray safe_ObjectAtIndex:indexPath.row];
        [cell updateUI:detailModel];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     KYListOrder* orderModel = ((KYListOrder *)self.m_orderArray[indexPath.section]) ;
     if (orderModel.orderId.length > 0) {
        self.m_platForm = orderModel.platForm;
        [self getOrderDetailWithOrderId:orderModel.orderId andPlatForm:self.m_platForm ];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.m_orderArray count];
}


//返回高度的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 103  ;
}


//header
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    KYOrderListHeaderView *orderListHeaderView =
    [[[NSBundle mainBundle] loadNibNamed:@"KYOrderListHeaderView"
                                   owner:nil
                                 options:nil] lastObject];
    KYListOrder *detailModel = [KYListOrder mj_objectWithKeyValues:[self.m_orderArray objectAtIndex:section]];
    [orderListHeaderView updateUI:detailModel];
    orderListHeaderView.hidden = YES;
    if (self.m_orderArray.count > 0) {
        orderListHeaderView.hidden = NO;
    } 
    return orderListHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.m_orderArray.count <= 0) {
        return 0;
    }
    return 40.f;
}


//footer
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
     KYOrderListFooterView *orderListFooterView =
    [[[NSBundle mainBundle] loadNibNamed:@"KYOrderListFooterView"   owner:nil options:nil] lastObject];
    KYListOrder *detailModel = [KYListOrder mj_objectWithKeyValues:[self.m_orderArray objectAtIndex:section]];
    [orderListFooterView updateUI:detailModel];
    orderListFooterView.m_statusLabel.tag = section ;
    if ([detailModel.status isEqualToString:@"1"]  ) {
 
        [orderListFooterView.m_statusLabel addTarget:self action:@selector(btnClickSign:)];
        
    }
  
    orderListFooterView.hidden = YES;
    if (self.m_orderArray.count > 0) {
        orderListFooterView.hidden = NO;
    }
    return orderListFooterView;
}

-(void)btnClickSign:(UIButton *)btn{
    NSUInteger indexPath = btn.tag ;
    KYListOrder *order =  self.m_orderArray[indexPath];
    
    NSString *orderId = order.orderId;
    QYNetSignProtocolVC *vc = [[UIStoryboard storyboardWithName:@"QYHomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"QYNetSignProtocolVC"];
    vc.m_orderId = orderId;
    vc.s_platForm = order.platForm;
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.m_orderArray.count <= 0) {
        return 0;
    }
    return 59.f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat sectionHeaderHeight = 40;
    CGFloat sectionFooterHeight = 59;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= 0 && offsetY <= sectionHeaderHeight)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
    }else if (offsetY >= sectionHeaderHeight && offsetY <= scrollView.contentSize.height - scrollView.frame.size.height - sectionFooterHeight)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
    }else if (offsetY >= scrollView.contentSize.height - scrollView.frame.size.height - sectionFooterHeight && offsetY <= scrollView.contentSize.height - scrollView.frame.size.height)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(scrollView.contentSize.height - scrollView.frame.size.height - sectionFooterHeight), 0);
    }
    
    
}
#pragma mark - 订单列表
/**
 订单状态：-1：全部订单、0:待审核、1：待网签、2：待面签、3：已完成、4：已取消
 获取订单列表
 */
- (void)headerLoadOrderList {
    NSInteger statusIndex = self.m_tatusType;
    if(statusIndex == 1){
        statusIndex = 100 ;
    }
    self.m_pageIndex = 2;
    [self showLoading];
    
    NSString *url = [NSString stringWithFormat:@"%@%@?status=%ld&page=1&size=10",app_new_orderList,verison,(long)statusIndex];
  
    NSMutableDictionary *healder = [[NSMutableDictionary alloc]init];
    
    
    healder[@"traceId"] = [[NSUUID UUID] UUIDString];
    healder[@"parentId"] = [[NSUUID UUID] UUIDString];
    
    //网络监控开始时间戳和时间
    NSUInteger startMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
    NSString *startTime = [AppGlobal getCurrentTime];
    
    QYNetManager* manager =   [QYNetManager requestManagerWithBaseUrl:myBaseUrl header:healder accpt:@"application/vnd.staging.v2+json"] ;
    
     [manager get:url params:nil success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            [self orderListSuccess:responseObject];
            NSLog(@"%@",responseObject);
        } else {
            [self orderListFail:responseObject];
        }
        [self dismissLoading];
         //接口监控
         NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
         NSString *endTime = [AppGlobal getCurrentTime];
         NSUInteger period = endMillSeconds - startMillSeconds;
         NSString *periods = [NSString stringWithFormat:@"%tu", period];
         
         [[KYMonitorManage sharedInstance] upLoadDataWithPhone:[self queryInfo].phoneNum andStatus:@"200" andArguments:nil andResult:responseObject andMethodName: NSStringFromSelector(_cmd) andClazz:NSStringFromClass([self class]) andBusiness:@"qyfq_app_new_orderList" andBusinessAlias:@"订单列表" andServiceStart:startTime andServiceEnd:endTime andElapsed:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    } failure:^(NSString * _Nullable errorString) {
        [self dismissLoading];
        [self showMessageWithString:kShowErrorMessage];
        //网络监控结束时间戳和时间
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        [self monitorReq:@"500" param:nil msg:errorString methodName:NSStringFromSelector(_cmd) className:NSStringFromClass([self class]) buName:@"qyfq_app_new_orderList" buAlias:@"订单列表" statTime:startTime endTime:endTime period:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
        
    }];
}

/**
 成功
 */
- (void)orderListSuccess:(id)responseObject {
     [self.m_orderArray removeAllObjects];
    
    NSDictionary *dic = [responseObject objectForKey:@"data"];
//    self.m_orderArray = [NSMutableArray mj_objectArrayWithKeyValuesArray:[dic objectForKey:@"orders"]];
    self.m_orderArray = [KYListOrder arrayOfModelsFromDictionaries:[dic valueForKey:@"orders"]];
    self.m_totalCount = [[dic objectForKey:@"totalCount"] integerValue];
    
    [self.m_tableView.mj_header endRefreshing];
    [self.m_tableView reloadData];
    [self dismissNoData];
    
    if (self.m_orderArray.count == 0) {
        [self showNoDataWithView:self.m_tableView
                       imageName:@"HomePage_noOrderData"
                            text:@"您还没有相关的订单"
                           isHalfSize:NO
                        delegate:nil];
        [self.m_orderArray removeAllObjects];
        [self.m_tableView reloadData];
    }else if (self.m_orderArray.count >= self.m_totalCount) {
        [self.m_tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.m_tableView.mj_footer resetNoMoreData];
    }
    
}

/**
 失败
 */
- (void)orderListFail:(id)responseObject {
    [self.m_orderArray removeAllObjects];
    if ([responseObject objectForKey:@"message"]) {
        [self showMessageWithString:[responseObject objectForKey:@"message"]];
    }
    [self.m_tableView.mj_header endRefreshing];
    [self.m_tableView reloadData];
    [self showNoDataWithView:self.m_tableView
                   imageName:@"HomePage_noOrderData"
                        text:@"您还没有相关的订单"
                    isHalfSize:NO
                    delegate:nil];
    [self.m_orderArray removeAllObjects];
    [self.m_tableView reloadData];
}

/**
 *  上拉加载
 */
-(void)footerLoadData{
    NSInteger statusIndex = self.m_tatusType;
    if(statusIndex == 1){
        statusIndex = 100 ;
    }
    [self showLoading];
    NSString *url = [NSString stringWithFormat:@"%@%@?status=%ld&page=%@&size=%@",app_new_orderList,verison,(long)statusIndex,@(self.m_pageIndex),@LoadNumber];
    NSMutableDictionary *healder = [[NSMutableDictionary alloc]init];
    
    
    healder[@"traceId"] = [[NSUUID UUID] UUIDString];
    healder[@"parentId"] = [[NSUUID UUID] UUIDString];
    
    //网络监控开始时间戳和时间
    NSUInteger startMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
    NSString *startTime = [AppGlobal getCurrentTime];
    
    QYNetManager* manager =   [QYNetManager requestManagerWithBaseUrl:myBaseUrl header:healder accpt:@"application/vnd.staging.v2+json"] ;
    
    
    
     [manager get:url params:nil success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            [self footerLoadDataSuccess:responseObject];
        } else {
            [self footerLoadDataFail:responseObject];
        }
        [self dismissLoading];
         //接口监控
         NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
         NSString *endTime = [AppGlobal getCurrentTime];
         NSUInteger period = endMillSeconds - startMillSeconds;
         NSString *periods = [NSString stringWithFormat:@"%tu", period];
         
         [[KYMonitorManage sharedInstance] upLoadDataWithPhone:[self queryInfo].phoneNum andStatus:@"200" andArguments:nil andResult:responseObject andMethodName: NSStringFromSelector(_cmd) andClazz:NSStringFromClass([self class]) andBusiness:@"qyfq_app_new_orderList" andBusinessAlias:@"订单列表" andServiceStart:startTime andServiceEnd:endTime andElapsed:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    } failure:^(NSString * _Nullable errorString) {
        [self dismissLoading];
        [self showMessageWithString:kShowErrorMessage];
        //网络监控结束时间戳和时间
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        [self monitorReq:@"500" param:nil msg:errorString methodName:NSStringFromSelector(_cmd) className:NSStringFromClass([self class]) buName:@"qyfq_app_new_orderList" buAlias:@"订单列表" statTime:startTime endTime:endTime period:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    }];
}


/**
 底部加载成功
 
 */
- (void)footerLoadDataSuccess:(id)responseObject {
    NSDictionary *dic = [responseObject objectForKey:@"data"];
    self.m_pageIndex++;
     NSMutableArray *array = [KYListOrder arrayOfModelsFromDictionaries:[dic valueForKey:@"orders"]];
    
    if (array.count > 0) {
        [self.m_orderArray addObjectsFromArray:array];
    }
    
    [self.m_tableView.mj_header endRefreshing];
    [self.m_tableView reloadData];
    self.m_totalCount = [[dic objectForKey:@"totalCount"] integerValue];

    
    if (self.m_orderArray.count == 0) {
        [self showNoDataWithView:self.m_tableView
                       imageName:@"HomePage_noOrderData"
                            text:@"您还没有相关的订单"
                      isHalfSize:NO
                        delegate:nil];
        [self.m_orderArray removeAllObjects];
        [self.m_tableView reloadData];
        return ;
    }else if (self.m_orderArray.count >= self.m_totalCount) {
        [self.m_tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.m_tableView.mj_footer resetNoMoreData];
    }
    
}

/**
 底部加载失败
 */
- (void)footerLoadDataFail:(id)responseObject {
    if ([responseObject objectForKey:@"message"]) {
        [self showMessageWithString:[responseObject objectForKey:@"message"]];
    }
    [self.m_tableView.mj_footer endRefreshing];
    self.m_pageIndex--;
}

#pragma mark- 订单详情
-(void)getOrderDetailWithOrderId:(NSString *)orderId andPlatForm:(NSString *)platForm{
    [self showLoading];
//    NSString *url = [NSString stringWithFormat:@"%@%@?orderId=%@&fromType=0&platForm=%@",app_new_orderDetail,verison,orderId,platForm];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",app_new_orderDetail,verison];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"orderId"] = orderId;
    parameters[@"fromType"] = @(0);
    parameters[@"platForm"] = platForm;
    
    [[QYNetManager requestManagerWithBaseUrl:myBaseUrl] get:url params:parameters success:^(id  _Nullable responseObject) {;
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            [self orderDetailSuccess:responseObject];
        } else {
            [self orderDetailFail:responseObject];
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
- (void)orderDetailSuccess:(id)responseObject {
    
    if ([[responseObject valueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
        QYOrderDetailVC *vc = [[UIStoryboard storyboardWithName:@"QYHomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"QYOrderDetailVC"];
        vc.s_orderDetailModel = [QYOrderDetailModel mj_objectWithKeyValues:[responseObject valueForKey:@"data"]];
        vc.s_fromViewController = self;
        vc.s_platForm = self.m_platForm;
        vc.backData = ^(){
           [self.m_tableView.mj_header beginRefreshing];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/**
 失败
 */
- (void)orderDetailFail:(id)responseObject {
    if ([responseObject objectForKey:@"message"]) {
        [self showMessageWithString:[responseObject objectForKey:@"message"]];
    }
}

@end
