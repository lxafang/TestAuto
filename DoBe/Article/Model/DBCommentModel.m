//
//  DBCommentModel.m
//  DoBe
//
//  Created by liuxuan on 15/6/18.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBCommentModel.h"

@implementation DBCommentModel

- (instancetype)init {
    self = [super init];
    if ( self) {
        _guestName = @"豆比游客";
        _headImage = [UIImage imageNamed:@"my_headImage1"];
        _likedCount = @"0";
        _isLiked = NO;
        _detail = @"";
        _time = @"1小时前";
        
        _message = @"说得很NB！！！";
    }
    return self;
}

+ (DBCommentModel *)initCommentModelWithDictionay:(NSDictionary *)dic {
    
    DBCommentModel *model = [[DBCommentModel alloc] init];
    return model;
}

@end
