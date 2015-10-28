//
//  YCUIImage+Addition.m
//  iWeidao
//
//  Created by yongche_w on 14-10-29.
//  Copyright (c) 2014年 yongche. All rights reserved.
//

#import "YCUIImage+Addition.h"

@implementation UIImage(Addition)

+ (UIImage *)getImageNamed:(NSString *)name
{
    UIImage* image = nil;
    if(name.length > 0){
        if(DeviceIsIphone6){
            image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_iPhone6",name]];
        }else if(DeviceIsIphone5){
            image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_iPhone5",name]];
        }else if(DeviceIsIphone6plus){
            image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_iPhone6plus",name]];
        }
        
        if(image == nil){
            image = [UIImage imageNamed:name];
        }
    }
    return image;
}

@end
