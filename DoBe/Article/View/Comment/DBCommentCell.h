//
//  DBCommentCell.h
//  DoBe
//
//  Created by liuxuan on 15/6/16.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CellPraiseEventBlock)();
typedef void(^CellMessageEventBlock)();

@class DBCommentModel;

@interface DBCommentCell : UITableViewCell

@property (nonatomic, copy)CellPraiseEventBlock  cellPraiseEventBlock;
@property (nonatomic, copy)CellMessageEventBlock cellMessageEventBlock;

- (void)setCommentText:(NSString *)text;

- (void)setCommentModel:(DBCommentModel *)model;

@end
