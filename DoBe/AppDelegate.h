//
//  AppDelegate.h
//  DoBe
//
//  Created by liuxuan on 15/6/1.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBMainController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigation;
@property (strong, nonatomic) DBMainController *rootVC;
@property (nonatomic, assign) BOOL isRegisterWX;   //是否注册成功
@property (nonatomic, assign) DBFontSize fontSize;
@property (nonatomic, strong) NSArray *wxList;    /**< 微信列表 */

+ (AppDelegate *)sharedDelegate;

/** 微信登陆 */
- (void)sendAuthRequest:(UIViewController *)viewController;

/** 登陆页面 */
- (void)toLoginPageNotification:(NSNotification *)notification;

/** @[@"小", @"中", @"大", @"超大"] ： 0 1 2 3 */
- (void)setArticleFontSizeWithIndex:(NSInteger )index;

@end

