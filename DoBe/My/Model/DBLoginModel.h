//
//  DBLoginModel.h
//  DoBe
//
//  Created by liuxuan on 15/7/9.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTestAppID       @"wxd477edab60670232"
#define kTestScope       @"snsapi_userinfo,snsapi_base"
#define kTestState       @"wechat_sdk_demo"
#define kTestAppSecret   @""
#define kGrantType       @"authorization_code"


@interface DBLoginModel : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *access_token; /**<  */

@property (nonatomic, copy) NSString *refresh_token;

@property (nonatomic, copy) NSString *open_id;


+ (DBLoginModel *)sharedInstance;

- (BOOL)isLogin;

/*
1. 第三方发起微信授权登录请求，微信用户允许授权第三方应用后，微信会拉起应用或重定向到第三方网站，并且带上授权临时票据code参数；

2. 通过code参数加上AppID和AppSecret等，通过API换取access_token；

3. 通过access_token进行接口调用，获取用户基本数据资源或帮助用户实现基本操作。
 */

@end
