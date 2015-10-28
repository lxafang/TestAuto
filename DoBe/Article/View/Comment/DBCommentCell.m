//
//  DBCommentCell.m
//  DoBe
//
//  Created by liuxuan on 15/6/16.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBCommentCell.h"
#import "DBCommentModel.h"

@interface DBCommentCell() {
    
    __weak IBOutlet UIImageView *headImgView;
    
    __weak IBOutlet UILabel *nameLab;
    __weak IBOutlet UILabel *timeLab;
    
    __weak IBOutlet UILabel *praiseNumLab;
    __weak IBOutlet UILabel *commentLab;
    
}

@end

@implementation DBCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    nameLab.textColor = RGB(46, 154, 48);
    timeLab.textColor = kLightTextGray;
    praiseNumLab.textColor = kLightTextGray;
    
    commentLab.numberOfLines = 0;
    CGSize size = [@"高度" sizeWithFont:kNormalFont boundSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    commentLab.height = size.height;
    commentLab.textColor = LightTextBlack;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCommentText:(NSString *)text {
    commentLab.text = text;
    CGFloat defaultH = commentLab.height;
    CGSize labSize = [text sizeWithFont:kNormalFont boundSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    if (labSize.width > commentLab.width) {
        commentLab.height = defaultH *(labSize.width/commentLab.width + 1);
        CGRect frame = [self frame];
        frame.size.height = 100 + (commentLab.height- defaultH);
        self.frame = frame;
        [self setNeedsLayout];
    }
}

- (void)setCommentModel:(DBCommentModel *)model {
    
    //[nameLab setText:model.guestName];
    //[praiseNumLab setText:model.likedCount];

    [timeLab setText:model.time];
    [headImgView setImage:model.headImage];
    nameLab.text = model.user_id;
    praiseNumLab.text = model.good_num;
    [self setCommentText:model.comment_message];
    
    [self setNeedsLayout];
}

- (IBAction)praiseEventClick:(UIButton *)sender {
    if (_cellPraiseEventBlock) {
        _cellPraiseEventBlock();
    }
}

- (IBAction)sendMessageEventClick:(UIButton *)sender {
    if (_cellMessageEventBlock) {
        _cellMessageEventBlock();
    }
}
@end
