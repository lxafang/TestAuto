//
//  DBUser.m
//  DoBe
//
//  Created by liuxuan on 15/6/3.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBUser.h"

static DBUser *sharedInstance = nil;

@implementation DBUser

+ (DBUser *)sharedInstance {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[DBUser alloc] init];
        }
    }
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.signature = @"这家伙很懒，什么都没留下";
    }
    return self;
}

- (void)getUserId {
    
}

- (void)clearData {
    
}

@end
