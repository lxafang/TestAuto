//
//  DBSubsCell.m
//  DoBe
//
//  Created by liuxu'an on 15/10/11.
//  Copyright © 2015年 liuxuan. All rights reserved.
//

#import "DBSubsCell.h"
#import "DBArticleModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DBSubsCell () {
}

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UIButton *subsBtn;

@end

@implementation DBSubsCell
@synthesize isSubed = _isSubed;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _subsBtn.layer.borderWidth = .5f;
    _subsBtn.layer.borderColor = RGB(241, 151, 38).CGColor;
    _subsBtn.layer.cornerRadius = 5.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)subscriveOrCancelEvent:(UIButton *)sender {
    if (_subscribeEventBlock) {
        _subscribeEventBlock(self.isSubed);
    }
}

- (void)setIsSubed:(BOOL)isSubed {
    _isSubed = isSubed;
    if (_isSubed) {
        [_subsBtn setTitle:@"已订阅" forState:UIControlStateNormal];
        [_subsBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _subsBtn.layer.borderColor = [UIColor grayColor].CGColor;

    }else {
        [_subsBtn setTitle:@"订阅" forState:UIControlStateNormal];
    }
}

- (void)setCellInfoWithModel:(DBWXModel *)info {
    _titleLab.text = info.wx_name;
    _detailLab.text = info.desc;
    self.isSubed = info.is_subscribe;
    [_icon sd_setImageWithURL:[NSURL URLWithString:info.wx_avatar] placeholderImage:[UIImage imageNamed:@"icon_subs"]];
}

@end
