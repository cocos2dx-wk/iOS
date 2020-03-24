//
//  QYHomeListView.h
//  QYStaging
//
//  Created by wangkai on 2017/12/19.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYHomeListView : UIView
/*标题*/
@property (weak, nonatomic) IBOutlet UILabel *s_titleLabel;
/*banner*/
@property (weak, nonatomic) IBOutlet UIImageView *s_bannerImg;
/*列表背景*/
@property (weak, nonatomic) IBOutlet UIView *s_tableViewBgView;
/*滚动视图*/
@property (weak, nonatomic) IBOutlet UIScrollView *s_scrollView;

@end
