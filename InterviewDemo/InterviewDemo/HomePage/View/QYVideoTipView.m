//
//  QYVideoTipView.m
//  QYStaging
//
//  Created by wangkai on 2017/5/3.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYVideoTipView.h"

@interface QYVideoTipView ()
/*背景*/
@property (weak, nonatomic) IBOutlet UIView *m_bgView;
/*下部背景*/
@property (weak, nonatomic) IBOutlet UIView *m_bottomView;

@end

@implementation QYVideoTipView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.m_bgView.layer.cornerRadius = 8;
    self.m_bottomView.layer.cornerRadius = 8;
}


/**
 关闭界面

 @param sender sender description
 */
- (IBAction)onCloseClicked:(UIButton *)sender {
    sender.enabled = NO;
    if (self.copyExistBlock) {
        self.copyExistBlock();
    }
    [self removeFromSuperview];
    
    sender.enabled = YES;
}


@end
