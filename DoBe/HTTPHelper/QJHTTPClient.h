//
//  QJHTTPClient.h
//  QiJi_Driver
//
//  Created by liuxu'an on 15/7/24.
//  Copyright (c) 2015年 liuxu'an. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface QJHTTPClient : AFHTTPRequestOperationManager

+ (QJHTTPClient *)defaultClient;

+ (QJHTTPClient *)clientWithBaseUrl:(NSString *)baseUrl;

+ (QJHTTPClient *)createHttpClient:(NSURL *)baseUrl isJsonResponse:(BOOL)isJsonResponse;

/// 需要带owner_type=client的token
- (void)getClientPath:(NSString *)path
           parameters:(NSDictionary *)parameters
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)postClientPath:(NSString *)path
            parameters:(NSDictionary *)parameters
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/// 取消请求
- (void)cancelOperation;

- (void)cancelOperation:(NSString*)url;

@end
