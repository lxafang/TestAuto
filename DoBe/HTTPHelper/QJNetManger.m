//
//  QJNetManger.m
//  QiJi
//
//  Created by liuxu'an on 15/7/23.
//  Copyright (c) 2015年 liuxu'an. All rights reserved.
//

#import "QJNetManger.h"
#import <Reachability/Reachability.h>

static QJNetManger *netWorkManger = nil;

@implementation QJNetManger

+ (QJNetManger *)instance
{
    @synchronized(self){
        if (netWorkManger == nil) {
            netWorkManger = [[[self class] alloc] init];
        }
        return netWorkManger;
    }
}
+ (NETWORK_TYPE)networkTypeFromStatusBar {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]])     {
            dataNetworkItemView = subview;
            break;
        }
    }
    NETWORK_TYPE nettype = NETWORK_TYPE_NONE;
    NSNumber * num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
    nettype = [num intValue];
    return nettype;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self){
        if (netWorkManger == nil) {
            netWorkManger = [super allocWithZone:zone];
        }
        return netWorkManger;
    }
}

+ (id)copyWithZone:(NSZone *)zone
{
    return netWorkManger;
}

- (BOOL)isNetworkRunning
{
    Reachability * reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus state = reachability.currentReachabilityStatus;
    BOOL result = NO;
    switch (state) {
        case NotReachable: {
            result = NO;
        }
            break;
        case ReachableViaWiFi: {
            result = YES;
        }
            break;
        case ReachableViaWWAN: {
            result = YES;
        }
            break;
        default: {
            result = YES;
        }
            break;
    }
    return result;
}



@end
