//
//  DBMyHeadView.m
//  DoBe
//
//  Created by liuxuan on 15/6/9.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBMyHeadView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DBMyHeadView(){
    
}
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIView *tagBgView; //标签
@property (weak, nonatomic) IBOutlet UILabel *focusLab;
@property (weak, nonatomic) IBOutlet UILabel *fansLab;
@property (weak, nonatomic) IBOutlet UILabel *doCoinLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *signLab;

@end

@implementation DBMyHeadView

- (void)awakeFromNib {
    [_tagBgView.layer setBorderWidth:0.5f];
    [_tagBgView.layer setBorderColor:RGB(210, 210, 210).CGColor];
    _signLab.textColor = kLightTextGray;
    [self setUserInfo];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _line.frame = CGRectMake(0.0f, 130.0f, self.width, 0.5);
}

-(void)createSeperateLine
{
    UIImageView *seperateLine = [[UIImageView alloc] init];
    seperateLine.frame = CGRectMake(0.f, 130.f, self.width, 0.5f);
    seperateLine.image = [UIImage imageNamed:@"seperateline"];
    [self addSubview:seperateLine];
    
    UIImageView *secondLine = [[UIImageView alloc] init];
    secondLine.frame = CGRectMake(0.0f, 175.0f, self.width, 0.5f);
    secondLine.image = [UIImage imageNamed:@"seperateline"];
    [self addSubview:secondLine];
}


- (IBAction)pushToAccountVCClick:(id)sender {
    if (_editUserInfoBlock) {
        _editUserInfoBlock();
    }
}

- (void)setUserInfo {
    
    DBUserModel *info = [DBUserModel getUserInfo];
    
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:info.avatar] placeholderImage:[UIImage imageNamed:@"my_headImage"]];
    [_headImgView.layer setMasksToBounds:YES];
    _headImgView.layer.cornerRadius = _headImgView.height/2;
    _headImgView.layer.borderWidth = 0.5f;
    _headImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [_nameLab setText:info.user_name];
    [_signLab setText:info.signature];
    [_focusLab setText: [NSString stringWithFormat:@"关注: %@",info.to_fans_num]];
    [_fansLab setText:[NSString stringWithFormat:@"粉丝: %@",info.fans_num]];
    [_doCoinLab setText:[NSString stringWithFormat:@"豆币: %@",info.cion_num]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
