//
//  NSObject+YCCommon.m
//  iWeidao
//
//  Created by yongche on 14-3-28.
//  Copyright (c) 2014年 Weidao. All rights reserved.
//

#import "NSObject+YCCommon.h"
#import "UIAlertView+RACSignalSupport.h"
#import <RACSignal.h>

//#import "MobClick.h"

@implementation NSObject (YCCommon)

- (RACSignal *)showMessage:(NSString *)message withTitle:(NSString *)title
{
    return [self showMessage:message withTitle:title withMenuTitle:@"确定"];
}

- (RACSignal *)showMessageWithCode:(NSInteger)code orMessage:(NSString *)message{
    NSString *msg = nil;
    static NSDictionary * mapping = nil;
    if (!mapping) {
        mapping = @{
                    @(451): @"服务开始时间已经过了",
                    @(452): @"没有您选择的车型",
                    @(473): @"优惠券不是您的",
                    @(474): @"优惠券不存在",
                    @(475): @"优惠券已经使用",
                    @(476): @"优惠券已经过期或者还不能使用",
                    };
    }
    msg = mapping[@(code)]?:message;
    return [self showMessage:msg withTitle:nil withMenuTitle:@"确定"];
}

- (RACSignal *)showMessage:(NSString *)message
                 withTitle:(NSString *)title
             withMenuTitle:(NSString *)menuTitle
         otherButtonTitles:(NSString *)otherTitle
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:menuTitle
                                          otherButtonTitles:otherTitle, nil];
    [alert show];
    return [alert rac_buttonClickedSignal];
}

- (RACSignal *)showMessage:(NSString *)message
                 withTitle:(NSString *)title
             withMenuTitle:(NSString *)menuTitle
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:menuTitle
                                          otherButtonTitles:nil];
    [alert show];
    return [alert rac_buttonClickedSignal];
}

/*
- (void)umengEventClick:(NSString*)eventId {
    [MobClick event:eventId];
}*/


@end
