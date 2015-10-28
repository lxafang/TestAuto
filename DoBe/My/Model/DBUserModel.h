//
//  DBUserModel.h
//  DoBe
//
//  Created by liuxu'an on 15/7/25.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBUserModel : NSObject

@property (nonatomic, strong) NSString *user_id;                 /**< 用户id  */
@property (nonatomic, strong) NSString *open_id;                 /**< open_id */
@property (nonatomic, strong) NSString *user_name;               /**< 用户名 @lxa */
@property (nonatomic, strong) NSString *avatar;                  /**< 用户头像 @lxa ./assets/upfile/avatar_1437826093_2053.png */
@property (nonatomic, strong) NSString *signature;              /**< 签名 @lxa */
@property (nonatomic, strong) NSString *islogin;                /**< 是否第一次登陆 0注册 1登陆 */

@property (nonatomic, strong) NSString *cellphone;              //手机号
@property (nonatomic, strong) NSString *email;                  //邮箱
@property (nonatomic, strong) NSString *city;                   //所在城市
@property (nonatomic, strong) NSString *address;                //地址
@property (nonatomic, strong) NSString *tags;                   /**< 标签 @lxa */

@property (nonatomic, copy) NSString *to_fans_num;         /**< 关注数 */
@property (nonatomic, copy) NSString *fans_num;            /**< 粉丝数 */
@property (nonatomic, copy) NSString *cion_num;             /**< 豆币数 */
@property (nonatomic, copy) NSString *other;               /**< 其他 */

@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *update_time;

+ (DBUserModel *)sharedInstance;

+ (DBUserModel *)initUserModelWithDictionary:(NSDictionary *)info;

+ (DBUserModel *)getUserInfo;

+ (NSString *)getUserId;


/*
{
    address = "\U5317\U4eac\U5e02";
    avatar = "./assets/upfile/avatar_1437826093_2053.png";
    cellphone = 18510238763;
    city = "\U5317\U4eac";
    "create_time" = 1437831111;
    email = "441209821@qq.com";
    "fans_num" = 0;
    "open_id" = dsfsdfsdf123;
    other = "\U8be6\U7ec6\U8bf4\U660e\Uff1f";
    signature = "\U6211\U5c31\U662f\U6211";
    tags = "\U6807\U7b7e\U989d\U989d\U989d";
    "to_fans_num" = 0;
    "update_time" = 1441082518;
    "user_id" = 1;
    "user_name" = lixinhai;
};*/


@end
