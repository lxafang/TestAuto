//
//  DBLoginController.m
//  DoBe
//
//  Created by liuxu'an on 15/9/7.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBLoginController.h"
#import "AppDelegate.h"
#import "WXApi.h"
#import "QJHTTPClient.h"

@interface DBLoginController ()

@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, copy) NSString *openid;

@end

@implementation DBLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backTouchUpInside:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)eventWXLgoin:(id)sender {
    /** 测试微信登录 */
    if ([AppDelegate sharedDelegate].isRegisterWX) {
        [[AppDelegate sharedDelegate] sendAuthRequest:nil];
    }else {
        [self showToastMessage:@"请先安装微信。"];
    }
}


#pragma mark - wx

- (void)getWeiXinCodeFinishedWithResp:(BaseResp*)resp {
    //code:0312b3e2bfeb6f6476ee13b8064be50e
    if (resp.errCode == 0) {
        [self showToastMessage:@"用户同意"];
        SendAuthResp *authResp = (SendAuthResp *)resp;
        [self getAccessTokenWithCode:authResp.code];
    }else if (resp.errCode == -4) {
        [self showToastMessage:@"用户拒绝"];
    }else if (resp.errCode == -2) {
        [self showToastMessage:@"用户取消"];
    }
}

/** 获取token */
- (void)getAccessTokenWithCode:(NSString *)code {
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kDBAppID,kDBAppSecret,code];
    [self showProgressHUD];
    QJHTTPClient *client = [QJHTTPClient defaultClient];
    [client getClientPath:urlString parameters:nil
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [self hideProgressHUD];
                      NSData *data = responseObject;
                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                      DLog(@"%@",dic);
                      //TODO: 保存本地
                      _access_token = dic[kWeiXinAccessToken];
                      _openid = dic[kWeiXinOpenId];
                      /*
                       {
                       "access_token":"ACCESS_TOKEN",
                       "expires_in":7200,
                       "refresh_token":"REFRESH_TOKEN",
                       "openid":"OPENID",
                       "scope":"SCOPE",
                       "unionid":"o6_bmasdasdsad6_2sgVt7hMZOPfL"
                       
                       }*/
                      NSString *token = dic[kWeiXinAccessToken];
                      NSString *openid = dic[kWeiXinOpenId];
                      [self getUserInfoWithAccessToken:token andOpenId:openid];
                      
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [self hideProgressHUD];
                      DLog(@"%@",error.description);
                  }];
    
    
}

/** 使用token获取用户信息 */
- (void)getUserInfoWithAccessToken:(NSString *)accessToken andOpenId:(NSString *)openId {
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
    [self showProgressHUD];
    QJHTTPClient *client = [QJHTTPClient defaultClient];
    [client getClientPath:urlString parameters:nil
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [self hideProgressHUD];
                      NSData *data = responseObject;
                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                      DLog(@"%@",dic);
                      [self requestWXLogin:dic];
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [self hideProgressHUD];
                      DLog(@"%@",error.description);
                  }];
}

/*!
 * 使用RefreshToken刷新AccessToken
 * 该接口调用后，如果AccessToken未过期，则刷新有效期，如果已过期，更换AccessToken。 @lxa
 */
- (void)getAccessTokenWithRefreshToken:(NSString *)refreshToken
{
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",kWeiXinOpenId,refreshToken];
    
    [self showProgressHUD];
    QJHTTPClient *client = [QJHTTPClient defaultClient];
    [client getClientPath:urlString parameters:nil
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [self hideProgressHUD];
                      NSData *data = responseObject;
                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                      DLog(@"%@",dic);
                      
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [self hideProgressHUD];
                      DLog(@"%@",error.description);
                  }];
}


/** 微信登录 */

- (void)requestWXLogin:(NSDictionary *)wxInfo {
    [self showProgressHUD];
    /*{
     city = West;
     country = CN;
     headimgurl = "http://wx.qlogo.cn/mmopen/prqyau94JDcG4ibLF4welrsFVUAjJLOVlj3ubribOSQBlNB0iaU75VjUhkSIkyR8gnaY4ciawdlKTM6IRNZOxIFJq9IJySHvbG24/0";
     language = "zh_CN";
     nickname = "\U5f90\U5b89";
     openid = oGrIUs2fhXCmV4UkrN9gacHS5TJo;
     privilege =     (
     );
     province = Beijing;
     sex = 1;
     unionid = "oJTVgs7SdB098QzBcciure_KErSs";
     }*/
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[keyDBWOpenId] = wxInfo[kWeiXinOpenId];
    params[kWeiXinAccessToken] = _access_token;
    params[@"avatar"] = wxInfo[@"headimgurl"];
    
    QJHTTPClient *client = [QJHTTPClient defaultClient];
    [client postClientPath:kUserWXLogin parameters:params
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       [self hideProgressHUD];
                       NSData *data = responseObject;
                       NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                       DLog(@"收藏:%@",dic);
                       NSInteger code = [(NSNumber *)dic[keyRetCode] integerValue];
                       if (code == 200) {
                           [self showToastMessage:@"登录成功"];
                            [DBUserModel initUserModelWithDictionary:dic[keyResult]];
                       }else {
                           [self showToastMessage:NETWORK_ERROR_MSG];
                       }
                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       [self hideProgressHUD];
                       DLog(@"%@",error.description);
                       [self showToastMessage:@"登录失败"];
                   }];
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
