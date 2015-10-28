//
//  DBCommentModel.h
//  DoBe
//
//  Created by liuxuan on 15/6/18.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBCommentModel : NSObject

@property (nonatomic, copy) NSString *guestId;
@property (nonatomic, copy) NSString *guestName;   //游客名称
@property (nonatomic, copy) NSString *detail;      //评论详情
@property (nonatomic, copy) NSString *likedCount; //被点赞数
@property (nonatomic, assign) BOOL    isLiked;     //是否被点赞
@property (nonatomic, copy) NSString *time;        //评论时间
@property (nonatomic, copy) NSString *message;     //回复  DBMessageModel;
@property (nonatomic, strong) UIImage *headImage;

//评论用户name
@property (nonatomic, copy) NSString *comment_id;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *article_id;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *comment_message;
@property (nonatomic, copy) NSString *good_num;   //点赞数
@property (nonatomic, copy) NSString *bad_num;
@property (nonatomic, copy) NSString *comment_status;


+ (DBCommentModel *)initCommentModelWithDictionay:(NSDictionary *)dic;

/*
"comment_id": 1,
"user_id": 1,
"article_id": 1,
"create_time": 1437904999,
"comment_message": "大家好才是真的好",
"good_num": 1,
"bad_num": 2,
"comment_status": 1
*/


@end
