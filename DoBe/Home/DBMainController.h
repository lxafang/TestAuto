//
//  DBMainController.h
//  BYDailyNews
//
//  Created by bassamyan on 15/1/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBBaseController.h"

@class WXController;
@class DBLoginController;

@interface DBMainController : DBBaseController

@property (nonatomic, strong) NSMutableArray *topSortList;
@property (nonatomic, strong) NSMutableArray *bottomSortList;
@property (nonatomic, strong) NSMutableArray *loadedSortList;   /**< 已加载过的item */

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSString *currentItem;           /**< 当前显示的item key 如 推荐 新闻 */

@property (nonatomic, strong) WXController *wxVC;  //微信登录页面
@property (nonatomic, strong) DBLoginController *loginVC;

@end
