//
//  QJEnvironment.m
//  QiJi_Driver
//
//  Created by liuxu'an on 15/7/24.
//  Copyright (c) 2015年 liuxu'an. All rights reserved.
//

#import "QJEnvironment.h"

@implementation QJEnvironment

- (instancetype)init {
    self = [super init];
    if (self) {
        NSDictionary* environments = [[QJEnvironment getAllEnvironmentConfigFromLocation] copy];
        self.environmentArray = [environments allKeys];//存储所有的环境
        
        NSString* configuration  = [QJEnvironment getCurrentEnviName];
        
        if ([configuration isEqualToString:@"Debug"]) {
            _environmentType = Debug;
        }else if ([configuration isEqualToString:@"Release"]) {
            _environmentType = Release;
        }
        
        NSDictionary * plistEnvironment = [[QJEnvironment getCurrentAvailableConfig] copy];
        
        self.baseApiUrl = plistEnvironment[@"kBaseApiUrl"];
        
        if ([QJTools isBlankObject:_baseApiUrl]) {
            self.baseApiUrl = kBaseApiUrl;
        }
    }
    return self;
}

+ (QJEnvironment *)sharedInstance {
    
    static QJEnvironment *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[QJEnvironment alloc] init];
    });
    
    return _sharedInstance;
}

#pragma mark - public

/**
 *  从本地读取所有的环境配置信息
 *
 *  @return 以字典形式返回所有的配置信息
 */
+ (NSMutableDictionary *)getAllEnvironmentConfigFromLocation
{
    NSString *configPlistPath = [kPATH_OF_DOCUMENT stringByAppendingString:@"/currentEnviment.txt"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:configPlistPath];
    if (isExist) {
        NSData * data = [NSData dataWithContentsOfFile:configPlistPath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]
                                         initForReadingWithData:data];
        return  [NSMutableDictionary dictionaryWithDictionary:[unarchiver decodeObjectForKey:@"buildEnvirment"]];
        
    }else
        return [self getAllEnvironmentConfigFromPlist];
}

/**
 *  获取当前可用的配置信息（某一个）
 *
 *  @return 以字典字典当前可用的配置信息（某一个）
 */
+ (NSMutableDictionary *)getCurrentAvailableConfig
{
    NSMutableDictionary * dic = [self getAllEnvironmentConfigFromLocation];
    NSDictionary * subDic  = [dic objectForKey:[self getCurrentEnviName]];
    return [NSMutableDictionary dictionaryWithDictionary:subDic];
}

/**
 *  获取当前环境的名字
 *
 */
+ (NSString * )getCurrentEnviName
{
    NSString* configuration = [NSString stringWithString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"Configuration"]];
    NSString * tmpConfiguration = DefaultValueForKey(kCurrentBuildConfig);
    if (tmpConfiguration.length > 0) {
        configuration = tmpConfiguration;
    }
    return configuration;
}

#pragma mark - private

+ (NSMutableDictionary *)getAllEnvironmentConfigFromPlist
{
    NSString* envsPListPath = [[NSBundle mainBundle] pathForResource:@"QJEnvironments" ofType:@"plist"];
    NSDictionary* environments = [[NSDictionary alloc] initWithContentsOfFile:envsPListPath];
    return [NSMutableDictionary dictionaryWithDictionary:environments];
}
@end
