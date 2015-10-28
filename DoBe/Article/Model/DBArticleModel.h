//
//  DBArticleModel.h
//  DoBe
//
//  Created by liuxu'an on 15/8/1.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBArticleModel : NSObject


@property (nonatomic, copy) NSString *article_id;    /**< 文章id */
@property (nonatomic, copy) NSString *category_id;   /**< 分类id */
@property (nonatomic, copy) NSString *wx_id;         /**< 微信id */
@property (nonatomic, copy) NSString *wx_name;       /**< 微信名字 */
@property (nonatomic, copy) NSString *title;         /**< 标题 */
@property (nonatomic, copy) NSArray  *thum;          /**< 列表展示图片 */
@property (nonatomic, copy) NSString *tags;          /**< 标签 */
@property (nonatomic, copy) NSString *short_content;       /**< 内容概要 */
@property (nonatomic, copy) NSString *get_time;      /**< 最近一次获取时间 */
@property (nonatomic, copy) NSString *creat_time;
@property (nonatomic, copy) NSString *bad_num;
@property (nonatomic, copy) NSString *good_num;
@property (nonatomic, copy) NSString *content;        /**< 文章详情 */

@property (nonatomic, strong) NSMutableArray *commentList;  /**< 评论列表 */


@end


/*!
 * 微信model @lxa
 */

@interface DBWXModel : NSObject

@property (nonatomic, copy) NSString *wx_id;         /**< 微信id */
@property (nonatomic, copy) NSString *open_id;       /**< open_id */
@property (nonatomic, copy) NSString *wx_name;       /**< 微信名字 */
@property (nonatomic, copy) NSString *wx_avatar;     /**< 微信头像 */
@property (nonatomic, copy) NSString *desc;          /**< 描述 */

@property (nonatomic, assign) BOOL  is_subscribe;    /**< 是否已订阅 */
@property (nonatomic, copy) NSString *category_id;   /**< 属于哪一分类 */

@end


/*!
 * 分类model = 频道 @lxa
 */

@interface DBCategory : NSObject

@property (nonatomic, copy) NSString *category_id;
@property (nonatomic, copy) NSString *category_name;

@end

/*
 {
 "article_id" = 5515;
 "bad_num" = 0;
 "category_id" = 3;
 "create_time" = 1440643472;
 "get_time" = 1440432000;
 "good_num" = 0;
 "short_content" = "\U4e0a\U5b66\U65f6\U6821\U56ed\U6d41\U884c\U4e24\U79cd\U611f\U60c5\Uff1a\U4e00\U79cd\U662f\U4e3a\U4e86\U7231\U60c5\U9009\U62e9\U8d2b\U7a77\U7684\U7cbe\U795e\U4e4b\U604b\Uff1b\U518d\U4e00\U4e2a\U662f\U56e0\U4e3a\U91d1\U94b1\U9009\U62e9\U7269\U8d28\U7684\U5a5a\U59fb\Uff0c\U5979\U9009\U62e9\U4e86\U524d...";
 tags = "<null>";
 thum =                 (
 "http://api.dobe.mobi/assets/thums/144133327286896.jpeg",
 "http://api.dobe.mobi/assets/thums/144133327240296.jpeg",
 "http://api.dobe.mobi/assets/thums/144133327252558.jpeg"
 );
 title = "\U4e00\U652f\U53e3\U7ea2\U6bc1\U4e86\U4e00\U6bb5\U6700\U7f8e\U7684\U7231\U60c5\Uff01\U523a\U75db\U4e86\U591a\U5c11\U4eba\U7684\U5fc3\Uff1f";
 "wx_id" = 52;
 "wx_name" = "\U6bcf\U5929\U4e00\U53e5\U5fc3\U60c5\U7b7e\U540d";
 },
 {
 "article_id" = 5516;
 "bad_num" = 0;
 "category_id" = 2;
 "create_time" = 1440643472;
 "get_time" = 1439827200;
 "good_num" = 0;
 "short_content" = "\U60c5\U7eea\U662f\U4ec0\U4e48\Uff1f\U767e\U5ea6\U767e\U79d1\U5bf9\U60c5\U7eea\U7684\U5b9a\U4e49\Uff1a\U60c5\U7eea\U662f\U5bf9\U4e00\U7cfb\U5217\U4e3b\U89c2\U8ba4\U77e5\U7ecf\U9a8c\U7684\U901a\U79f0\Uff0c\U662f\U591a\U79cd\U611f\U89c9\U3001\U601d\U60f3\U548c\U884c\U4e3a\U7efc\U5408\U4ea7\U751f\U7684...";
 tags = "<null>";
 thum =                 (
 "http://api.dobe.mobi/assets/thums/144133327346301.png"
 );
 title = "\U4f4e\U843d\U60c5\U7eea\U65f6\Uff0c\U8f6c\U79fb\U6ce8\U610f\U529b\U5c31OK\Uff1f\U9519\Uff01";
 "wx_id" = 42;
 "wx_name" = "\U7f8e\U8bfb\U65f6\U5149";
 },*/

