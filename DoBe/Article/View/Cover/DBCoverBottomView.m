//
//  DBCoverBottomView.m
//  DoBe
//
//  Created by liuxuan on 15/6/14.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBCoverBottomView.h"

@implementation DBCoverBottomView

//201 202 203
- (IBAction)buttonEventClick:(UIButton *)sender {
    
    if (_coverBottomEventBlock) {
        _coverBottomEventBlock(sender.tag);
    }
    
    if (sender.tag == 201) {
        NSLog(@"不感兴趣");
    }else if (sender.tag == 202) {
        NSLog(@"劣质文章");
    }else {
        NSLog(@"举报问题");
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
