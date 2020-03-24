//
//  QYHomeListView.m
//  QYStaging
//
//  Created by wangkai on 2017/12/19.
//  Copyright © 2017年 wangkai. All rights reserved.
//
    
#import "QYHomeListView.h"

@interface QYHomeListView()

/* banner高度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_bannerHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_toBottomConstraint;


@end

@implementation QYHomeListView


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if (iphone6Plus) {
        self.m_bannerHeightConstraint.constant = 75;
        self.m_toBottomConstraint.constant = 0;
        [self layoutIfNeeded];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
