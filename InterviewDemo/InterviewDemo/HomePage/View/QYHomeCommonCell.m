//
//  QYHomeCommonCell.m
//  QYStaging
//
//  Created by wangkai on 2017/12/18.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYHomeCommonCell.h"

@interface QYHomeCommonCell()

/* 商品图片*/
@property (weak, nonatomic) IBOutlet UIImageView *m_image;
/* 商品名字*/
@property (weak, nonatomic) IBOutlet UILabel *m_nameLabel;
/* 商品价格*/
@property (weak, nonatomic) IBOutlet UILabel *m_priceLabel;
/* 尊享或促销*/
@property (weak, nonatomic) IBOutlet UIImageView *m_flagImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_toBottomConstraint;

@end

@implementation QYHomeCommonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark- 更新信息
-(void)updateInfo:(QYTypeInfo *)info withType:(NSInteger)type{
    self.m_flagImage.hidden = YES;
    self.m_priceLabel.text = [NSString stringWithFormat:@"%@",info.price];
    self.m_toBottomConstraint.constant = 47;
    if (type == 1) {
        self.m_flagImage.hidden = NO;
        self.m_flagImage.image = [UIImage imageNamed:@"HomePage_zunxiang"];
        self.m_priceLabel.text = [NSString stringWithFormat:@"%@万",info.price];
        self.m_toBottomConstraint.constant = 64;
    }else if (type == 2){
        self.m_flagImage.hidden = NO;
        self.m_flagImage.image = [UIImage imageNamed:@"HomePage_cuxiao"];
    }
    if (type > 3) {
        self.m_nameLabel.text = info.goodsName;
    }else{
        self.m_nameLabel.text = info.name;
    }
    
    if (info.img.length > 0) {
        [self setImageWithURL:info.img];
    }
}

- (void)setImageWithURL:(NSString *)urlStr{
    NSURL * url = [NSURL URLWithString:urlStr];
    dispatch_queue_t queue = dispatch_queue_create("loadImage", NULL);
    
    dispatch_async(queue, ^{
        [self.m_image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"HomePage_defaultCell"]];
    });
}

@end
