//
//  UIColor+Factory.h
//  iWeidao
//
//  Created by 赵学智 on 14-9-18.
//  Copyright (c) 2014年 yongche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Factory)

// 订单确认页面 4中颜色方案
+(UIColor *)yc_C1_bg;
+(UIColor *)yc_C1_text;
+(UIColor *)yc_C1_borderColor;

+(UIColor *)yc_C2_bg;
+(UIColor *)yc_C2_text;
+(UIColor *)yc_C2_borderColor;

+(UIColor *)yc_C3_bg;
+(UIColor *)yc_C3_text;
+(UIColor *)yc_C3_borderColor;

+(UIColor *)yc_C4_bg;
+(UIColor *)yc_C4_text;
+(UIColor *)yc_C4_borderColor;


// 框内分割线颜色
+ (UIColor *)lineColor;

+ (UIColor *)line_C2;

// 边框颜色
+ (UIColor *)borderColor;

// 背景色 浅 -> 深
+ (UIColor *)big_bg_C1;

// 主要字体夜色 浅 -> 深
+ (UIColor *)main_text_C1;
+ (UIColor *)main_text_C2;
+ (UIColor *)main_text_C3;
+ (UIColor *)main_text_C4;
+ (UIColor *)main_text_C5;
// 红色  浅 -> 深
+ (UIColor *)main_red_C1;
+ (UIColor *)main_red_C2;

// 蓝色
+ (UIColor *)main_blue_C1;


+ (UIColor *)placeHold_C1;


+ (UIColor *)c_222222;

+ (UIColor *)c_585858;

+ (UIColor *)c_ec4949;

+ (UIColor *)c_ebebeb;

+ (UIColor *)c_cccccc;

+ (UIColor *)c_888888;

+ (UIColor *)c_49a1ec;
@end
