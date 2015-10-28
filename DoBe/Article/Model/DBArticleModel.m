//
//  DBArticleModel.m
//  DoBe
//
//  Created by liuxu'an on 15/8/1.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBArticleModel.h"

@implementation DBArticleModel



- (instancetype)init {
    self = [super init];
    if (self) {
        _article_id = @"";
        _category_id = @"";
        _commentList = [[NSMutableArray alloc] init];
    }
    return self;
}


@end

////////////////////////////////////////

@implementation DBWXModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end

////////////////////////////////////////

@implementation DBCategory

- (instancetype)init {
    self = [super init];
    if (self) {
        _category_id = @"";
        _category_name = @"";
    }
    return self;
}

@end
