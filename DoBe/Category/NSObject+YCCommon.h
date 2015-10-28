//
//  NSObject+YCCommon.h
//  iWeidao
//
//  Created by yongche on 14-3-28.
//  Copyright (c) 2014年 Weidao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@interface NSObject (YCCommon)


- (RACSignal *)showMessage:(NSString *)message withTitle:(NSString *)title;

- (RACSignal *)showMessageWithCode:(NSInteger)code
                         orMessage:(NSString *)message;

- (RACSignal *)showMessage:(NSString *)message
                 withTitle:(NSString *)title
             withMenuTitle:(NSString *)menuTitle
         otherButtonTitles:(NSString *)otherTitle;

- (RACSignal *)showMessage:(NSString *)message
                 withTitle:(NSString *)title
             withMenuTitle:(NSString *)menuTitle;

//- (void)umengEventClick:(NSString*)eventId;

@end
