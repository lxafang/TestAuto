//
//  UIViewController+YCCommon.h
//  iWeidao
//
//  Created by yongche on 13-11-8.
//  Copyright (c) 2013年 Weidao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+YCCommon.h"

@class MBProgressHUD;

#define kNetWorkErrorTip  @"网络不给力,请稍后重试"

@interface UIViewController (YCCommon)

@property (nonatomic,strong) UIImageView * homeShotImageV;
@property (nonatomic,strong)MBProgressHUD * hub;

//支付中提示
-(void)showPayingToast;

//支付成功提示
-(void)showPaySuccessToast;

//支付失败提示
-(void)showPayFailureToast;

-(void)showPayCancelToast;

-(void)hidePayToast;

//直接进入支付成功
-(void)showDirctPaySuccessToast;

//直接进入支付失败
-(void)showDirctPayFailureToast;

-(void)showPayMsgToast:(NSString *)msg;


- (void)showProgressHUD;

- (void)hideProgressHUD;
- (void)showToastMessage:(NSString *)message withFont:(NSInteger)num;

- (void)showToastMessage:(NSString *)message;

- (void)showBackButton;

- (void)showBackButtonWithImage:(NSString *)imagestr;

- (void)showBackButtonWithTitle:(NSString *)title;

- (void)hideBackButton;

- (void)showDownButton;

-(void)addSegmentButtonInNav:(NSArray *)titleArray;

-(void)addRoundSegmentButton:(NSArray *)titleArray;

-(void)segmentSelectIndex:(NSInteger)index;

- (void)backBarButtonPressed:(id)sender;

- (void)showRightButtonWithTitle:(NSString *)title;

- (void)hideRightButton;

- (void)showRightButtonWithTitle:(NSString *)title titleColor:(UIColor *)color;

- (void)showRightButtonWithImage:(UIImage *)image andHigImage:(UIImage *)higImage;

- (void)showRightButtonWithBackgroundImage:(UIImage *)image andTitle:(NSString *)title;

- (void)showRightBarButtonItemWithTitle:(NSString *)title;

- (void)showRightBarButtonItemsWithImage:(UIImage *)image andTitle:(NSString *)title;


- (UIButton *)getRightButtonFromRightBarButtonItem;

- (UIButton *)getBackButtonFromRightBarButtonItem;

-(void)showrightButtonWithStatus:(BOOL)isShow;

- (void)changeRightBarButtonItemTextColor:(UIColor *)color;


- (void)rightBarButtonPressed:(id)sender;

- (void)showNetWorkFailToast;

- (void)autoLayoutIOS6OrIOS7NavigationBar;

//- (void)umengBeginEventClick:(NSString *)eventId;
//
//- (void)umengEndEventClick:(NSString *)eventId;

- (void)showOffLineImage:(NSString *)imageName andLabelText:(NSString *)labelText andPoint:(CGPoint)point;

//屏幕截图
- (UIImage *)getSnapshotImage;
-(UIImage *)getSnapshotImageByView:(UIView *)customView;

-(UIViewController *)getSpecificClassWithName:(NSString *)className;

#pragma mark - UITableView

- (void)setExtraCellLineHidden:(UITableView *)tableView;

-(UITableViewCell *)getCellWithTableView:(UITableView *)tableView cellID:(NSString *)cellID nibName:(NSString *)nibName;


-(void)registerTableView:(UITableView *)tableView withCellNibName:(NSString *)nibName cellIdentifier:(NSString *)cellIdentifier;

#pragma mark - UIViewController
/**
 *  获得当前正在显示的ViewController
 *
 *  @return 当前显示的ViewController类名
 */
- (UIViewController *)topMostViewController;

/** 从UIStoryboard初始化UIViewController */
- (UIViewController *)instantiateViewControllerWithIdentifier:(NSString *)storyboardId
                                           withStoryboardName:(NSString *)name;

/** 从UIStoryboard初始化UINavigationController */
- (UINavigationController *)instantiateNavControllerWithIdentifier:(NSString *)identifier
                                                withStoryboardName:(NSString *)name;


@end








