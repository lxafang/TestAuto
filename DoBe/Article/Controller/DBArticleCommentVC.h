//
//  DBArticleCommentVC.h
//  DoBe
//
//  Created by liuxuan on 15/6/4.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBBaseController.h"

@class DBArticleModel;

typedef void(^ResetCommentCount)(NSInteger count);

@interface DBArticleCommentVC : DBBaseController

@property (nonatomic, strong) NSMutableArray *commentList; /**< 评论列表 DBCommentModel */
@property (nonatomic, strong) DBArticleModel *articleInfo;

@property (nonatomic, copy)ResetCommentCount resetCommentCount;  /**< 重置评论数 */

@end
