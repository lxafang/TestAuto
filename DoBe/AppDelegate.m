//
//  AppDelegate.m
//  DoBe
//
//  Created by liuxuan on 15/6/1.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "AppDelegate.h"
#import "DBMainController.h"
#import "WXApi.h"
#import "DBMyController.h"
#import "WXController.h"
#import "DBLoginController.h"
#import "QJHTTPClient.h"

@interface AppDelegate () <WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    DBMainController *main_vc = [[DBMainController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:main_vc];
    _rootVC = main_vc;
    [nav.navigationBar setTranslucent:YES];
    _navigation = nav;
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UIImage *bgImage = [UIImage imageNamed:@"my_buttonbg"]; //328*40  194*120
    [nav.navigationBar setBackgroundImage:[bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 20.0f, 19.0f, 307.0f) resizingMode:UIImageResizingModeStretch]forBarMetrics:UIBarMetricsDefault];
    [nav.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
    
    DBUser *userInfo = [DBUser sharedInstance];
    userInfo.name = @"MIMO";
    userInfo.signature = @"这家伙很懒什么也没留下";
    userInfo.headImage = @"my_headImage";
    
    userInfo.cellphone = @"13954009794";
    userInfo.email = @"13954009794@139.com";
    userInfo.city = @"北京";
    userInfo.address = @"海淀区北四环中关村大街66号";
    userInfo.tags = @[@"宅男",@"技术控",@"驴友",@"程序猿"];
    
    userInfo.focusCount = @"10";
    userInfo.fans = @"20";
    userInfo.doCion = @"1000";
    
    //向微信注册
    _isRegisterWX = [WXApi registerApp:kDBAppID withDescription:kDBAppDescription];
    
    [self addAppNotification];
    
    _fontSize = DBFontSizeMedium;
    return YES;
}


+ (AppDelegate *)sharedDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)sendAuthRequest:(UIViewController *)viewController {
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo"; // @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"; // @"post_timeline,sns"
    req.state = kDBAppDescription;
    //req.openID = @"0c806938e2413ce73eef92cc3";
    [WXApi sendReq:req];
}

#pragma mark - WXApiDelegate

-(void) onReq:(BaseReq*)req {
    DLog(@"req:%@",req);
}

- (void)onResp:(BaseResp *)resp {
    DLog(@"resp:%@",resp);
   [_rootVC.wxVC getWeiXinCodeFinishedWithResp:resp];
}

#pragma mark - Notification

- (void)addAppNotification {
    /** 到登陆页 */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(toLoginPageNotification:)
                                                 name:kNotificationToLoginPage object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(toLoginSuccessNotification:)
                                                 name:kNotificationLoginSuccess object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(toLoginFailedNotification:)
                                                 name:kNotificationLoginSuccess object:nil];
}

- (void)toLoginPageNotification:(NSNotification *)notification {
    
    UIViewController *currentVC = notification.object;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"My" bundle:nil];
    
    UIViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"DBLoginController"];
    _rootVC.loginVC = (DBLoginController *)loginVC;
    [currentVC presentViewController:_rootVC.loginVC animated:YES completion:^{
    }];
}

- (void)toLoginSuccessNotification:(NSNotification *)notification {
    [_rootVC.loginVC dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)toLoginFailedNotification:(NSNotification *)notification {
    [_rootVC.loginVC dismissViewControllerAnimated:YES completion:^{
    }];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - custom

- (void)setArticleFontSizeWithIndex:(NSInteger )index {
    if (index == 0) {
        _fontSize = DBFontSizeMinor;
    }else if (index == 1) {
        _fontSize = DBFontSizeMedium;
    }else if (index == 2) {
        _fontSize = DBFontSizeBig;
    }else if (index == 3) {
        _fontSize = DBFontSizeHuge;
    }
}

/** 获取微信列表 */
- (void)requestWXList {
    
    QJHTTPClient *client = [QJHTTPClient defaultClient];
    [client getClientPath:kSiteWXList parameters:@{keyUserId:[DBUserModel getUserId]}
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      
                      NSData *data = responseObject;
                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                      DLog(@"订阅列表:%@",dic);
                      NSInteger code = [(NSNumber *)dic[keyRetCode] integerValue];
                      NSString *ret_msg = dic[keyRetMsg];
                      if (code == 200) {
                          NSArray *array = [dic objectSafeForKey:@"result"][@"lists"];
                          self.wxList = [NSMutableArray arrayWithArray:array];
                      }else {
                      }
                      
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  }];
}

@end
