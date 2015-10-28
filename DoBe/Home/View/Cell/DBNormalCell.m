//
//  DBNormalCell.m
//  DoBe
//
//  Created by liuxuan on 15/6/4.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBNormalCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation DBNormalCell {
    
    __weak IBOutlet UIImageView *_praiseImgView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _arrowBtn.hidden = YES;
    /*
    if (is_Width320) {
        _praiseImgView.translatesAutoresizingMaskIntoConstraints = NO;
        _praiseNumLab.translatesAutoresizingMaskIntoConstraints = NO;
        [_praiseImgView removeConstraints:_praiseImgView.constraints];
        [_praiseNumLab removeConstraints:_praiseNumLab.constraints];
        _praiseImgView.frame = CGRectMake(118.f, 80.f, 11.f, 10.f);
        _praiseNumLab.frame = CGRectMake(_praiseImgView.right + 5.f, 80.f, 40.f, 21.f);
    }*/
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)arrowTouchUpInside:(UIButton *)sender {
    
}

- (void)setCellData:(DBArticleModel *)model {
    _title.text = model.title;
    if ([model.tags isEqualToString:@""]) {
        _typeLab.text = @"推荐";
    }else {
        _typeLab.text = model.tags;
    }
    NSString *urlStr = [model.thum objectAtIndexSafe:0];
    
    [_thumb sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"img_default_news"]];
    _wxNameLab.text = model.wx_name;
    _praiseNumLab.text = model.good_num;
}

@end
