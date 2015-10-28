//
//  UIView+Extend.m
//  iWeidao
//
//  Created by kk on 14-12-10.
//  Copyright (c) 2014年 yongche. All rights reserved.
//

#import "UIView+Extend.h"

@implementation UIView (Extend)

+(UIView *)createSeperateLine:(UIView *)mView offsetX:(CGFloat)offset offsetY:(CGFloat)offsetY
{
    UIImageView * topseparatorLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1000, 0.5)];
    topseparatorLineView.image = [UIImage imageNamed:@"seperateline"];
    [mView addSubview:topseparatorLineView];
    
    UIImageView * bottomseparatorLineView = [[UIImageView alloc] initWithFrame:CGRectMake(offset, mView.height + offsetY, 1000, 0.5)];
    bottomseparatorLineView.image = [UIImage imageNamed:@"seperateline"];
    [mView addSubview:bottomseparatorLineView];
    return mView;
    
}

@end
