//
//  DBMultiImageCell.m
//  DoBe
//
//  Created by liuxuan on 15/6/4.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBMultiImageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface DBMultiImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet UIImageView *middleImg;
@property (weak, nonatomic) IBOutlet UIImageView *rightImg;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;   //标签
@property (weak, nonatomic) IBOutlet UILabel *wxLab;     /**< 微信号 */
@property (weak, nonatomic) IBOutlet UILabel *numLab;    /**< 点赞数 */


@end

@implementation DBMultiImageCell {
    
    __weak IBOutlet UILabel *_titleLab;  /**< 标题 */
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellInfoWithModel:(DBArticleModel *)info {
    _titleLab.text = info.title;
    _wxLab.text = info.wx_name;
    if ([info.tags isEqualToString:@""]) {
        _typeLab.text = @"推荐";
    }else {
        _typeLab.text = info.tags;
    }
    _numLab.text = info.good_num;
    
    if (info.thum.count > 2) {
        [_leftImg sd_setImageWithURL:[NSURL URLWithString:info.thum[0]] placeholderImage:[UIImage imageNamed:@"img_default_news"]];
        [_middleImg sd_setImageWithURL:[NSURL URLWithString:info.thum[1]] placeholderImage:[UIImage imageNamed:@"img_default_news"]];
        [_rightImg sd_setImageWithURL:[NSURL URLWithString:info.thum[2]] placeholderImage:[UIImage imageNamed:@"img_default_news"]];
    }
    
}

@end
