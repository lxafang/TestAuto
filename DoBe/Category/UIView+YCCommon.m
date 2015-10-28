//
//  UIView+YCCommon.m
//  iWeidao
//
//  Created by yongche_w on 14-11-3.
//  Copyright (c) 2014年 yongche. All rights reserved.
//

#import "UIView+YCCommon.h"
#import "YCProgressHUD.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation UIView(YCCommon)

- (void)showProgressHUD
{
    [self hideProgressHUD];
    [YCProgressHUD showHUDAddedTo:self];
}

- (void)hideProgressHUD
{
    [YCProgressHUD hideHUDForView:self];
}

- (void)showToastMessage:(NSString *)message
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithFrame:self.bounds];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.labelFont = [UIFont boldSystemFontOfSize:14];
    [self addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:1.5];
}

@end
