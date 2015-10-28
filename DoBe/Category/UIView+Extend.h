//
//  UIView+Extend.h
//  iWeidao
//
//  Created by kk on 14-12-10.
//  Copyright (c) 2014年 yongche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extend)


/**
 *  为mView上下添加分割线
 *
 *  @param mView  view
 *  @param offsetX 水平方向偏移量
 *  @param offsetY 竖直方向偏移量
 *
 *  @return 放回添加了分割线的View
 */
+(UIView *)createSeperateLine:(UIView *)mView
                      offsetX:(CGFloat)offsetX
                      offsetY:(CGFloat)offset;

@end
