//
//  DBCoverCell.m
//  DoBe
//
//  Created by liuxuan on 15/6/15.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBCoverCell.h"

@implementation DBCoverCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)coverCellEventClick:(UIButton *)sender {
    
    if (_coverCellEventBlock) {
        if (sender.tag == 201) {
            NSLog(@"不感兴趣");
        }else if (sender.tag == 202) {
            NSLog(@"劣质文章");
        }else {
            NSLog(@"举报问题");
        }
        _coverCellEventBlock(sender.tag);
    }
}

@end
