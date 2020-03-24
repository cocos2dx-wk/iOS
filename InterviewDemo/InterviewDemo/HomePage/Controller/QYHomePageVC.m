//
//  QYHomePageVC.m
//  QYStaging
//
//  Created by wangkai on 2017/3/13.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYHomePageVC.h" 
#import "QYCreditEvaluationMainVC.h"
#import "QYScannerVC.h"
#import "MACWaveView.h"
#import "QYOrderCell.h"
#import "QYAllOrderMainVC.h"
#import "QYOrderDetailVC.h"
#import "QYWebViewVC.h"
#import "QYProductDetailModel.h"
#import "QYNoNetWorkView.h"
#import "QYAddAssetsInfoVC.h"
#import "QYAddFinancialInfoVC.h"
#import "QYMyBillVC.h"
#import "QYVersionUpdateModel.h"
#import "QYUpdateView.h"
#import "QYSelectedIdCardVC.h"
#import "QYActiveVC.h"
#import "ZXCycleScrollView.h"
#import "QYTypeCell.h"
#import "QYTypeInfo.h"
#import "QYHomeCategoriesModel.h"
#import "QYRecommendModel.h"
#import "QYHomeCommonCell.h"
#import "QYHomeListView.h"
#import "QYTypeListModel.h"
#import "KYGoodsListVC.h"
#import "QYProductDetailVC.h"
#import "QYLoginVC.h"
#import "QYOrderConfirmVC.h"
#import <objc/runtime.h>
#import "KYMonthBillVC.h"
#import "KYChooseCarVC.h"

#define TAG_GUIDE 100
#define TAG_NONETVIEW 101

@interface QYHomePageVC ()<CLLocationManagerDelegate,UINavigationControllerDelegate,ZXCycleScrollViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UIScrollViewDelegate,UITableViewDelegate>
{
    CLLocationManager * _locationManager;
}

/* 未评估*/
@property (weak, nonatomic) IBOutlet UIView *m_unAssessmentView;
/* 评估中*/
@property (weak, nonatomic) IBOutlet UIView *m_asseaamentingView;
/** 审核状态 */
@property (nonatomic,assign)QYCreditAssessType m_assessType;
/** 重新评估 */
@property (weak, nonatomic) IBOutlet UIView *m_reAssessmentView;
/** 补充资料背景 */
@property (weak, nonatomic) IBOutlet UIView *m_addInfoBgView;
/** 补充资料高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_addInfoBgViewHeightConstraint;
/** 补充资料种类 */
@property (nonatomic,assign) QYAddInfoType m_addInfoType;
/** 无网view */
@property (strong,nonatomic) QYNoNetWorkView *m_noNetWorkView;
/** 分数不足不能分期页面 */
@property (weak, nonatomic) IBOutlet UIView *m_errorView;
/** 版本更新框是否弹出 */
@property (assign,nonatomic) BOOL m_isVersionUpdatePop;
/** 登录页 */
@property (weak, nonatomic) IBOutlet UIView *m_loginView;
/** 评估签约页 */
@property (weak, nonatomic) IBOutlet UIView *m_signView;
/** 重新激活页 */
@property (weak, nonatomic) IBOutlet UIView *m_reActiveView;
/** 新账单 */
@property (weak, nonatomic) IBOutlet UIView *m_newBillView;
/** 评估状态高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_statusHeightConstraint;
/** 评估状态view */
@property (weak, nonatomic) IBOutlet UIView *m_statusView;
/** banner距离蓝色背景 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_bannerToTopConstraint;
/** banner 背景 view */
@property (weak, nonatomic) IBOutlet UIView *m_bannerBgView;
/** banner view */
@property (weak, nonatomic) IBOutlet UIView *m_bannerView;
@property (strong,nonatomic)ZXCycleScrollView *m_myBannerView;
/** banner array  */
@property (strong,nonatomic)NSMutableArray *m_bannerArray;
/* 内容页 */
@property (weak, nonatomic) IBOutlet UIView *m_contentView;
/* 主列表 */
@property (weak, nonatomic) IBOutlet UITableView *m_mainTableView;
/* banner高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_branerHeightConstraint;

/** -----------------适配在线信用评估------------------------ */
// 信审评估label
@property (weak, nonatomic) IBOutlet UILabel *m_line_credit_lable;
// 立即信审btn
@property (weak, nonatomic) IBOutlet UIButton *m_right_now_btn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_right_now_constraint;

/** -----------------账单元素------------------------ */
/** 未出账单view */
@property (weak, nonatomic) IBOutlet UIView *m_billOutView;
/** 已出账单view */
@property (weak, nonatomic) IBOutlet UIView *m_billInView;
/** 平台类型 */
@property (nonatomic,copy)NSString *m_platForm;
//未出账单
/** 月份 */
@property (weak, nonatomic) IBOutlet UILabel *m_monthLabel;
/** 账单日 */
@property (weak, nonatomic) IBOutlet UILabel *m_stateMentLabel;
/** 未出账单金额 */
@property (weak, nonatomic) IBOutlet UILabel *m_stateMentAmountLabel;
//已出账单
/** 月份 */
@property (weak, nonatomic) IBOutlet UILabel *m_alreadyMontyLabel;
/** 已出账单金额 */
@property (weak, nonatomic) IBOutlet UILabel *m_billAmountLabel;
/** 剩余应还账单金额 */
@property (weak, nonatomic) IBOutlet UILabel *m_surplusAmountLabel;
/** 违约view */
@property (weak, nonatomic) IBOutlet UIView *m_breachView;
/** 违约天数 */
@property (weak, nonatomic) IBOutlet UILabel *m_breachDateLabel;
/** 减免高度 40*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_reductionHeightConstraint;
/** 违约滞纳高度 40*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_lateHeightConstraint;
/** 违约金 */
@property (weak, nonatomic) IBOutlet UILabel *m_breachAmountLabel;
/** 滞纳金 */
@property (weak, nonatomic) IBOutlet UILabel *m_lateDateAmountLabel;
/** 减免描述 */
@property (weak, nonatomic) IBOutlet UILabel *m_reductionDescLabel;
/** 减免view */
@property (weak, nonatomic) IBOutlet UIView *m_reductionDescView;
/** 减免有效时间 */
@property (copy, nonatomic) NSString *m_reductionEndStr;
/** 违约金减免金额 */
@property (copy, nonatomic) NSString *m_breachAmountStr;
/** 滞纳金减免金额 */
@property (copy, nonatomic) NSString *m_lateDateAmountStr;
/** 还款中view */
@property (weak, nonatomic) IBOutlet UIView *m_repayMentView;
/** 已出账单id */
@property (copy, nonatomic) NSString *m_billingProcessGuidStr;
/** 已出账单状态 */
@property (copy, nonatomic) NSString *m_billStatus;
/** 已出账单账单金额约束*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_alreadyBillLabelToCenterXContraint;

/**---------------------合同审核元素---------------------*/
/** 评估签约状态 */
@property (nonatomic,assign)activationStatus activationStatus;
/** 审核状态 */
@property (nonatomic,assign)contractAuditStatus auditStatus;

/**---------------------8大分类---------------------*/
/** collectionView */
@property (weak, nonatomic) IBOutlet UICollectionView *m_collectionView;
/** 8大类数据源 */
@property(nonatomic,strong)NSMutableArray *m_categoriesArray;
/** 8大类高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_categoryHeightConstraint;

/**---------------------热门推荐---------------------*/
/** 热门推荐数据源 */
@property(nonatomic,strong)NSMutableArray *m_recommendArray;
/** 热门推荐view */
@property (weak, nonatomic) IBOutlet UIView *m_recommendView;
/** 热门推荐scrollviewview */
@property (weak, nonatomic) IBOutlet UIScrollView *m_recommendscrollview;

/**---------------------分类列表---------------------*/
/** 分类列表 */
@property (weak, nonatomic) IBOutlet UIView *m_listView;
/** 列表高度 294 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_listHeightConstraint;
/** 分类列表数据源 */
@property(nonatomic,strong)NSMutableArray *m_typeListArray;

/**---------------------其他---------------------*/
/** 地图管理器 */
@property (nonatomic,strong)CLLocationManager *locMgr;
/** 设置定位次数 */
@property (nonatomic,assign) BOOL exist;
/** 纬度 */
@property (nonatomic, assign) CLLocationDegrees latitude;
/** 经度 */
@property (nonatomic, assign) CLLocationDegrees longitude;
/** 省份 */
@property (nonatomic,copy) NSString *province;
/** 城市 */
@property (nonatomic,copy) NSString *city;
/** 根据权限设置定位 */
@property (nonatomic,assign) BOOL isLocation;
/* 是否上传过身份证照片 */
@property (nonatomic,copy) NSString *isHaveIdCardPhoto;
/* 身份证补录提示 */
@property (nonatomic,copy) NSString *remark;
/* 是否活体检测 */
@property (nonatomic,copy) NSString *isFaceAuth;
/* 审核状态 */
@property (nonatomic,copy) NSString *isAuditStatus;
/* 个人信息 */
@property (nonatomic,strong) UserInfo *m_userInfo;
/* 恭喜您 */
@property (weak, nonatomic) IBOutlet UILabel *m_activeLabel1;
/* 信用评估已通过,激活后可使用 */
@property (weak, nonatomic) IBOutlet UILabel *m_activeLabel2;
/* 不符合产品分期准入资格,请咨询 */
@property (weak, nonatomic) IBOutlet UILabel *m_statusLabel1;
/* 400-100-8899 */
@property (weak, nonatomic) IBOutlet UILabel *m_statusLabel2;
/* 信用评估审核未通过,您可再次申请 */
@property (weak, nonatomic) IBOutlet UILabel *m_statusLabel3;
/* 抱歉,您的合同审核后被驳回 */
@property (weak, nonatomic) IBOutlet UILabel *m_statusLabel4;
/* 接口请求次数 */
@property (nonatomic,assign) NSInteger m_count;
/* 补充资料接口是否请求成功 */
@property (nonatomic,assign) BOOL m_isSupplement;

@end

@implementation QYHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化UI
    [self initUI];
    
    //TODO 测试openresty
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = [UIColor greenColor];
    btn.center = self.view.center;
    btn.frame = CGRectMake(0, 0, 100, 200);
    [btn setTitle:@"点我" forState:UIControlStateNormal];
    [btn setTintColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(onTipClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
}

#pragma mark- 按钮点击事件
-(void)onTipClicked:(id)sender{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"platformName"] = @"qyfqiOS";
    parameters[@"version"] = @"2.2.0";
    parameters[@"ssoid"] = @"123456";
#ifdef ENVIRONMENT_TEST
    
    [[QYNetManager requestManagerWithBaseUrl:grayScaleUrl] get:@"api/grayscale" params:parameters success:^(id  _Nullable responseObject) {
        NSArray *array = responseObject[@"data"];
        NSDictionary *dic = [array objectAtIndex:0];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[dic valueForKey:@"funName"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
    } failure:^(NSString * _Nullable errorString) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"失败了就是失败了" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
#endif

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showStatusBar];
    
    self.m_count = 0;

    //show scanner
    [self postNotificationName:kCENTERNOTHIDDENNotification];

    //set reset
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.alpha = 1;
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSForegroundColorAttributeName : [UIColor colorWithMacHexString:@"333333"],
                                                                    NSFontAttributeName : [UIFont systemFontOfSize:17]
                                                                    };

    //check update
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *isShowUpdate = [defaults objectForKey:@"isShowUpdate"];
    if (![isShowUpdate isEqualToString:@"1"]) {
        [self getVersionInfo];
    }
    
    //保存登录状态
    NSString *isLogin = [defaults objectForKey:@"isLogin"];
    if ([isLogin isEqualToString:@"1"]) {
        //更新登录状态
        self.m_userInfo.isLogin = @"1";//未登录
    }else{
        //更新登录状态
        self.m_userInfo.isLogin = @"0";//未登录
    }
    [self updateInfo:self.m_userInfo];
    
    //token 未失效
    TOKEN_INVALID = @"1";
    
    //show bar
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //设置状态栏
    [self setStatusBarBackgroundColor:[UIColor colorWithHexString:@"876aee"]];
    
    //补充资料背景
    if (!self.m_isSupplement) {
        self.m_addInfoBgView.hidden = YES;
        self.m_addInfoBgViewHeightConstraint.constant = 0;
    }
    
    
    //更新banner位置
    self.m_bannerToTopConstraint.constant =  [self getHeightTop];
    [self updateHeight];
    
    //是否功能维护中
//    [self getDowntime];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    //reset bar
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    if ([viewController isKindOfClass:[QYHomePageVC class]]) {
        [navigationController setNavigationBarHidden:YES animated:animated];
    } else if ([navigationController isNavigationBarHidden]) {
        [navigationController setNavigationBarHidden:NO animated:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
- (CLLocationManager *)locMgr {
    if (_locMgr == nil) {
            _locMgr = [[CLLocationManager alloc]init];
            _locMgr.delegate = self;
        }
    return _locMgr;
}

/**
 初始化UI
 */
- (void)initUI {
    self.navigationController.delegate = self;
    
    //适配
    if (iphone6Plus) {
        self.m_branerHeightConstraint.constant = 120;
        [self.m_bannerBgView layoutIfNeeded];
    }
    if (iphone5) {
        self.m_line_credit_lable.font = [UIFont systemFontOfSize:11];
        self.m_right_now_btn.titleLabel.font = [UIFont systemFontOfSize:11];
        self.m_right_now_constraint.constant = 68 ;
        self.m_activeLabel1.font = [UIFont systemFontOfSize:12];
        self.m_activeLabel2.font = [UIFont systemFontOfSize:12];
        self.m_statusLabel1.font = [UIFont systemFontOfSize:12];
        self.m_statusLabel2.font = [UIFont systemFontOfSize:12];
        self.m_statusLabel3.font = [UIFont systemFontOfSize:10];
        self.m_statusLabel4.font = [UIFont systemFontOfSize:12];
    }
    
     //set title
    self.navigationItem.title = @"";
    
    //补充资料背景
    self.m_addInfoBgView.hidden = YES;
    self.m_addInfoBgViewHeightConstraint.constant = 0;
    self.m_isSupplement = NO;
    
    //主tabeview隐藏滑动条
    self.m_mainTableView.showsVerticalScrollIndicator = NO;
    self.m_mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.m_mainTableView.mj_header = [WJRefresh headerWithRefreshingTarget:self refreshingAction:@selector(onRefreshHomePage)];
    self.m_mainTableView.delegate = self;
    
    //collectionView
    self.m_collectionView.delegate = self;
    self.m_collectionView.dataSource = self;
    [self.m_collectionView registerNib:[UINib nibWithNibName:@"QYTypeCell" bundle:nil] forCellWithReuseIdentifier:@"QYTypeCell"];
    
    //add obser
    [NotificationCenter addObserver:self selector:@selector(onAutoLogin:) name:kGOTOLOGINNotification object:nil];
    [NotificationCenter addObserver:self selector:@selector(onReFreshStatus:) name:kREFRESHHOMENotification object:nil];
    
    //add obser
    [NotificationCenter addObserver:self selector:@selector(onGuidePop:) name:kFLOATLAYERNotification object:nil];
    self.m_billOutView.hidden = YES;//已出账单
    self.m_billInView.hidden = YES;//未出账单
    
    //更新banner
    self.m_myBannerView = [ZXCycleScrollView  initWithFrame:CGRectMake(0, 0, appWidth, self.m_bannerView.frame.size.height) withMargnPadding:10 withImgWidth:appWidth - 40 dataArray:nil] ;
    self.m_myBannerView.delegate = self;
    self.m_myBannerView.sourceDataArr = @[[UIImage imageNamed:@"HomePage_defaultBanner"]];
    self.m_myBannerView.autoScroll = YES;
    self.m_myBannerView.autoScrollTimeInterval = 5;
    self.m_myBannerView.backgroundColor = [UIColor colorWithHexString:@"f2f5f9"];
    [self.m_bannerView addSubview:self.m_myBannerView];

    
    //初始化数组
    self.m_categoriesArray = [NSMutableArray arrayWithCapacity:8];
    self.m_bannerArray = [NSMutableArray arrayWithCapacity:10];
    self.m_recommendArray = [NSMutableArray arrayWithCapacity:10];
    self.m_typeListArray = [NSMutableArray arrayWithCapacity:10];
    
    //初始UI
    [self setDefaultUI];
    
    //整体loading
    [self showLoading];
    
    //取banner图
    [self getBannerList];
    
    //取首页8大类
    [self getCategories];
    
    //热门推荐
    [self getRecommend];
    
    //分类列表
    [self getListData];
    
    //定位授权
    [self setLocation];
    
    //未登录去登录
    self.m_userInfo = [self queryInfo];
    if ([self.m_userInfo.isLogin isEqualToString:@"1"]) {
        //已登录请求信用评估
        self.m_loginView.hidden = YES;
        
        //请求信用评估状态
        [self requestUserAssessStatus];
        
        //请求信用评估信息
        [self getCreditInfo];
        
        //请求实名认证信息
        [self checkAuthInfo];
    }else{
        self.m_loginView.hidden = NO;
    }
}

/**
 UI初始样式
 */
- (void)setDefaultUI {
    //set Default UI
    self.m_unAssessmentView.hidden = YES;
    self.m_asseaamentingView.hidden = YES;
    self.m_signView.hidden = YES;
    self.m_reActiveView.hidden = YES;
    self.m_reAssessmentView.hidden = YES;
    self.m_errorView.hidden = YES;
    self.m_statusHeightConstraint.constant = 50;
    self.m_loginView.hidden = NO;
    
    //账单 default UI
    self.m_breachView.layer.cornerRadius = 2;
    self.m_repayMentView.layer.cornerRadius = 2;
    self.m_billInView.hidden = YES;
    self.m_billOutView.hidden = YES;
    self.m_breachAmountLabel.hidden = YES;
    self.m_lateDateAmountLabel.hidden = YES;
    self.m_reductionDescView.hidden = YES;
    self.m_breachView.hidden = YES;
    self.m_repayMentView.hidden = YES;
    self.m_newBillView.hidden = YES;
    
    //更新banner位置
    self.m_bannerToTopConstraint.constant =  [self getHeightTop];
    
    //无网view
    UIView *noNetWorkView = [self.view viewWithTag:TAG_NONETVIEW];
    if (noNetWorkView) {
        [noNetWorkView removeFromSuperview];
    }
    self.m_noNetWorkView = [[[NSBundle mainBundle] loadNibNamed:@"QYNoNetWorkView"
                                                             owner:nil
                                                           options:nil] lastObject];
    CGRect frame = self.view.bounds;
    self.m_noNetWorkView.hidden = YES;
    self.m_noNetWorkView.frame = frame;
    self.m_noNetWorkView.tag = TAG_NONETVIEW;
    [self.m_noNetWorkView.m_refreshButton addTarget:self action:@selector(onRefreshClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.m_noNetWorkView];
    
}

#pragma mark- 首页下拉刷新
-(void)onRefreshHomePage{
    
    [self.m_mainTableView.mj_header endRefreshing];
    
    [self updateData];
}

#pragma mark- 自动登录
- (void)onAutoLogin:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    
    //只有登录成功执行此操作
    [self createUserInfoCache];
    UserInfo *info = [self queryInfo];
    info.token = [[dic valueForKey:@"data"] valueForKey:@"token"];
    info.isLogin = @"1";//已登录
    info = [info loadDataFromkeyValues:[[dic valueForKey:@"data"] valueForKey:@"user"]];
    [self updateInfo:info];
    
    //保存登录状态
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1" forKey:@"isLogin"];
    [defaults synchronize];
    
    //保存至coredata
    LoginDataTable* loginData = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"LoginDataTable"
                                 inManagedObjectContext:[CoreDataManager shareInstance].managedObjectContext];
    loginData.clientToken = info.token;
    [[CoreDataManager shareInstance] save];
    
    if (info.token.length > 0) {
        //整体loading
        [self showLoading];
        
        //请求信用评估状态
        [self requestUserAssessStatus];
        
        //请求信用评估信息
        [self getCreditInfo];
        
        //请求实名认证信息
        [self checkAuthInfo];
        
        //自动登录弹出1次
        [self getVersionInfo];
    }
}

#pragma mark- 更新首页状态
- (void)onReFreshStatus:(NSNotification *)notification{
    //恢复初始UI
    [self setDefaultUI];
    
    //刷新数据
    [self updateData];
}

#pragma mark-刷新数据
-(void)updateData{
    //保存登录状态
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *isLogin = [defaults objectForKey:@"isLogin"];
    self.m_count = 0;
    self.m_isSupplement = NO;
    
    //整体loading
    [self showLoading];
    
    //取banner图
    [self getBannerList];
    
    //取首页8大类
    [self getCategories];
    
    //热门推荐
    [self getRecommend];
    
    //分类列表
    [self getListData];
    
    if ([isLogin isEqualToString:@"1"]) {
        //更新登录状态
        self.m_userInfo.isLogin = @"1";//未登录
        [self updateInfo:self.m_userInfo];
        
        //请求信用评估状态
        [self requestUserAssessStatus];
        
        //请求信用评估信息
        [self getCreditInfo];

        //请求实名认证信息
        [self checkAuthInfo];
    }else{
        //更新登录状态
        self.m_userInfo.isLogin = @"0";//未登录
        [self updateInfo:self.m_userInfo];
        
        //初始UI
        [self setDefaultUI];
    }
}

#pragma mark- 根据授权类型改变相应UI和逻辑
/**
 根据授权类型改变相应UI和逻辑
 //0, "审核中" 1, "待激活" 2, "垫付宝领用合约已签署"  3, "已视频认证"  4, "垫付宝领用合约已签署、视频认证已完成"  5, "信用评估已完成" 6, "已拒绝" 7, "无信用评估记录"
 @param assessType 授权类型
 */
- (void)updateUIWithAssessType:(QYCreditAssessType)assessType {

    switch (assessType) {
        case QYCreditAssessType_Examine://评估中
        {
            self.m_asseaamentingView.hidden = NO;
            break;
        }
        case QYCreditAssessType_UnActive://待激活
        {
            self.m_signView.hidden = NO;
            
            break;
        }
        case QYCreditAssessType_Sign://垫付宝领用合约已签署
        {
            self.m_signView.hidden = NO;
            break;
        }
        case QYCreditAssessType_VideoAuthed://已视频认证
        {
            self.m_signView.hidden = NO;
            break;
        }
        case QYCreditAssessType_SignAndVideoAuthed://垫付宝领用合约
        case QYCreditAssessType_Completed: //评估通过
        {
            if ((self.auditStatus == activationStatusRejected) || (self.auditStatus == activationStatusUploadAgain)) {
                self.m_reActiveView.hidden = NO;//重新激活
            }  else {
                //请求账单信息
                [self getBillInfo];
                
                //判断是否补录身份证照片
                [self requestIdCardPhoto];
            }
            break;
        }
        case QYCreditAssessType_Refused://审核失败
        case QYCreditAssessType_AccessDenied://准入拒绝
        case QYCreditAssessType_AntifraudRefusal://反欺诈拒绝
        {
            self.m_reAssessmentView.hidden = NO;
            
            break;
        }
        case QYCreditAssessType_UnAssess://立即评估
        {
            self.m_unAssessmentView.hidden = NO;
            
            break;
        }
        case QYCreditAssessType_LowScoring://评分低拒绝
        {
            self.m_errorView.hidden = NO;
            
            break;
        }
        default:
            break;
    }
    
    //是否授信
    UserInfo *info = [self queryInfo];
    NSString *tempStr = @"0";
    if ((self.m_assessType == QYCreditAssessType_SignAndVideoAuthed) || (self.m_assessType == QYCreditAssessType_Completed)) {
        tempStr = @"1";
    }
    info.isCredit = tempStr;
    [self updateInfo:info];
}

#pragma mark- 定位 - 激活成功后获取定位权限
- (void)setLocation {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *location = [defaults objectForKey:@"locationRecord"];
    
    if ([location isEqualToString:@"1"]) {
        self.isLocation = YES;
        if ([AppGlobal getLocationServicesEnabled] == 0) {
            if ([self.m_userInfo.isLogin isEqualToString:@"1"]) {
                [self updateLocation];
            }
        } else if ([AppGlobal getLocationServicesEnabled] == 2) {
            [self.locMgr requestWhenInUseAuthorization];
        } else {
            self.isLocation = NO;
            [self.locMgr startUpdatingLocation];
            self.locMgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        }
        [defaults removeObjectForKey:@"locationRecord"];
        [defaults synchronize];
    }
}

#pragma mark- 新手引导
- (void)createNewUserGuide:(NSString *)timeStr {
    UIView *tempView = [[UIApplication sharedApplication].keyWindow viewWithTag:TAG_GUIDE];
    if (tempView) {
        [tempView removeFromSuperview];
        [tempView removeAllSubviews];
    }
    
    //设置状态栏
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    
    //这里创建指引在这个视图在window上
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView * bgView = [[UIView alloc]initWithFrame:frame];
    bgView.backgroundColor = [UIColor clearColor];
    bgView.tag = TAG_GUIDE;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onSureTapClick:)];
    [bgView setAccessibilityIdentifier:@"ll_mask"];
    [bgView addGestureRecognizer:tap];
    
    //只在主页显示
    if ([[self getCurrentVC] isKindOfClass:[QYHomePageVC class]]) {
        [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    }else{
        if (tempView) {
            [tempView removeFromSuperview];
            [tempView removeAllSubviews];
        }
    }
    
    //create path（**这里需要添加第一个路径）
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
    
    // 这里添加路径 （这个是矩形）
    float deltaY = 0;
    if(IOS_VERSION < 11){
        deltaY = 20;
    }
   [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(frame.size.width/2.0-60 + 1 - 5, 180 + 2 - deltaY, 118, 37) cornerRadius:60] bezierPathByReversingPath]];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [bgView.layer setMask:shapeLayer];
    
    //黑背景
    UIView * blackView = [[UIView alloc]initWithFrame:frame];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.6;
    [bgView addSubview:blackView];
    
    //箭头
    UIImageView * arrow = nil;
    arrow = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2.0 + 50,220 - deltaY,26, 49)];
    arrow.image = [UIImage imageNamed:@"HomePage_layer_arrow"];
    [bgView addSubview:arrow];
    
    //文字背景
    UIImageView * textBg = nil;
    textBg = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2.0 - 120,280 - deltaY,222, 110)];
    textBg.image = [UIImage imageNamed:@"HomePage_layer_text"];
    [bgView addSubview:textBg];
    
    //文字
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 5, 197, 84)];
    textView.backgroundColor = [UIColor clearColor];
    
    if (([self.isHaveIdCardPhoto isEqualToString:@"0"] && [self.isAuditStatus isEqualToString:@"0"]) || ([self.isHaveIdCardPhoto isEqualToString:@"1"] && [self.isAuditStatus isEqualToString:@"3"])) {
        
        if (self.m_assessType == QYCreditAssessType_SignAndVideoAuthed) {
            if (!self.remark || [self.remark isEqualToString:@""]) {
                textView.text = @"需要认证您的身份信息";
            } else {
                textView.text = [NSString stringWithFormat:@"您的身份证因“%@”审核不通过，需要重新认证您的身份信息",self.remark];
            }
        } else if ((self.m_assessType == QYCreditAssessType_Completed)) {
            
            if (!((self.auditStatus == activationStatusUploadAgain) || (self.auditStatus == activationStatusRejected))) {
                if (!self.remark || [self.remark isEqualToString:@""]) {
                    textView.text = @"需要认证您的身份信息";
                } else {
                    textView.text = [NSString stringWithFormat:@"您的身份证因“%@”审核不通过，需要重新认证您的身份信息",self.remark];
                }
            }
        }
    } else {
        textView.text = [NSString stringWithFormat:@"您有较大金额的订单，需要提供更多的资料提高您的信用，请在%@内提交资料，若不提交系统将自动取消订单。",timeStr];
    }
    
    textView.font = [UIFont systemFontOfSize:13];
    textView.textColor = [UIColor colorWithHexString:@"ffffff"];
    
    //自动化id
    [textView setAccessibilityIdentifier:@"tv_tip"];
    
    [textBg addSubview:textView];
    
    //点击事件
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(frame.size.width/2.0 - 60,175,appWidth, 50);
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(onSupplementClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setAccessibilityIdentifier:@"ll_supplementary_data"];
    [bgView addSubview:button];
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}

/**
 *   新手指引确定
 */
- (void)onSureTapClick:(UITapGestureRecognizer *)tap {
    UIView * view = tap.view;
    [view removeFromSuperview];
    [view removeAllSubviews];
    [view removeGestureRecognizer:tap];
    
    //设置状态栏
    [self setStatusBarBackgroundColor:[UIColor colorWithHexString:@"876aee"]];
    
    //补充资料浮层弹出时机,更新状态
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"0" forKey:@"floatLayerPop"];
    [defaults synchronize];
}

#pragma mark - 按钮活动
/**
 刷新
 */
- (void)onRefreshClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    //重新请求信用评估状态
    [self requestUserAssessStatus];
    
    sender.enabled = YES;
}

#pragma mark- 补充资料
/**
 补充资料
 */
- (IBAction)onSupplementClicked:(UIButton *)sender {
    sender.enabled = NO;
    UIView *tempView = [[UIApplication sharedApplication].keyWindow viewWithTag:TAG_GUIDE];
    if (tempView) {
        [tempView removeFromSuperview];
        [tempView removeAllSubviews];
        
        //补充资料浮层弹出时机,更新状态
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"0" forKey:@"floatLayerPop"];
        [defaults synchronize];
    }
    
    if (([self.isHaveIdCardPhoto isEqualToString:@"0"] && [self.isAuditStatus isEqualToString:@"0"]) || ([self.isHaveIdCardPhoto isEqualToString:@"1"] && [self.isAuditStatus isEqualToString:@"3"])) {
        
        if (self.m_assessType == QYCreditAssessType_SignAndVideoAuthed) {
            
            QYSelectedIdCardVC *vc = [[UIStoryboard storyboardWithName:@"QYHomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"QYSelectedIdCardVC"];
            vc.photoOrFace = @"photo";
            vc.auditStatus = self.isAuditStatus;
            vc.vc = self;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ((self.m_assessType == QYCreditAssessType_Completed)) {
            
            if (!((self.auditStatus == activationStatusUploadAgain) || (self.auditStatus == activationStatusRejected))) {
                
                QYSelectedIdCardVC *vc = [[UIStoryboard storyboardWithName:@"QYHomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"QYSelectedIdCardVC"];
                vc.photoOrFace = @"photo";
                vc.auditStatus = self.isAuditStatus;
                vc.vc = self;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        sender.enabled = YES;
        return;
    }
    
    switch (self.m_addInfoType) {
        case QYAddInfoTypeAssets:
        {
            QYAddAssetsInfoVC *vc = [[UIStoryboard storyboardWithName:@"QYMyBill" bundle:nil] instantiateViewControllerWithIdentifier:@"QYAddAssetsInfoVC"];
            [self deleteAllLocalData];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case QYAddInfoTypeFinancial:
        {
            
            QYAddFinancialInfoVC *vc = [[UIStoryboard storyboardWithName:@"QYMyBill" bundle:nil] instantiateViewControllerWithIdentifier:@"QYAddFinancialInfoVC"];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
    
    sender.enabled = YES;
}

#pragma mark 删除本地所有数据
-(void)deleteAllLocalData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:@"carInfos"];
    [defaults removeObjectForKey:@"houseInfos"];
    [defaults removeObjectForKey:@"banks"];
    [defaults removeObjectForKey:@"otherInfos"];
    
    [defaults synchronize];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
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
            
            NSString *cityStr = place.locality;
            NSString *administrativeArea = place.administrativeArea;
            self.province = administrativeArea;
            self.city = cityStr;
            self.m_userInfo.city = self.city;
            self.m_userInfo.longitude = [NSString stringWithFormat:@"%f",self.longitude];
            self.m_userInfo.lat = [NSString stringWithFormat:@"%f",self.latitude];
            [self updateInfo:self.m_userInfo];
            if ([self.m_userInfo.isLogin isEqualToString:@"1"]) {
                [self updateLocation];
            }
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
        {
            //用户禁止访问地址
            if ([self.m_userInfo.isLogin isEqualToString:@"1"]) {
                [self updateLocation];
            }
            break;
        }
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

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([self.m_userInfo.isLogin isEqualToString:@"1"]) {
        [self updateLocation];
    }
}

#pragma mark - 经纬度埋点
- (void)updateLocation {
    
    NSString *url = nil;
    
    if (self.city && self.latitude && self.longitude) {
        if(!self.province){//无省份显示市
            self.province = self.city;
        }
        url = [NSString stringWithFormat:@"%@%@?source=2&province=%@&city=%@&lat=%f&lng=%f",app_new_areaLatLngMsg,verison,self.province,self.city,self.latitude,self.longitude];
    } else {
        if (self.latitude && self.longitude) {
            url = [NSString stringWithFormat:@"%@%@?source=2&province=&city=&lat=%f&lng=%f",app_new_areaLatLngMsg,verison,self.latitude,self.longitude];
        } else {
             url = [NSString stringWithFormat:@"%@%@?source=2&province=&city=",app_new_areaLatLngMsg,verison];
        }
    }
    
    [[QYNetManager requestManagerWithBaseUrl:myBaseUrl] get:url params:nil success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            DLog(@"经纬度埋点成功");
        }
    } failure:^(NSString * _Nullable errorString) {
    }];
}

#pragma mark - 获取用户评估状态请求
/**
 获取用户评估状态请求
 */
- (void)requestUserAssessStatus {
    if([self queryInfo].token.length <= 0){
        self.m_loginView.hidden = NO;
        
        //更新登录状态
        self.m_userInfo.isLogin = @"0";//未登录
        [self updateInfo:self.m_userInfo];
        [self updateCount];
        
        return;
    }

    NSString *url = [NSString stringWithFormat:@"%@%@",app_new_userAssessStatus,verison];
    [[QYNetManager requestManagerWithBaseUrl:myBaseUrl] get:url params:nil success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            [self requestUserAssessStatusSuccess:responseObject];
        } else {
            [self requestUserAssessStatusFail:responseObject];
        }
        [self updateCount];
    } failure:^(NSString * _Nullable errorString) {
        [self showMessageWithString:kShowErrorMessage];
        
        [self updateCount];
    }];
    
}

/**
 评估状态请求成功回调方法
 0, "审核中" 1, "待激活" 2, "垫付宝领用合约已签署"  3, "已视频认证"  4, "垫付宝领用合约已签署、视频认证已完成"  5, "信用评估已完成" 6, "已拒绝" 7, "无信用评估记录" 8,"准入拒绝“，9：反欺诈拒绝，10：评分低拒绝
 
 "contractAuditStatus":0,//0 待审核 1已通过 2已驳回
 "contractAuditRemarks":驳回原因
 @param responseObject 评估状态请求回调数据
 */
- (void)requestUserAssessStatusSuccess:(id)responseObject {
    NSDictionary *dataStr = [responseObject objectForKey:@"data"];
    NSInteger resultStr = [[dataStr objectForKey:@"creditResult"] intValue];
    self.m_noNetWorkView.hidden = YES;
    
    NSString *str = [NSString stringWithFormat:@"%@",[dataStr objectForKey:@"contractAuditStatus"]];
    
    if (![NSString isBlankString:str]) {
        switch ([[dataStr objectForKey:@"contractAuditStatus"] intValue]) {
            case 0:
                self.auditStatus = contractAuditStatusAudit;
                break;
            case 1:
                self.auditStatus = activationStatusThrough;
                break;
            case 2:
                self.auditStatus = activationStatusRejected;
                break;
            case 3:
                self.auditStatus = activationStatusUploadAgain;
                break;
            default:
                break;
        }
    } else {
        self.auditStatus = contractAuditStatusNot;
    }
    
    switch (resultStr) {
        case 0:
            self.m_assessType = QYCreditAssessType_Examine;
            break;
        case 1:
            self.m_assessType = QYCreditAssessType_UnActive;
            break;
        case 2:
            self.m_assessType = QYCreditAssessType_Sign;
            break;
        case 3:
            self.m_assessType = QYCreditAssessType_VideoAuthed;
            break;
        case 4:
            self.m_assessType = QYCreditAssessType_SignAndVideoAuthed;
            break;
        case 5:
            self.m_assessType = QYCreditAssessType_Completed;
            break;
        case 6:
            self.m_assessType = QYCreditAssessType_Refused;
            break;
        case 7:
            self.m_assessType = QYCreditAssessType_UnAssess;
            break;
        case 8:
            self.m_assessType = QYCreditAssessType_AccessDenied;
            break;
        case 9:
            self.m_assessType = QYCreditAssessType_AntifraudRefusal;
            break;
        case 10:
            self.m_assessType = QYCreditAssessType_LowScoring;
            break;
            
        default:
            break;
    }
    
    [self updateUIWithAssessType:self.m_assessType];
}

/**
 评估状态请求失败回调方法
 
 @param responseObject 评估状态请求回调数据
 */
- (void)requestUserAssessStatusFail:(id)responseObject {
    if ([responseObject objectForKey:@"message"]) {
        [self showMessageWithString:[responseObject objectForKey:@"message"]];
    }
    //update ui
    [self updateUIWithAssessType:QYCreditAssessType_UnAssess];
}

#pragma mark - 判断是否补录身份证照片
- (void)requestIdCardPhoto {
    
    NSString *url = [NSString stringWithFormat:@"%@%@",app_new_faceAuthCheck,verison];
    [[QYNetManager requestManagerWithBaseUrl:myBaseUrl] get:url params:nil success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            NSDictionary *dic =  [responseObject valueForKey:@"data"];
            NSInteger idCardPhoto = [[dic objectForKey:@"isHaveIdCardPhoto"] intValue];
            self.isHaveIdCardPhoto = [NSString stringWithFormat:@"%ld",(long)idCardPhoto];
            NSInteger isFaceAuth = [[dic objectForKey:@"isFaceAuth"] intValue];
            self.isFaceAuth = [NSString stringWithFormat:@"%ld",(long)isFaceAuth];
            self.remark = [dic objectForKey:@"remark"];
            NSInteger auditStatus = [[dic objectForKey:@"auditStatus"] intValue];
            self.isAuditStatus = [NSString stringWithFormat:@"%ld",(long)auditStatus];
        }
        
        //是否补充资料
        [self requestNeedAddInfo];
        
        [self updateCount];
    } failure:^(NSString * _Nullable errorString) {
        
        [self showMessageWithString:kShowErrorMessage];
        
        //更新banner位置
        self.m_bannerToTopConstraint.constant = [self getHeightTop];
        [self updateHeight];
        [self updateCount];
    }];
}

#pragma mark - 请求是否补充资料
- (void)requestNeedAddInfo {
    
    NSString *url = [NSString stringWithFormat:@"%@%@",app_new_isSupplementAssetInfo,verison];

    [[QYNetManager requestManagerWithBaseUrl:myBaseUrl] get:url params:nil success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
             [self requestNeedAddInfoSuccess:responseObject];
        } else {
            [self requestNeedAddInfoFail:responseObject];
        }
        [self updateCount];
    } failure:^(NSString * _Nullable errorString) {
        self.m_addInfoBgView.hidden = YES;
        self.m_addInfoBgViewHeightConstraint.constant = 0;
        [self showMessageWithString:kShowErrorMessage];
        
        //更新banner位置
        self.m_bannerToTopConstraint.constant = [self getHeightTop];
        [self updateCount];
    }];
}

/**
 请求是否补充资料成功回调
 */
- (void)requestNeedAddInfoSuccess:(id)responseObject {
    NSDictionary *dataDict = [responseObject objectForKey:@"data"];
    NSInteger resultStr = [[dataDict objectForKey:@"isSupplementAssetInfo"] intValue];
    self.m_isSupplement = YES;
    
    if (([self.isHaveIdCardPhoto isEqualToString:@"0"] && [self.isAuditStatus isEqualToString:@"0"]) || ([self.isHaveIdCardPhoto isEqualToString:@"1"] && [self.isAuditStatus isEqualToString:@"3"])) {
        
        if (self.m_assessType == QYCreditAssessType_SignAndVideoAuthed) {
            self.m_addInfoBgView.hidden = NO;
            self.m_addInfoBgViewHeightConstraint.constant = 45;
        } else if ((self.m_assessType == QYCreditAssessType_Completed)) {
            if (!((self.auditStatus == activationStatusUploadAgain) || (self.auditStatus == activationStatusRejected))) {
                self.m_addInfoBgView.hidden = NO;
                self.m_addInfoBgViewHeightConstraint.constant = 45;
            }
        }
    } else {
        switch (resultStr) {
            case 0:
            {
                self.m_addInfoType = QYAddInfoTypeNot;
                self.m_addInfoBgView.hidden = YES;
                self.m_addInfoBgViewHeightConstraint.constant = 0;
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:@"0" forKey:@"floatLayerPop"];
                [defaults synchronize];
                break;
            }
            case 1:
            {
                self.m_addInfoType = QYAddInfoTypeFinancial;
                self.m_addInfoBgView.hidden = NO;
                self.m_addInfoBgViewHeightConstraint.constant = 45;
                break;
            }
            case 2:
            {
                self.m_addInfoType = QYAddInfoTypeAssets;
                self.m_addInfoBgView.hidden = NO;
                self.m_addInfoBgViewHeightConstraint.constant = 45;
                break;
            }
            default:
                break;
        }
    }
    
    //请求补充资料浮层时间
    [self getLiveField];
    
    //更新banner位置
    self.m_bannerToTopConstraint.constant =  [self getHeightTop];
    [self updateHeight];
}

/*
 请求是否补充资料失败回调
*/
- (void)requestNeedAddInfoFail:(id)responseObject {
    //失败不提示
}

#pragma mark- 获取信用评估信息
/*
 *  获取信用评估信息
 */
- (void)getCreditInfo {
    NSString *url = [NSString stringWithFormat:@"%@%@",app_new_getCreditInfo,verison];
    [[QYNetManager requestManagerWithBaseUrl:myBaseUrl] get:url params:nil success:^(id  _Nullable responseObject) {
        
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            [self getCreditInfoSuccess:responseObject];
        } else {
            [self getCreditInfoFail:responseObject];
        }
        [self updateCount];
    } failure:^(NSString * _Nullable errorString) {
        [self showMessageWithString:kShowErrorMessage];
        [self updateCount];
    }];
}

/**
 取信用评估信息成功
 
 @param responseObject responseObject description
 */
- (void)getCreditInfoSuccess:(id)responseObject {
    
    //save info
    UserInfo *info = [self queryInfo];
    info.bankCards = [[responseObject valueForKey:@"data"] valueForKey:@"bankCards"];
    info.emergencyContacts = [[responseObject valueForKey:@"data"] valueForKey:@"emergencyContacts"];
    QYEmergencyModel * emergencyModel = [[responseObject valueForKey:@"data"] valueForKey:@"emergencyContact"];
    if (emergencyModel) {
        info.emergencyContact = [QYEmergencyModel mj_objectWithKeyValues:[[responseObject valueForKey:@"data"] valueForKey:@"emergencyContact"]];
    }
    QYJobModel *jobModel = [QYJobModel mj_objectWithKeyValues:[[responseObject valueForKey:@"data"] valueForKey:@"job"]];
    if (jobModel) {
        info.job = [QYJobModel mj_objectWithKeyValues:[[responseObject valueForKey:@"data"] valueForKey:@"job"]];
    }
    QYAssetModel *assetModel = [QYAssetModel mj_objectWithKeyValues:[[responseObject valueForKey:@"data"] valueForKey:@"asset"]];
    if (assetModel) {
        info.asset = [QYAssetModel mj_objectWithKeyValues:[[responseObject valueForKey:@"data"] valueForKey:@"asset"]];
    }
    QYResumeModel *resumeModel = [QYResumeModel mj_objectWithKeyValues:[[responseObject valueForKey:@"data"] valueForKey:@"user"]];
    if (resumeModel.married.length > 0) {
        info.user = [QYResumeModel mj_objectWithKeyValues:[[responseObject valueForKey:@"data"] valueForKey:@"user"]];
    }
    [self updateInfo:info];
}

- (void)getCreditInfoFail:(id)responseObject {
    //失败不提示
}

#pragma mark- 获取首页账单信息
-(void)getBillInfo{
    NSString *url = [NSString stringWithFormat:@"%@",app_new_getBillingInfo];
    [[QYNetManager requestManagerWithBaseUrl:myBaseUrl] get:url params:nil success:^(id  _Nullable responseObject) {
        
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            [self getBillInfoSuccess:responseObject];
        } else {
            [self getBillInfoFail:responseObject];
        }
        [self updateCount];
    } failure:^(NSString * _Nullable errorString) {
        [self showMessageWithString:kShowErrorMessage];
        [self updateCount];
    }];
    
}

/**
 取账单信息成功
 
 @param responseObject responseObject description
 */
- (void)getBillInfoSuccess:(id)responseObject {
    NSDictionary *dic = [responseObject valueForKey:@"data"];
    if([dic isKindOfClass:NSDictionary.class]){
        NSString *amount = [dic valueForKey:@"amount"];
        self.m_billingProcessGuidStr = [dic valueForKey:@"billingProcessGuid"];
        
        if (amount && [amount doubleValue] > 0) {
            //未出账单
            self.m_newBillView.hidden = NO;
            self.m_billOutView.hidden = NO;
            self.m_statusHeightConstraint.constant = 157;
            self.m_lateHeightConstraint.constant = 0;
            self.m_reductionHeightConstraint.constant = 0;
            
            NSString *unbillDay = [dic valueForKey:@"nextBillingDate"];//账单日
            if (unbillDay.length > 0) {
                int monthDay = [[unbillDay substringWithRange:NSMakeRange(5, 2)] intValue];//月份
                int day = [[unbillDay substringWithRange:NSMakeRange(8, 2)] intValue];//日
                self.m_stateMentLabel.text = [NSString stringWithFormat:@"账单日 %.2d月%.2d日",monthDay,day];
                self.m_monthLabel.text = [NSString stringWithFormat:@"%.2d月份",monthDay];
            }
            self.m_stateMentAmountLabel.text = amount;
            
        }else{
            if (self.m_billingProcessGuidStr) {
                //已出账单
                self.m_newBillView.hidden = NO;
                self.m_billInView.hidden = NO;
                self.m_statusHeightConstraint.constant = 157;
                self.m_lateHeightConstraint.constant = 0;
                self.m_reductionHeightConstraint.constant = 0;
                
                NSString *userBillDate = [dic valueForKey:@"userBillDate"];
                if (userBillDate.length > 0) {
                    int monthDay = [[userBillDate substringWithRange:NSMakeRange(5, 2)] intValue];//月份
                    self.m_alreadyMontyLabel.text = [NSString stringWithFormat:@"%.2d月份",monthDay];
                }
                NSString *principal = [dic valueForKey:@"principal"];
                self.m_billAmountLabel.text = principal;
                NSString *noPrincipal = [dic valueForKey:@"noPrincipal"];
                self.m_surplusAmountLabel.text = [NSString stringWithFormat:@"剩余应还 ¥%@",noPrincipal];
                NSString *lateDays = [dic valueForKey:@"lateDays"];
                self.m_billStatus = [dic valueForKey:@"status"];// 1 违约 2 还清 3 还款中
                
                //违约中
                if ([self.m_billStatus isEqualToString:@"1"]) {
                    if (lateDays.length > 0) {
                        self.m_breachView.hidden = NO;
                        self.m_breachDateLabel.text = [NSString stringWithFormat:@"违约%@天",lateDays];
                        
                        //适配
                        self.m_alreadyBillLabelToCenterXContraint.constant = -35;
                    }
                }
                
                //还款中
                if ([self.m_billStatus isEqualToString:@"3"]) {
                    self.m_repayMentView.hidden = NO;
                    
                    //适配
                    self.m_alreadyBillLabelToCenterXContraint.constant = -35;
                }
                
                //违约金
                NSString *userFees = [dic valueForKey:@"userFees"];
                // 滞纳金
                NSString *lateFees = [dic valueForKey:@"lateFees"];
                if ((userFees.length > 0 || lateFees.length > 0) && (![self.m_billStatus isEqualToString:@"3"])) {
                    //有违约金和滞纳金
                    self.m_statusHeightConstraint.constant = 197;
                    self.m_lateHeightConstraint.constant = 40;
                    if(userFees.length > 0){
                        self.m_breachAmountLabel.hidden = NO;
                        self.m_breachAmountLabel.text = [NSString stringWithFormat:@"违约金：¥%@",userFees];
                    }
                    if(lateFees.length > 0){
                        self.m_lateDateAmountLabel.hidden = NO;
                        self.m_lateDateAmountLabel.text = [NSString stringWithFormat:@"滞纳金：¥%@",lateFees];
                    }
                    
                }
                // 减免的违约金
                NSString *reduFees = [dic valueForKey:@"reduFees"];
                //  减免的滞纳金
                NSString *reduLate = [dic valueForKey:@"reduLate"];
                // 减免总和
                NSString *reductionCount = [dic valueForKey:@"reductionCount"];
                
                if ([reduFees intValue] > 0 || [reduLate intValue] > 0) {
                    //有减免
                    self.m_statusHeightConstraint.constant = 237;
                    self.m_reductionHeightConstraint.constant = 40;
                    self.m_reductionEndStr = [dic valueForKey:@"reductionEnd"];
                    self.m_breachAmountStr = [NSString stringWithFormat:@"%.2f",[reduFees floatValue]];
                    self.m_lateDateAmountStr = [NSString stringWithFormat:@"%.2f",[reduLate floatValue]];
                    self.m_reductionDescView.hidden = NO;
                    self.m_reductionDescLabel.text = [NSString stringWithFormat:@"您有一个还款金额减免 ¥%.2f福利",[reductionCount floatValue]];
                }
                
                //已还清
                if ([self.m_billStatus isEqualToString:@"2"]) {
                    //隐藏
                    self.m_statusHeightConstraint.constant = 0;
                    self.m_billInView.hidden = YES;
                }
            }else{
                //隐藏
                self.m_statusHeightConstraint.constant = 0;
            }
        }
    }else{
        self.m_statusHeightConstraint.constant = 0;
    }
    [self updateHeight];
    
    //更新banner位置
    self.m_bannerToTopConstraint.constant =  [self getHeightTop];
}

/**
 取账单信息成功
 
 @param responseObject responseObject description
 */
- (void)getBillInfoFail:(id)responseObject {
    //失败不提示
    self.m_statusHeightConstraint.constant = 0;
    [self updateHeight];
    
    //更新banner位置
    self.m_bannerToTopConstraint.constant =  [self getHeightTop];
}

#pragma mark- 版本更新信息
- (void)getVersionInfo {
    NSString *url = [NSString stringWithFormat:@"%@%@?type=1",app_new_versionUpdate,verison];
    
    NSMutableDictionary *healder = [[NSMutableDictionary alloc]init];
    
    healder[@"traceId"] = [[NSUUID UUID] UUIDString];
    healder[@"parentId"] = [[NSUUID UUID] UUIDString];
    //网络监控开始时间戳和时间
    NSUInteger startMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
    NSString *startTime = [AppGlobal getCurrentTime];
    [[QYNetManager requestManagerHeader:healder baseUrl:myBaseUrl] get:url params:nil success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            [self getVersionInfoSuccess:responseObject];
        } else {
            [self getVersionInfoFail:responseObject];
        }
        
        //接口监控
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        
        [[KYMonitorManage sharedInstance] upLoadDataWithPhone:[self queryInfo].phoneNum andStatus:@"200" andArguments:nil andResult:responseObject andMethodName: NSStringFromSelector(_cmd) andClazz:NSStringFromClass([self class]) andBusiness:@"qyfq_app_new_versionUpdate" andBusinessAlias:@"首页 版本更新信息" andServiceStart:startTime andServiceEnd:endTime andElapsed:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
        
        
    } failure:^(NSString * _Nullable errorString) {
        [self showMessageWithString:kShowErrorMessage];
        
        //保存更新状态
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"0" forKey:@"isUpdate"];
        [defaults synchronize];
        //网络监控结束时间戳和时间
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        [self monitorReq:@"500" param:nil msg:errorString methodName:NSStringFromSelector(_cmd) className:NSStringFromClass([self class]) buName:@"qyfq_app_new_versionUpdate" buAlias:@"首页 版本更新信息" statTime:startTime endTime:endTime period:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    }];
}

/**
 成功
 */
- (void)getVersionInfoSuccess:(id)responseObject {
    
    if ([[responseObject valueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
        //发数据
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic = responseObject;
        
        QYUpdateView *updateView = [[[NSBundle mainBundle] loadNibNamed:@"QYUpdateView"
                                                                  owner:nil
                                                                options:nil] lastObject];
        updateView.frame = CGRectMake(0, 0, appWidth, appHeight);
        updateView.backgroundColor = [UIColor clearColor];
        updateView.tag =  kBLACKTAG;
        if ([[UIApplication sharedApplication].keyWindow viewWithTag:kBLACKTAG]) {
            [[[UIApplication sharedApplication].keyWindow viewWithTag:kBLACKTAG] removeFromSuperview];
        }
        
        QYVersionUpdateModel *info = [QYVersionUpdateModel mj_objectWithKeyValues:[dic objectForKey:@"data"]];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([info.isUpdate isEqualToString:@"1"]) {//强制更新
            //设置状态栏
            [self setStatusBarBackgroundColor:[UIColor clearColor]];
            
            //自动化id
            [updateView.mandatoryUpdateBtn setAccessibilityIdentifier:@"btn_dialog_action"];
            
            [self.view endEditing:YES];
            self.m_isVersionUpdatePop = YES;
            
            //设置行间距
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 5;// 字体的行间距
            NSDictionary *attributes = @{
                                         NSFontAttributeName:[UIFont systemFontOfSize:15],
                                         NSParagraphStyleAttributeName:paragraphStyle
                                         };
            updateView.m_textView.attributedText = [[NSAttributedString alloc] initWithString:[info.remark stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"] attributes:attributes];
            updateView.m_textView.textColor = [UIColor colorWithHexString:@"434F66"];
            updateView.m_textView.textAlignment = NSTextAlignmentLeft;
            
            updateView.m_forceView.hidden = NO;
            [[UIApplication sharedApplication].keyWindow addSubview:updateView];
            
            //保存更新状态
            [defaults setObject:@"1" forKey:@"isUpdate"];
        }else if ([info.isUpdate isEqualToString:@"2"]){//不强制更新
            //设置状态栏
            [self setStatusBarBackgroundColor:[UIColor clearColor]];
            
            //自动化id
            [updateView.updateBtn setAccessibilityIdentifier:@"btn_dialog_action"];
            [updateView.nextSayBtn setAccessibilityIdentifier:@"btn_dialog_cancel"];
            
            [self.view endEditing:YES];
            self.m_isVersionUpdatePop = YES;
            
            //设置行间距
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 5;// 字体的行间距
            NSDictionary *attributes = @{
                                         NSFontAttributeName:[UIFont systemFontOfSize:15],
                                         NSParagraphStyleAttributeName:paragraphStyle
                                         };
            updateView.m_textView.attributedText = [[NSAttributedString alloc] initWithString:[info.remark stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"] attributes:attributes];
            updateView.m_textView.textColor = [UIColor colorWithHexString:@"434F66"];
            updateView.m_textView.textAlignment = NSTextAlignmentLeft;
            
            updateView.m_notForceView.hidden = NO;
            [[UIApplication sharedApplication].keyWindow addSubview:updateView];
            
            //保存更新状态
            [defaults setObject:@"1" forKey:@"isUpdate"];
        }else{//不更新
            self.m_isVersionUpdatePop = NO;
            
            //保存更新状态
            [defaults setObject:@"0" forKey:@"isUpdate"];
        }
        
        //启动后只弹出1次
        [defaults setObject:@"1" forKey:@"isShowUpdate"];
        [defaults synchronize];
    }
}

/**
 失败
 */
- (void)getVersionInfoFail:(id)responseObject {
    //保存更新状态
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"0" forKey:@"isUpdate"];
    [defaults synchronize];
}

#pragma mark- 超时时长活字段设置
- (void)getLiveField {
    NSString *url = [NSString stringWithFormat:@"%@%@",app_new_getLiveField,verison];
    NSMutableDictionary *healder = [[NSMutableDictionary alloc]init];
    
    healder[@"traceId"] = [[NSUUID UUID] UUIDString];
    healder[@"parentId"] = [[NSUUID UUID] UUIDString];
    //网络监控开始时间戳和时间
    NSUInteger startMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
    NSString *startTime = [AppGlobal getCurrentTime];
   
    [[QYNetManager requestManagerHeader:healder baseUrl:myBaseUrl]  get:url params:nil success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            [self getLiveFieldSuccess:responseObject];
        } else {
            [self getLiveFieldFail:responseObject];
        }
        //接口监控
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        
        [[KYMonitorManage sharedInstance] upLoadDataWithPhone:[self queryInfo].phoneNum andStatus:@"200" andArguments:nil andResult:responseObject andMethodName: NSStringFromSelector(_cmd) andClazz:NSStringFromClass([self class]) andBusiness:@"qyfq_app_new_getLiveField" andBusinessAlias:@"超时时长活字段设置" andServiceStart:startTime andServiceEnd:endTime andElapsed:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
        [self updateCount];
    } failure:^(NSString * _Nullable errorString) {
        [self showMessageWithString:kShowErrorMessage];
        [self updateCount];
        //网络监控结束时间戳和时间
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        [self monitorReq:@"500" param:nil msg:errorString methodName:NSStringFromSelector(_cmd) className:NSStringFromClass([self class]) buName:@"qyfq_app_new_getLiveField" buAlias:@"超时时长活字段设置" statTime:startTime endTime:endTime period:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    }];
}

/**
 成功
 */
- (void)getLiveFieldSuccess:(id)responseObject {
    if ([[responseObject valueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
        //发数据
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic = [responseObject objectForKey:@"data"];
        
        //取时间
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *timeStr = [dic valueForKey:@"supMaterialsTimeConfig"];
        [defaults setObject:timeStr forKey:@"timeStr"];
        [defaults synchronize];
        
        NSString *floatLayerPopStr = [defaults objectForKey:@"floatLayerPop"];
        
        
        if (([self.isHaveIdCardPhoto isEqualToString:@"0"] && [self.isAuditStatus isEqualToString:@"0"]) || ([self.isHaveIdCardPhoto isEqualToString:@"1"] && [self.isAuditStatus isEqualToString:@"3"])) {
            
            if (self.m_assessType == QYCreditAssessType_SignAndVideoAuthed) {
                if ([floatLayerPopStr isEqualToString:@"1"] && !self.m_isVersionUpdatePop) {
                    //新手引导
                    if ([timeStr isEmpty] || !timeStr) {
                        timeStr = @"48小时";
                    }
                    [self createNewUserGuide:timeStr];
                }
            } else if ((self.m_assessType == QYCreditAssessType_Completed)) {
                
                if (!((self.auditStatus == activationStatusUploadAgain) || (self.auditStatus == activationStatusRejected))) {
                    if ([floatLayerPopStr isEqualToString:@"1"] && !self.m_isVersionUpdatePop) {
                        //新手引导
                        if ([timeStr isEmpty] || !timeStr) {
                            timeStr = @"48小时";
                        }
                        [self createNewUserGuide:timeStr];
                    }
                }
            }
            return;
        }
        
        //弹出时机
        if ((self.m_addInfoType == QYAddInfoTypeAssets) || (self.m_addInfoType == QYAddInfoTypeFinancial)) {
            
            if ((self.auditStatus != activationStatusRejected) && (self.auditStatus != activationStatusUploadAgain)) {
                
                if ([floatLayerPopStr isEqualToString:@"1"] && !self.m_isVersionUpdatePop) {
                    //新手引导
                    if ([timeStr isEmpty] || !timeStr) {
                        timeStr = @"48小时";
                    }
                    [self createNewUserGuide:timeStr];
                }
            }
        }
        
        //最后更新高度
        [self updateHeight];
    }
}

/**
 失败
 */
- (void)getLiveFieldFail:(id)responseObject {
    if ([responseObject objectForKey:@"message"]) {
        [self showMessageWithString:[responseObject objectForKey:@"message"]];
    }
}

#pragma mark- 接收非强制更新版本的下次再说点击事件
- (void)onGuidePop:(NSNotification *)notification {
    //弹出时机
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ((self.m_addInfoType == QYAddInfoTypeAssets) || (self.m_addInfoType == QYAddInfoTypeFinancial)) {
        NSString *timeStr = [defaults objectForKey:@"timeStr"];
        
        //新手引导
        if ([timeStr isEmpty] || !timeStr) {
            timeStr = @"48小时";
        }
        [self createNewUserGuide:timeStr];
    }
    
    //设置状态栏
    [self setStatusBarBackgroundColor:[UIColor colorWithHexString:@"876aee"]];
}

#pragma mark- 扫一扫
- (IBAction)onScannerClicked:(UIButton *)sender {
    sender.enabled = NO;

    // 是否开启相机
    if ([AppGlobal isCameraPermissions]) {
        if ([self.m_userInfo.isLogin isEqualToString:@"1"]) {

            //扫一扫
            QYScannerVC *vc = [[UIStoryboard storyboardWithName:@"QYScanner" bundle:nil] instantiateViewControllerWithIdentifier:@"QYScannerVC"];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [AppGlobal gotoNewLoginVC:self];
        }
    } else {
        [AppGlobal openCameraPermissions];
    }
    
    sender.enabled = YES;
}

#pragma mark- 点击账单入口
- (IBAction)onIconBillClick:(UIButton *)sender {
    sender.enabled = NO;
    
     [self goToBillList];
    
    sender.enabled = YES;
}   

#pragma mark- 未出账单点击
- (IBAction)onUnBillCllicked:(UIButton *)sender {
    sender.enabled = NO;
    
    KYMonthBillVC *vc = [[UIStoryboard storyboardWithName:@"QYMyBill" bundle:nil] instantiateViewControllerWithIdentifier:@"KYMonthBillVC"];
    vc.type = BillTypeNoneHas;
    [self.navigationController pushViewController:vc animated:YES];
    
    sender.enabled = YES;
}

#pragma mark- 点击已出账单账单区域
- (IBAction)onGoBillClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    //BillTypePayBacking = 0,//还款中
    //BillTypePayBackFinish,// 已还清
    //BillTypePayBackCsontractNone,//已违约 无减免
    //BillTypePayBackCsontractHas,//已违约 有减免
    
    KYMonthBillVC *vc = [[UIStoryboard storyboardWithName:@"QYMyBill" bundle:nil] instantiateViewControllerWithIdentifier:@"KYMonthBillVC"];
    vc.s_billIdStr = self.m_billingProcessGuidStr ;
    if ([self.m_billStatus isEqualToString:@"1"]) {
        if (self.m_reductionDescView.hidden) {
            //无减免
            vc.type =  BillTypePayBackCsontractNone;
        }else{
            //有减免
            vc.type =  BillTypePayBackCsontractHas;
        }
    }else if([self.m_billStatus isEqualToString:@"2"]){
        vc.type =  BillTypePayBackFinish;
    }else if([self.m_billStatus isEqualToString:@"3"]){
        vc.type =  BillTypePayBacking;
    }else if([self.m_billStatus isEqualToString:@"4"]){
        vc.type =  BillTypeCarryOver;
    }
    [self.navigationController pushViewController:vc animated:YES];

    
    sender.enabled = YES;
}

#pragma mark- 减免提示
- (IBAction)onReducationTipClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    NSString* tempStr = @"";
    if (self.m_reductionEndStr.length > 0) {
        NSString* yearStr = [self.m_reductionEndStr substringWithRange:NSMakeRange(0, 4)];//年
        NSString* monthDayStr = [self.m_reductionEndStr substringWithRange:NSMakeRange(5, 2)];//月份
        NSString* dayStr = [self.m_reductionEndStr substringWithRange:NSMakeRange(8, 2)];//日
        tempStr = [NSString stringWithFormat:@"%@年%@月%@日",yearStr,monthDayStr,dayStr];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"请于%@前还款，否则减免福利将无效\n违约金已减免%.2f元\n滞纳金已减免%.2f元",tempStr,[self.m_breachAmountStr floatValue],[self.m_lateDateAmountStr floatValue]] message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
    sender.enabled = YES;
}

#pragma mark- 订单列表
- (IBAction)onCheckInfoClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    if ([self.m_userInfo.isLogin isEqualToString:@"1"]) {
        [self headerLoadOrderList];
    }else{
        [AppGlobal gotoNewLoginVC:self];
    }
    
    sender.enabled = YES;
}

#pragma mark-去账单
-(void)goToBillList {
    if ([self.m_userInfo.isLogin isEqualToString:@"1"]) {
         //我的账单列表
        QYMyBillVC *vc = [[QYMyBillVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [AppGlobal gotoNewLoginVC:self];
    }
}

#pragma mark - 订单列表
- (void)headerLoadOrderList {
    [self deleteAllLocalData];
//    QYAddAssetsInfoVC *vc = [[UIStoryboard storyboardWithName:@"QYMyBill" bundle:nil] instantiateViewControllerWithIdentifier:@"QYAddAssetsInfoVC"];
//    [self.navigationController pushViewController:vc animated:YES];
    
   QYAllOrderMainVC *vc = [[QYAllOrderMainVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- 立即登陆
- (IBAction)onLoginClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"QYLogin" bundle:nil];
    QYLoginVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"QYLoginVC"];

    CATransition *transition  = [CATransition animation];
    transition.duration       = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.subtype        = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:vc animated:NO];


    //保存登录状态
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"0" forKey:@"isLogin"];
    [defaults synchronize];
    
    sender.enabled = YES;
}


#pragma mark-  去评估
- (IBAction)onAssessmentClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    //信用评估
    QYCreditEvaluationMainVC *vc = [[UIStoryboard storyboardWithName:@"QYHomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"QYCreditEvaluationMainVC"];
    [self.navigationController pushViewController:vc animated:YES];
    
    sender.enabled = YES;
}

#pragma mark- 实名认证信息查询
- (void)checkAuthInfo {
    NSString *url = [NSString stringWithFormat:@"%@%@",app_new_auth,verison];
    
    NSMutableDictionary *healder = [[NSMutableDictionary alloc]init];
   
    healder[@"traceId"] = [[NSUUID UUID] UUIDString];
    healder[@"parentId"] = [[NSUUID UUID] UUIDString];
    
    //网络监控开始时间戳和时间
    NSUInteger startMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
    NSString *startTime = [AppGlobal getCurrentTime];
    
    
    [[QYNetManager requestManagerHeader:healder baseUrl:myBaseUrl] get:url params:nil success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            [self AuthInfoSucceeded:responseObject];
        } else {
            [self AuthInfoFaile:responseObject];
        }
        //接口监控
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        
        [[KYMonitorManage sharedInstance] upLoadDataWithPhone:[self queryInfo].phoneNum andStatus:@"200" andArguments:nil andResult:responseObject andMethodName: NSStringFromSelector(_cmd) andClazz:NSStringFromClass([self class]) andBusiness:@"qyfq_app_new_auth" andBusinessAlias:@"获取用户已实名认证信息" andServiceStart:startTime andServiceEnd:endTime andElapsed:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
       [self updateCount];
    } failure:^(NSString * _Nullable errorString) {
        [self updateCount];
        //网络监控结束时间戳和时间
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        [self monitorReq:@"500" param:nil msg:errorString methodName:NSStringFromSelector(_cmd) className:NSStringFromClass([self class]) buName:@"qyfq_app_new_auth" buAlias:@"获取用户已实名认证信息" statTime:startTime endTime:endTime period:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
        
    }];
}

/**
 获取实名认证信息成功
 */
- (void)AuthInfoSucceeded:(id)responseObject {
    if([responseObject isKindOfClass:NSDictionary.class]){
        
        NSDictionary *dic = [responseObject valueForKey:@"data"];
        
        //取得会员名字和证件号, 认证状态
        UserInfo *info = [self queryInfo];
        if (dic) {
            info.personfullname = [dic valueForKey:@"personfullname"];
            info.personIdCardCode = [dic valueForKey:@"personIdCardCode"];
            info.isAuth = @"1";
        }else{
            info.isAuth = @"0";
        }
        [self updateInfo:info];
    }
    
    //最后更新高度
    [self updateHeight];
}

/**
 获取实名认证信息失败
 */
- (void)AuthInfoFaile:(id)responseObject {
    
    //取得会员名字和证件号, 认证状态
    UserInfo *info = [self queryInfo];
    info.isAuth = @"0";
    info.personfullname = @"";
    info.personIdCardCode = @"";
    [self updateInfo:info];
    
    //最后更新高度
    [self updateHeight];
}

#pragma mark-  重新去评估
- (IBAction)onReAssessmentClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    //信用评估
    QYCreditEvaluationMainVC *vc = [[UIStoryboard storyboardWithName:@"QYHomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"QYCreditEvaluationMainVC"];
    [self.navigationController pushViewController:vc animated:YES];
    
    sender.enabled = YES;
}

#pragma mark- 拨打电话
- (IBAction)onTelePhonoeClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4001008899"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
    sender.enabled = YES;
}

#pragma mark- 激活
- (IBAction)onActiveClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    QYActiveVC *vc = [[UIStoryboard storyboardWithName:@"QYHomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"QYActiveVC"];
    [self.navigationController pushViewController:vc animated:YES];
    
    sender.enabled = YES;
}

#pragma mark- 评估状态 + 补充资料高度
-(float)getHeightTop {
    float tempHeight = 0;
    if ([self.m_userInfo.isLogin isEqualToString:@"1"]) {//已登录
        
        //评估状态
        if ((self.m_assessType == QYCreditAssessType_Completed) || (self.m_assessType == QYCreditAssessType_SignAndVideoAuthed)) {
            if ((self.auditStatus == activationStatusRejected) || (self.auditStatus == activationStatusUploadAgain)) {
                tempHeight += 60;
            }  else {
                tempHeight += self.m_statusHeightConstraint.constant + 10;
            }
        }else{
            tempHeight += 60;
        }
        
        //是否补充资料
        if (!self.m_addInfoBgView.hidden) {
            tempHeight += 45;
        }
        
    }else{
        tempHeight = 60;
    }
    
    
    return tempHeight;
}

#pragma mark -- ZXCycleScrollViewDelegate
-(void)zxCycleScrollView:(ZXCycleScrollView *)scrollView didScrollToIndex:(NSInteger)index {
    //    DLog(@"index------%lu",index);滚动回调
}

-(void)zxCycleScrollView:(ZXCycleScrollView *)scrollView didSelectItemAtIndex:(NSInteger)index {
    DLog(@"点击了----index------%lu",(long)index);
    if (index < self.m_bannerArray.count) {
        NSString *urlStr = [self.m_bannerArray objectAtIndex:index];
        if(urlStr.length > 0){
            
            QYWebViewVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QYWebViewVC"];
            vc.s_urlStr = urlStr;
            vc.s_viewControler = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //行数
    NSInteger tempCount = 1;
    if (self.m_categoriesArray.count > 4) {
        tempCount = 2;
    }
    return tempCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //列数
    if (self.m_categoriesArray.count > 4) {
        return 4;
    }
    return self.m_categoriesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger tempCount = 4;
    if (self.m_categoriesArray.count < 1) {
        tempCount = 1;
    }
    NSInteger index = tempCount * indexPath.section + indexPath.row;
    
    static NSString *identify = @"QYTypeCell";
    QYTypeCell *cell = (QYTypeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if (index < self.m_categoriesArray.count) {
        QYHomeCategoriesModel *typeInfo = [self.m_categoriesArray objectAtIndex:index];
        cell.s_imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"HomePage_icon%@",typeInfo.type]];
        cell.s_titleLabel.text = typeInfo.name;
        cell.hidden = NO;
    }else{
        cell.hidden = YES;
    }
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger tempCount = 4;
    if (self.m_categoriesArray.count < 1) {
        tempCount = 1;
    }
    NSInteger index = tempCount * indexPath.section + indexPath.row;
    if (index == 0) {
        //新车售卖
       KYChooseCarVC *vc =  [KYChooseCarVC vc];
        vc.type = 1;
        [self push:vc];
    }else if (index == 1) {
        //维修保养,先选择品牌
        KYChooseCarVC *vc =  [KYChooseCarVC vc];
        vc.type = 2;
        [self push:vc];
    }else{
        QYHomeCategoriesModel * categoriesInfo = [self.m_categoriesArray objectAtIndex:index];
        KYGoodsListVC *vc = [[UIStoryboard storyboardWithName:@"QYProduct" bundle:nil] instantiateViewControllerWithIdentifier:@"KYGoodsListVC"];
        vc.s_title = categoriesInfo.name;
        vc.s_type = index + 1;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return (CGSize){appWidth / 4,181/2};
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - 获取轮播图
- (void)getBannerList {
    
    NSString *url = [NSString stringWithFormat:@"%@",app_new_bannerList];
    
    NSMutableDictionary *healder = [[NSMutableDictionary alloc]init];
    
    healder[@"traceId"] = [[NSUUID UUID] UUIDString];
    healder[@"parentId"] = [[NSUUID UUID] UUIDString];
    
    //网络监控开始时间戳和时间
    NSUInteger startMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
    NSString *startTime = [AppGlobal getCurrentTime];
    
    
    [[QYNetManager requestManagerHeader:healder baseUrl:myBaseUrl] get:url params:nil success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            [self getBannerListSuccess:responseObject];
        } else {
            [self getBannerListFail:responseObject];
        }
        //接口监控
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        
        [[KYMonitorManage sharedInstance] upLoadDataWithPhone:[self queryInfo].phoneNum andStatus:@"200" andArguments:nil andResult:responseObject andMethodName: NSStringFromSelector(_cmd) andClazz:NSStringFromClass([self class]) andBusiness:@"qyfq_app_new_bannerList" andBusinessAlias:@"获取轮播图(首页)" andServiceStart:startTime andServiceEnd:endTime andElapsed:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
        [self updateCount];
    } failure:^(NSString * _Nullable errorString) {
        [self showMessageWithString:errorString];
        [self updateCount];
        //网络监控结束时间戳和时间
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        [self monitorReq:@"500" param:nil msg:errorString methodName:NSStringFromSelector(_cmd) className:NSStringFromClass([self class]) buName:@"qyfq_app_new_bannerList" buAlias:@"获取轮播图(首页)" statTime:startTime endTime:endTime period:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    }];
}

/**
 获取轮播图成功回调
 */
- (void)getBannerListSuccess:(id)responseObject {
    NSArray *dataArray = [responseObject objectForKey:@"data"];
    NSMutableArray *imgArray = [NSMutableArray array];
    for (int i = 0; i < dataArray.count ; i++) {
        [imgArray addObject:[[dataArray objectAtIndex:i] valueForKey:@"img"]];
        //加入banner点击
        [self.m_bannerArray addObject:[[dataArray objectAtIndex:i] valueForKey:@"link"]];
    }
    self.m_myBannerView.sourceDataArr = imgArray ;
}

/*
 获取轮播图失败回调
 */
- (void)getBannerListFail:(id)responseObject {
    //失败不提示
    self.m_myBannerView.autoScroll = NO;
}

#pragma mark - 首页八大类按钮
- (void)getCategories {
    
    NSString *url = [NSString stringWithFormat:@"%@",app_new_categories];
    
    NSMutableDictionary *healder = [[NSMutableDictionary alloc]init];
    
    healder[@"traceId"] = [[NSUUID UUID] UUIDString];
    healder[@"parentId"] = [[NSUUID UUID] UUIDString];
    
    //网络监控开始时间戳和时间
    NSUInteger startMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
    NSString *startTime = [AppGlobal getCurrentTime];
    
    [[QYNetManager requestManagerHeader:healder baseUrl:myBaseUrl] get:url params:nil success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            [self getCategoriesSuccess:responseObject];
        } else {
            [self getCategoriesFail:responseObject];
        }
        //接口监控
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        
        [[KYMonitorManage sharedInstance] upLoadDataWithPhone:[self queryInfo].phoneNum andStatus:@"200" andArguments:nil andResult:responseObject andMethodName: NSStringFromSelector(_cmd) andClazz:NSStringFromClass([self class]) andBusiness:@"qyfq_app_new_categories" andBusinessAlias:@"首页八大类按钮" andServiceStart:startTime andServiceEnd:endTime andElapsed:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
        [self updateCount];
    } failure:^(NSString * _Nullable errorString) {
        [self getCategoriesFail:nil];
        [self updateCount];
        
        //网络监控结束时间戳和时间
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        [self monitorReq:@"500" param:nil msg:errorString methodName:NSStringFromSelector(_cmd) className:NSStringFromClass([self class]) buName:@"qyfq_app_new_categories" buAlias:@"首页八大类按钮" statTime:startTime endTime:endTime period:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    }];
}

/**
 首页八大类按钮成功回调
 */
- (void)getCategoriesSuccess:(id)responseObject {
    NSArray *dataArray = [responseObject objectForKey:@"data"];
    [self.m_categoriesArray removeAllObjects];
    for (int i = 0; i < dataArray.count ; i++) {
        QYHomeCategoriesModel * categoriesInfo = [QYHomeCategoriesModel mj_objectWithKeyValues:[dataArray objectAtIndex:i]];
        [self.m_categoriesArray addObject:categoriesInfo];
    }
    if (self.m_categoriesArray.count > 4) {
        self.m_categoryHeightConstraint.constant = 181;
    }else{
        self.m_categoryHeightConstraint.constant = 181 / 2;
    }
    [self.m_collectionView reloadData];
    
    //更新列表
    [self updateHeight];
}

/*
 首页八大类按钮失败回调
 */
- (void)getCategoriesFail:(id)responseObject {
    //失败不提示
    [self.m_categoriesArray removeAllObjects];
    /** 分类id 1=新车售卖 2=维修保养 3=汽车用品 4=家装建材 5=手机数码 6=家用电器 7=住宅家具 8=电脑办公 */
    NSArray *tempArray = [NSArray arrayWithObjects:@"新车售卖",@"维修保养",@"汽车用品",@"家装建材",@"手机数码",@"家用电器",@"住宅家具",@"电脑办公", nil];
    for (int i = 0; i < 8 ; i++) {
        QYHomeCategoriesModel * categoriesInfo = [[QYHomeCategoriesModel alloc]init];
        categoriesInfo.name = [tempArray objectAtIndex:i];
        categoriesInfo.type = [NSString stringWithFormat:@"%d",i + 1];
        [self.m_categoriesArray addObject:categoriesInfo];
    }
    if (self.m_categoriesArray.count > 4) {
        self.m_categoryHeightConstraint.constant = 181;
    }else{
        self.m_categoryHeightConstraint.constant = 181 / 2;
    }
    
    [self.m_collectionView reloadData];
    
    //更新列表
    [self updateHeight];
}

#pragma mark- 查看更多商品
- (IBAction)onMoreInfoClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    KYGoodsListVC *vc = [[UIStoryboard storyboardWithName:@"QYProduct" bundle:nil] instantiateViewControllerWithIdentifier:@"KYGoodsListVC"];
    vc.s_title = @"全部商品";
    vc.s_type = 0;
    [self.navigationController pushViewController:vc animated:YES];
    
    sender.enabled = YES;
}

#pragma mark - 热门推荐
- (void)getRecommend {
    
    NSString *url = [NSString stringWithFormat:@"%@",app_new_recommend];
    NSMutableDictionary *healder = [[NSMutableDictionary alloc]init];
    
    healder[@"traceId"] = [[NSUUID UUID] UUIDString];
    healder[@"parentId"] = [[NSUUID UUID] UUIDString];
    
    //网络监控开始时间戳和时间
    NSUInteger startMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
    NSString *startTime = [AppGlobal getCurrentTime];
    
   
     [[QYNetManager requestManagerHeader:healder baseUrl:myBaseUrl] get:url params:nil success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            [self getRecommendSuccess:responseObject];
        } else {
            [self getRecommendFail:responseObject];
        }
         //接口监控
         NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
         NSString *endTime = [AppGlobal getCurrentTime];
         NSUInteger period = endMillSeconds - startMillSeconds;
         NSString *periods = [NSString stringWithFormat:@"%tu", period];
         
         [[KYMonitorManage sharedInstance] upLoadDataWithPhone:[self queryInfo].phoneNum andStatus:@"200" andArguments:nil andResult:responseObject andMethodName: NSStringFromSelector(_cmd) andClazz:NSStringFromClass([self class]) andBusiness:@"qyfq_app_new_recommend" andBusinessAlias:@"热门推荐" andServiceStart:startTime andServiceEnd:endTime andElapsed:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
        [self updateCount];
    } failure:^(NSString * _Nullable errorString) {
        [self showMessageWithString:errorString];
        [self updateCount];
        //网络监控结束时间戳和时间
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        [self monitorReq:@"500" param:nil msg:errorString methodName:NSStringFromSelector(_cmd) className:NSStringFromClass([self class]) buName:@"qyfq_app_new_recommend" buAlias:@"热门推荐" statTime:startTime endTime:endTime period:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    }];
}

/**
 热门推荐成功回调
 */
- (void)getRecommendSuccess:(id)responseObject {
    NSArray *dataArray = [responseObject objectForKey:@"data"];
    [self.m_recommendArray removeAllObjects];
    [self.m_recommendscrollview removeAllSubviews];
    for (int i = 0; i < dataArray.count ; i++) {
        QYRecommendModel * recommendModel = [QYRecommendModel mj_objectWithKeyValues:[dataArray objectAtIndex:i]];
        [self.m_recommendArray addObject:recommendModel];
    }
    if (dataArray.count > 0) {
        self.m_recommendView.hidden = NO;
        self.m_recommendscrollview.contentSize = CGSizeMake(95 * dataArray.count, 0);
        self.m_recommendscrollview.showsVerticalScrollIndicator = NO;
        
        for (int j = 0; j < self.m_recommendArray.count; j++) {
            QYHomeCommonCell *view = [[[NSBundle mainBundle] loadNibNamed:@"QYHomeCommonCell" owner:nil options:nil] lastObject];
            QYRecommendModel * recommendModel = [self.m_recommendArray objectAtIndex:j];
            QYTypeInfo *typeInfo = [[QYTypeInfo alloc]init];
            typeInfo.name = recommendModel.goodsName;
            typeInfo.price = recommendModel.price;
            typeInfo.img = recommendModel.img;
            view.frame = CGRectMake(15 + j * 95, 0, 86, 128);
            view.s_infoButton.tag = j;
            [view.s_infoButton addTarget:self action:@selector(onRecommendDetailClicked:)];
            [view updateInfo:typeInfo withType:0];
            [self.m_recommendscrollview addSubview:view];
        }
    }
    
    //更新列表
    [self updateHeight];
}

/*
 热门推荐失败回调
 */
- (void)getRecommendFail:(id)responseObject {
    self.m_recommendView.hidden = YES;
    
    //更新列表
    [self updateHeight];
}

#pragma mark - 分类列表
- (void)getListData {
    
    NSString *url = [NSString stringWithFormat:@"%@",app_new_stagList];
    NSMutableDictionary *healder = [[NSMutableDictionary alloc]init];
    
    healder[@"traceId"] = [[NSUUID UUID] UUIDString];
    healder[@"parentId"] = [[NSUUID UUID] UUIDString];
    
    //网络监控开始时间戳和时间
    NSUInteger startMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
    NSString *startTime = [AppGlobal getCurrentTime];
    
    
    [[QYNetManager requestManagerHeader:healder baseUrl:myBaseUrl]  get:url params:nil success:^(id  _Nullable responseObject) {
        NSInteger statusCode = [QYNetManager getStatusCodeWithResponseObject:responseObject showResultWithVC:self];
        if (statusCode == 10000) {
            [self getListDataSuccess:responseObject];
        } else {
            [self getListDataFail:responseObject];
        }
        //接口监控
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        
        [[KYMonitorManage sharedInstance] upLoadDataWithPhone:[self queryInfo].phoneNum andStatus:@"200" andArguments:nil andResult:responseObject andMethodName: NSStringFromSelector(_cmd) andClazz:NSStringFromClass([self class]) andBusiness:@"qyfq_app_new_stagList" andBusinessAlias:@"首页八大类列表" andServiceStart:startTime andServiceEnd:endTime andElapsed:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
        [self updateCount];
    } failure:^(NSString * _Nullable errorString) {
        [self showMessageWithString:errorString];
        [self updateCount];
        //网络监控结束时间戳和时间
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        [self monitorReq:@"500" param:nil msg:errorString methodName:NSStringFromSelector(_cmd) className:NSStringFromClass([self class]) buName:@"qyfq_app_new_stagList" buAlias:@"首页八大类列表" statTime:startTime endTime:endTime period:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    }];
}

/**
 分类列表成功回调
 */
- (void)getListDataSuccess:(id)responseObject {
    NSArray *dataArray = [responseObject objectForKey:@"data"];
    
    [self.m_typeListArray removeAllObjects];
    [self.m_listView removeAllSubviews];
    self.m_listView.hidden = NO;
    float tempHeight = 0;
    
    for (int i = 0; i < dataArray.count ; i++) {
        QYTypeListModel * typeList = [QYTypeListModel mj_objectWithKeyValues:[dataArray objectAtIndex:i]];
        [self.m_typeListArray addObject:typeList];
        UIView *tempView = [self addListViewWithModel:typeList andIndex:i andCount:dataArray.count];
        float tempViewHeight = tempView.frame.size.height;
        tempHeight = tempViewHeight;
        float tempH = tempViewHeight * i;
        tempView.frame = CGRectMake(0, tempH, appWidth, tempViewHeight);
        [self.m_listView addSubview:tempView];
    }
    self.m_listHeightConstraint.constant = tempHeight * dataArray.count;
    
    //更新列表
    [self updateHeight];
}

/*
 分类列表失败回调
 */
- (void)getListDataFail:(id)responseObject {
    self.m_listHeightConstraint.constant = 0;
    self.m_listView.hidden = YES;
    
    //更新列表
    [self updateHeight];
}

#pragma mark- 添加列表商品
-(UIView *)addListViewWithModel:(QYTypeListModel *)listModel andIndex:(NSInteger)index andCount:(NSInteger)count{
    QYHomeListView *listView = [[[NSBundle mainBundle] loadNibNamed:@"QYHomeListView" owner:nil options:nil] lastObject];
    listView.s_titleLabel.text = [self getTitleByType:listModel.type];
    listView.s_bannerImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"HomePage_banner%d",listModel.type]];
    if (iphone5) {
        listView.s_bannerImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"HomePage_banner%diphone5",listModel.type]];
    }
    /** 栏目id 1=新车售卖 2=维修保养 3=汽车用品 4=家装建材 5=手机数码 6=家用电器 7=住宅家具 8=电脑办公 */
    
    NSArray *listArray = listModel.data;
    QYTypeInfo *typeInfo = [[QYTypeInfo alloc]init];
    for (int j = 0; j< listArray.count; j ++) {
        typeInfo = [typeInfo loadDataFromkeyValues:[listArray objectAtIndex:j]];
        listView.s_scrollView.contentSize = CGSizeMake(95 * listArray.count, 0);
        listView.s_scrollView.showsVerticalScrollIndicator = NO;
        QYHomeCommonCell *view = [[[NSBundle mainBundle] loadNibNamed:@"QYHomeCommonCell" owner:nil options:nil] lastObject];
        view.frame = CGRectMake(15 + j * 95, 0, 86, 128);
        [view updateInfo:typeInfo withType:listModel.type];
        view.s_infoButton.tag = listModel.type;
        // 绑定数据源
        NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%d",j], @"index",
                              nil];
        objc_setAssociatedObject(view.s_infoButton, "myBtn", dataDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [view.s_infoButton addTarget:self action:@selector(onDetailClicked:)];
        [listView.s_scrollView addSubview:view];
    }

    return listView;
}

#pragma mark- 精选分期
-(void)onDetailClicked:(UIButton *)sender{
    sender.enabled = NO;
    
    // 获取数据源
    NSDictionary *dic = objc_getAssociatedObject(sender, "myBtn");
    NSInteger index = [[dic objectForKey:@"index"] intValue];
    NSInteger btnTag = sender.tag;
    
    //3=汽车用品 4=家装建材 5=手机数码 6=家用电器 7=住宅家具 8=电脑办公
    QYProductDetailVC *vc  = [QYProductDetailVC vc];
    vc.m_type = btnTag ;
    QYTypeInfo *typeInfo = [[QYTypeInfo alloc]init];
    NSArray *arr =  [self getListArrayByType:btnTag];
    typeInfo = [typeInfo loadDataFromkeyValues:[arr objectAtIndex:index]];
    vc.m_id =  typeInfo.id;
    vc.source = typeInfo.source ;
    
    [self push:vc];
    
    sender.enabled = YES;
}

#pragma mark- 热门推荐
-(void)onRecommendDetailClicked:(UIButton *)sender{
    sender.enabled = NO;
    
    // 获取数据源
    NSInteger btnTag = sender.tag;
    QYRecommendModel * recommendModel = [self.m_recommendArray objectAtIndex:btnTag];
    QYProductDetailVC *vc  = [QYProductDetailVC vc];
    vc.m_id =  recommendModel.id;
    vc.source = recommendModel.source ;
    [self push:vc];
    
    sender.enabled = YES;
}

#pragma mark- 更新高度
-(void)updateHeight{
    //是否补充资料
    float f1 = 0;
    if (!self.m_addInfoBgView.hidden) {
        f1 = 45;
    }
    if (self.m_statusHeightConstraint.constant == 50) {
        f1 = 0;
    }
    
    //分类是否2行
    float f2 = 181 / 2;
    if (self.m_categoriesArray.count > 4) {
        f2 = 181;
    }
    
    //热门推荐是否显示
    float f3 = 0;
    if (!self.m_recommendView.hidden) {
        f3 = 198;
    }
    
    
    float tempF = 148 + 10 + self.m_statusHeightConstraint.constant + f1 + self.m_branerHeightConstraint.constant + f2 + 44 + 10 + f3 + self.m_listHeightConstraint.constant + 10;
    
    //更新高度
    CGRect newFrame = self.m_contentView.frame;
    newFrame.size.height = tempF;
    self.m_contentView.frame = newFrame;
    [self.m_mainTableView setTableHeaderView:self.m_contentView];
}

#pragma mark- 根据type返回名字
-(NSString *)getTitleByType:(int)type{
    /** 栏目id 1=新车售卖 2=维修保养 3=汽车用品 4=家装建材 5=手机数码 6=家用电器 7=住宅家具 8=电脑办公 */
    NSString *tempStr = @"";
    switch (type) {
        case 1:
            tempStr = @"新车售卖";
            break;
        case 2:
            tempStr = @"维修保养";
            break;
        case 3:
            tempStr = @"汽车用品";
            break;
        case 4:
            tempStr = @"家装建材";
            break;
        case 5:
            tempStr = @"手机数码";
            break;
        case 6:
            tempStr = @"家用电器";
            break;
        case 7:
            tempStr = @"住宅家具";
            break;
        case 8:
            tempStr = @"电脑办公";
            break;
            
        default:
            break;
    }
    
    return tempStr;
}

#pragma mark- 返回列表
-(NSArray* )getListArrayByType:(NSInteger )type{
    NSArray *tempArray = [[NSArray alloc]init];
    for (QYTypeListModel * typeList in self.m_typeListArray) {
        if (typeList.type == type) {
            tempArray = [NSArray arrayWithArray:typeList.data];
            break;
        }
    }
    
    return tempArray;
}

#pragma mark- 更新请求接口次数
-(void)updateCount {
    self.m_count ++;
    
    if ([self.m_userInfo.isLogin isEqualToString:@"1"]) {
        
        //状态通过再请求账单
        if ((self.m_assessType == QYCreditAssessType_Completed) || (self.m_assessType == QYCreditAssessType_SignAndVideoAuthed)) {
            if (self.m_count >= 7) {
                [self dismissLoading];
                self.m_count = 0;
                
                self.m_statusView.hidden = NO;
                self.m_loginView.hidden = YES;
            }
        }else{
            if (self.m_count == 3) {
                [self dismissLoading];
                self.m_count = 0;
                
                self.m_statusView.hidden = NO;
                self.m_loginView.hidden = YES;
            }
        }
        
    }else{
        if (self.m_count >= 4) {
            [self dismissLoading];
            self.m_count = 0;
            
            self.m_loginView.hidden = NO;
            self.m_statusView.hidden = YES;
        }
    }

}


#pragma mark - 维护页请求
- (void)getDowntime {
    
    NSString *url = [NSString stringWithFormat:@"%@",app_Downtime];
    
    NSMutableDictionary *healder = [[NSMutableDictionary alloc]init];
    
    healder[@"traceId"] = [[NSUUID UUID] UUIDString];
    healder[@"parentId"] = [[NSUUID UUID] UUIDString];
    
    //网络监控开始时间戳和时间
    NSUInteger startMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
    NSString *startTime = [AppGlobal getCurrentTime];
    
    
     
    [[QYNetManager requestManagerHeader:healder baseUrl:myBaseUrl] get:url params:nil success:^(id  _Nullable responseObject) {
        //接口监控
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        
        [[KYMonitorManage sharedInstance] upLoadDataWithPhone:[self queryInfo].phoneNum andStatus:@"200" andArguments:nil andResult:responseObject andMethodName: NSStringFromSelector(_cmd) andClazz:NSStringFromClass([self class]) andBusiness:@"qyfq_app_Downtime" andBusinessAlias:@"请求维护页 首页" andServiceStart:startTime andServiceEnd:endTime andElapsed:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
        
    } failure:^(NSString * _Nullable errorString) {
        //网络监控结束时间戳和时间
        NSUInteger endMillSeconds = [KYMonitorManage sharedInstance].millSeconds;
        NSString *endTime = [AppGlobal getCurrentTime];
        NSUInteger period = endMillSeconds - startMillSeconds;
        NSString *periods = [NSString stringWithFormat:@"%tu", period];
        [self monitorReq:@"500" param:nil msg:errorString methodName:NSStringFromSelector(_cmd) className:NSStringFromClass([self class]) buName:@"qyfq_app_Downtime"  buAlias:@"请求维护页 首页" statTime:startTime endTime:endTime period:periods traceId:healder[@"traceId"] spanId:healder[@"traceId"]];
    }];
}

#pragma mark- scrollview代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat ff = scrollView.contentOffset.y;
    if (ff > scrollView.contentSize.height - self.m_mainTableView.frame.size.height){
        
        // 取消上拉回弹
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollView.contentSize.height - self.m_mainTableView.frame.size.height)];
    }
}



@end
