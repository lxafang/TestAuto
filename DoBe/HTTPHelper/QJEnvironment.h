//
//  QJEnvironment.h
//  QiJi_Driver
//
//  Created by liuxu'an on 15/7/24.
//  Copyright (c) 2015年 liuxu'an. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Debug,
    Release
} EnvironmentType;

@interface QJEnvironment : NSObject {
    
}

@property (nonatomic,copy )  NSString *baseApiUrl;
@property (nonatomic,strong) NSArray * environmentArray;   //环境变量数组
@property (nonatomic,assign) EnvironmentType environmentType;

+ (QJEnvironment *)sharedInstance;

+(NSMutableDictionary *)getAllEnvironmentConfigFromLocation;

+(NSDictionary *)getCurrentAvailableConfig;

+(NSString * )getCurrentEnviName;

@end
