//
//  UIColor+Factory.m
//  iWeidao
//
//  Created by 赵学智 on 14-9-18.
//  Copyright (c) 2014年 yongche. All rights reserved.
//

#import "UIColor+Factory.h"

@implementation UIColor (Factory)

// 联系人电话号码
+(UIColor *)yc_C1_bg
{
    return RGBACOLOR(255, 246, 197, 1);
}
+(UIColor *)yc_C1_text
{
    return RGBACOLOR(34, 34, 34,1);
}
+(UIColor *)yc_C1_borderColor
{
    return RGBACOLOR(208, 197, 144,1);
}

// 优惠券3张可用
+(UIColor *)yc_C2_bg
{
    return RGBACOLOR(152, 208, 125, 1);
}
+(UIColor *)yc_C2_text
{
    return RGBACOLOR(255, 255, 255, 1);
}
+(UIColor *)yc_C2_borderColor
{
    return RGBACOLOR(129, 169, 110, 1);
}

// 优惠券 0 张可用
+(UIColor *)yc_C3_bg
{
    return RGBACOLOR(220, 220, 220, 1);
}
+(UIColor *)yc_C3_text
{
    return RGBACOLOR(136, 136, 136, 1);
}
+(UIColor *)yc_C3_borderColor
{
    return RGBACOLOR(200, 200, 200, 1);
}

// 结算账户
+(UIColor *)yc_C4_bg
{
    return RGBACOLOR(88, 160, 240, 1);
}
+(UIColor *)yc_C4_text
{
    return RGBACOLOR(255, 255, 255, 1);
}
+(UIColor *)yc_C4_borderColor
{
    return RGBACOLOR(53, 134, 192, 1);
}


+ (UIColor *)lineColor
{
    return RGB(220, 220, 220);
}

+ (UIColor *)line_C2
{
    return RGB(64, 64, 64);
}

+ (UIColor *)borderColor
{
    return RGB(200, 200, 200);
}


+ (UIColor *)big_bg_C1
{
    return RGB(240 , 240, 240);
}

+ (UIColor *)main_text_C1
{
    return RGB(136, 136, 136);
}
+ (UIColor *)main_text_C2
{
    return RGB(34, 34, 34);
}
+ (UIColor *)main_text_C3
{
    return RGB(100, 100, 100);
}

+ (UIColor *)main_text_C4
{
    return RGB(88, 88, 88);
}

+ (UIColor *)main_text_C5
{
    return RGB(93, 124, 183);
}

+ (UIColor *)main_red_C1
{
    return RGB(236, 73, 73);
}
+ (UIColor *)main_red_C2
{
    return RGB(215, 60, 60);
}

+ (UIColor *)main_blue_C1
{
    return RGB(12, 77, 162);
}

+ (UIColor *)placeHold_C1
{
    return RGB(204, 204, 204);
}

+ (UIColor *)c_222222
{
    return UIColorFromRGB(0x222222);
}

+ (UIColor  *)c_585858
{
    return UIColorFromRGB(0x585858);
}

+ (UIColor  *)c_ec4949
{
    return UIColorFromRGB(0xec4949);
}

+ (UIColor *)c_ebebeb
{
    return UIColorFromRGB(0xebebeb);
}

+ (UIColor *)c_cccccc
{
    return UIColorFromRGB(0xcccccc);
}

+ (UIColor *)c_888888
{
    return UIColorFromRGB(0x888888);
}

+ (UIColor *)c_49a1ec
{
    return UIColorFromRGB(0x49a1ec);
}
@end
