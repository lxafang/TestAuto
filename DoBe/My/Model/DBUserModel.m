//
//  DBUserModel.m
//  DoBe
//
//  Created by liuxu'an on 15/7/25.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBUserModel.h"
#import <MJExtension/MJExtension.h>

#define kDBUserInfo @"DBUserModel"
static DBUserModel *_instance = nil;

@implementation DBUserModel

+ (DBUserModel *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DBUserModel alloc] init];
    });
    return _instance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        
        _user_id = @"1";
        _open_id = @"";
        _user_name = @"";
        _avatar = @"";
        _signature = @"";
        _city = @"";
        _cellphone = @"";
        _email = @"";
        _address = @"";
        _tags = @"";
        _to_fans_num = @"0";
        _fans_num = @"0";
        _cion_num = @"0";
        _other = @"";
        _create_time = @"";
        _update_time = @"";
        
    }
    return self;
}

+ (DBUserModel *)initUserModelWithDictionary:(NSDictionary *)info {
    
    /*
    // judge nil
    if(![dict objectForKey:key]){
        return NO;
    }
    id obj = [dict objectForKey:key];// judge NSNull
    
    return ![obj isEqual:[NSNull null]];*/
    
    /** 保存到本地 */
    DBUserModel *model = [self sharedInstance];
    model = [DBUserModel objectWithKeyValues:info];
    
    NSDictionary *dic = [model keyValues];
    DefaultSetObjectForKey(dic, kDBUserInfo);
    return model;
}

+ (DBUserModel *)getUserInfo {
    NSDictionary *dic = DefaultObjdectForKey(kDBUserInfo);
    if (!dic) {
        return nil;
    }
    DBUserModel *model = [DBUserModel sharedInstance];
    model = [DBUserModel objectWithKeyValues:dic];
    return model;
}

+ (NSString *)getUserId {
    NSDictionary *dic = DefaultObjdectForKey(kDBUserInfo);
    if (!dic) {
        return @"13";
    }
    return [dic stringSafeForKey:keyUserId];
}

#pragma mark - getter

/*
- (NSString *)user_id {
    NSDictionary *dic = DefaultObjdectForKey(kDBUserInfo);
    if (!dic) {
        return @"";
    }
    return [dic stringSafeForKey:keyUserId];
}*/

/*
#pragma mark - 编码/解码

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
}*/

@end
