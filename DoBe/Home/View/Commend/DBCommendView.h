//
//  DBCommendView.h
//  DoBe
//
//  Created by liuxuan on 15/6/4.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSelectRowBlock)(NSInteger row);
typedef void(^ReloadDataBlock)();
typedef void(^RequestMoreBlock)(NSUInteger offset);

@class SRRefreshView;

@interface DBCommendView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SRRefreshView *refreshView;
@property (nonatomic, copy) DidSelectRowBlock didSelectRowBlock;
@property (nonatomic, copy) ReloadDataBlock reloadDataBlock;     /**< 刷新数据 */
@property (nonatomic, copy) RequestMoreBlock requestMoreBlock;   /**< 加载更多 */

@property (nonatomic, strong) NSArray *articleList;  /**< 某个分类文章列表 DBArticleModel */
@property (nonatomic, assign) NSUInteger offset;     /**< 请求页数 */
@property (nonatomic, copy) NSString *categoryName;  /**< 频道名字 */

@end
