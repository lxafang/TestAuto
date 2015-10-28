//
//  DBUser.h
//  DoBe
//
//  Created by liuxuan on 15/6/3.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBUser : NSObject

@property (nonatomic, strong) NSString *userId;                 /**< 用户id  */
@property (nonatomic, copy)   NSString *open_id;                /**< open_id @lxa */
@property (nonatomic, strong) NSString *name;                   /**< 用户名 @lxa */
@property (nonatomic, strong) NSString *headImage;              /**< 用户头像 @lxa */
@property (nonatomic, strong) NSString *signature;              /**< 签名 @lxa */

@property (nonatomic, strong) NSString *cellphone;              //手机号
@property (nonatomic, strong) NSString *email;                  //邮箱
@property (nonatomic, strong) NSString *city;                   //所在城市
@property (nonatomic, strong) NSString *address;                //地址
@property (nonatomic, strong) NSArray  *tags;                   /**< 标签 @lxa */

@property (nonatomic, strong) NSString *focusCount;             /**< 关注数 @lxa */
@property (nonatomic, strong) NSString *fans;                   /**< 粉丝数 @lxa */
@property (nonatomic, strong) NSString *doCion;                 /**< 豆比 @lxa */



+ (DBUser *)sharedInstance;

- (void)getUserId;

/*
{
    result =     {
        address = "\U5317\U4eac\U5e02";
        avatar = "www.baidu.com";
        cellphone = 18510238763;
        city = "\U5317\U4eac";
        "create_time" = 0;
        email = "441209821@qq.com";
        "open_id" = dsfsdfsdf123;
        other = "\U8be6\U7ec6\U8bf4\U660e\Uff1f";
        signature = "\U6211\U5c31\U662f\U6211";
        tags = "\U6807\U7b7e\U989d\U989d\U989d";
        "update_time" = 0;
        "user_id" = 1;
        "user_name" = lihai;
    };
    "ret_code" = 200;
    "ret_msg" = ok;
}*/


@end
