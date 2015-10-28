//
//  QJHTTPClient.m
//  QiJi_Driver
//
//  Created by liuxu'an on 15/7/24.
//  Copyright (c) 2015年 liuxu'an. All rights reserved.
//

#import "QJHTTPClient.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation QJHTTPClient {
    
}

+ (QJHTTPClient *)defaultClient {
    static QJHTTPClient *client = nil;
    if (client == nil) {
        NSURL *url = [NSURL URLWithString:[QJEnvironment sharedInstance].baseApiUrl];
        client = [self createHttpClient:url isJsonResponse:NO];
    }
    return client;
}

+ (QJHTTPClient *)clientWithBaseUrl:(NSString *)baseUrl{
    QJHTTPClient *baseClient;
    NSURL *url = [NSURL URLWithString:baseUrl];
    baseClient = [QJHTTPClient createHttpClient:url isJsonResponse:YES];
    return baseClient;
}

+ (QJHTTPClient *)createHttpClient:(NSURL *)baseUrl isJsonResponse:(BOOL)isJsonResponse
{
    QJHTTPClient *client = [[QJHTTPClient alloc] initWithBaseURL:baseUrl];
    if (!isJsonResponse) {
        [client setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    }else{
        AFJSONResponseSerializer* responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.removesKeysWithNullValues = YES;
        [client setResponseSerializer:responseSerializer];
    }
    //[NSSetsetWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    // 请求超时时间
    client.requestSerializer.timeoutInterval = 20;
    client.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
    
    return client;
}

- (void)getClientPath:(NSString *)path
           parameters:(NSDictionary *)parameters
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    // if has user access token, use it, or use credentitals token
    DLog(@"====params:%@",params);
    if ([self setTokenParameter:params]) {
        [super GET:path
        parameters:params
           success:success
           failure:failure];
    }
}

- (void)postClientPath:(NSString *)path
            parameters:(NSDictionary *)parameters
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    DLog(@"====params:%@",params);
    if ([self setTokenParameter:params]) {
        [super POST:path
         parameters:params
            success:success
            failure:^(AFHTTPRequestOperation *operation, NSError *error){
            
        }];
    }
}

#pragma mark - private

- (BOOL)setTokenParameter:(NSMutableDictionary *)params
{
    /*
    QJUser * user = [QJUser  currentUser];
    if ([user getAccessToken]) {
        [params setValue:[user getAccessToken] forKey:@"access_token"];
    } else if (user.catcheDic){
        [params setValue:[user.catcheDic valueForKey:@"access_token"] forKey:@"access_token"];
    }else {
        if ([DefaultValueForKey(kCredentialsToken) isKindOfClass:[NSString class]]) {
            return NO;
        } else {
            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCredentialsToken];
            NSDictionary *tokenInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            if (tokenInfo[@"access_token"] != nil) {
                [params setValue:tokenInfo[@"access_token"] forKey:@"access_token"];
            } else {
                return NO;
            }
        }
    }*/
    return YES;
}

/*
- (RACSignal *)refreshCredentialsTokenSuccess {

    
    if (_credentialTokenSubject) {
        return _credentialTokenSubject;
    } else {
        _credentialTokenSubject = [[RACSubject alloc] init];
    }
    NSString *adId = [[[ASIdentifierManager sharedManager]advertisingIdentifier] UUIDString];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:kDeviceToken];
    if (!deviceToken) {
        deviceToken = @"";
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"client_credentials",@"grant_type",
                            adId,@"uuid",
                            deviceToken,@"device_token",
                            [YCMacAddress macaddress],@"macaddress",
                            nil];
    
    AFHTTPRequestSerializer * RequestHeader = [AFHTTPRequestSerializer serializer];
    [RequestHeader setAuthorizationHeaderFieldWithUsername:[QJEnvironment sharedInstance].ClientId
                                                  password:[QJEnvironment sharedInstance].ClientSecret];
    [RequestHeader setValue:@"application/x-www-form-urlencoded"
         forHTTPHeaderField:@"Content-Type"];
    [RequestHeader setValue:[QJTools getUserAgent] forHTTPHeaderField:@"User-Agent"];
    RequestHeader.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
    RequestHeader.timeoutInterval = 20;
    [self setRequestSerializer:RequestHeader];
    [self POST:kApiGetToken
    parameters:params
       success:^(AFHTTPRequestOperation *operation,
                 id responseObject)
     {
         [RequestHeader clearAuthorizationHeader];
         NSData *data = [NSKeyedArchiver archivedDataWithRootObject:responseObject];
         [[NSUserDefaults standardUserDefaults] setObject:data
                                                   forKey:kCredentialsToken];
         [[NSUserDefaults standardUserDefaults] synchronize];
         [_credentialTokenSubject sendNext:responseObject];
         [_credentialTokenSubject sendCompleted];
         _credentialTokenSubject = nil;
         
         if ([responseObject[@"is_black_device"] intValue] == 1 &&
             ![DefaultValueForKey(@"isblack") isEqualToString:@"1"]) {//黑名单
             if (responseObject[@"ret_msg"]) {
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                    message:responseObject[@"ret_msg"]
                                                                   delegate:self
                                                          cancelButtonTitle:@"我知道了"
                                                          otherButtonTitles:nil];
                 
                 [alertView show];
                 DefaultSetValueForKey(@"1", @"isblack");
                 [[alertView rac_buttonClickedSignal] subscribeNext:^(id buttonIndex) {
                     if ([buttonIndex integerValue] == 0) {
                         YCAppDelegate *app = (YCAppDelegate *)[UIApplication sharedApplication].delegate;
                         UIWindow *window = app.window;
                         [UIView animateWithDuration:0.5f animations:^{
                             window.alpha = 0;
                             window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
                         } completion:^(BOOL finished) {
                             DefaultSetValueForKey(@"0", @"isblack");
                             exit(0);
                         }];
                         
                     }
                 }];
             }
         }else if([responseObject[@"is_black_device"] intValue] == 0){
             DefaultSetValueForKey(@"0", @"isblack");
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [RequestHeader clearAuthorizationHeader];
         [_credentialTokenSubject sendError:error];
         _credentialTokenSubject = nil;
     }];
    return _credentialTokenSubject;
}*/


/// 取消请求
- (void)cancelOperation {
    [self.operationQueue cancelAllOperations];
}

- (void)cancelOperation:(NSString*)url {
    
}

@end
