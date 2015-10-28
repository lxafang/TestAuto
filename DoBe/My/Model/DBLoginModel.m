//
//  DBLoginModel.m
//  DoBe
//
//  Created by liuxuan on 15/7/9.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBLoginModel.h"

static DBLoginModel *sharedInstance = nil;

@implementation DBLoginModel

+ (DBLoginModel *)sharedInstance {

    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[DBLoginModel alloc] init];
        }
    }
    return sharedInstance;
}

- (BOOL)isLogin {
    NSString *token = self.access_token;
    return ![QJTools isBlankObject:token];
}

- (void)setAccess_token:(NSString *)access_token {
    if (![QJTools isBlankObject:access_token]) {
        DefaultSetValueForKey(access_token, kWeiXinAccessToken);
    }else {
        DefaultSetValueForKey(@"", kWeiXinAccessToken);
    }
}

- (NSString *)access_token {
    NSString *token = DefaultValueForKey(kWeiXinAccessToken);
    return token;
}

- (void)setOpen_id:(NSString *)open_id {
    if (![QJTools isBlankObject:open_id]) {
        DefaultSetValueForKey(open_id, kWeiXinOpenId);
    }else {
        DefaultSetValueForKey(@"", kWeiXinOpenId);
    }
}

- (NSString *)open_id {
    NSString *openid = DefaultValueForKey(kWeiXinOpenId);
    return openid;
}

- (void)setRefresh_token:(NSString *)refresh_token {
    if (![QJTools isBlankObject:refresh_token]) {
        DefaultSetValueForKey(refresh_token, kWeiXinRefreshToken);
    }else {
        DefaultSetValueForKey(@"", kWeiXinRefreshToken);
    }
}

- (NSString *)refresh_token {
    NSString *token = DefaultValueForKey(kWeiXinRefreshToken);
    return token;

}

@end
