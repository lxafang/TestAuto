//
//  DBHTTPDefine.h
//  DoBe
//
//  Created by liuxuan on 15/6/17.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#ifndef DoBe_DBHTTPDefine_h
#define DoBe_DBHTTPDefine_h

#define kBaseUrl  @"http://api.dobe.mobi"

#define kBaseApiUrl  @"http://api.dobe.mobi"

/*!
 * 参数 key @lxa
 */

#define keyRetCode  @"ret_code"
#define keyRetMsg   @"ret_msg"
#define keyUserId   @"user_id"
#define keyOffset   @"offset"
#define keyLimit    @"limit"
#define keyResult   @"result"
#define keyArticleId    @"article_id"
#define keyTitle        @"title"
#define keyCategoryId   @"category_id"  //频道id
#define keyCategoryName @"category_name"
#define keyWXId         @"wx_id"        //微信id
#define keyList         @"lists"

#define kDBLimitPerPage  10

/*!
 * error @lxa
 */

#define TIMEOUT_MSG             @"连接超时，请稍候重试"
#define NETWORK_ERROR_MSG       @"当前网络不畅，请您稍后重试"

/*!
 * 接口 @lxa
 */

//http://api.dobe.mobi/user/profile

#pragma mark - site 接口



#define kSiteWXList         @"/site/wxlist"            /** 获取微信列表 */
#define kSiteCategotyList   @"/site/categorylist"      //获取分类列表
#define kSiteArticlelist    @"/site/articlelist"       //获取频道文章列表
#define kSiteRecommend      @"/site/recommend"         //获取推荐文章列表
#define kSiteArticleDetail   @"/site/articledetail"    //获取文章详情
#define kSitComment          @"/site/comment"          //提交评论
#define kSiteCommentList     @"/site/commentlist"       //文章评论列表
#define kSiteStand           @"/site/stand"            //对评论 好评1 差评2
#define kSiteIsStand         @"/site/Isstand"          //是否对文章已表态
//http://api.dobe.mobi/site/Isstand?article_id=文章ID&user_id=用户ID
#define kSitePraise          @"/site/praise"           //对文章 赞与反对  好评1 差评2

#define kSiteSearchlist      @"/site/getsearchlist"    //搜索列表
#define kSiteSearchArticle   @"/site/searcharticle"    //搜索文章  d

#pragma mark - User 接口

#define kUserWXLogin          @"/user/wxlogin"
#define kUserLogin            @"/user/profile/user_id/1"

#define kUserProfile          @"/user/profile"
#define kUserChangeProfile    @"/user/changeprofile"
#define kUserFeedback         @"/user/feedback"        //反馈意见

/** 收藏 */
#define kUserGetCollection       @"/user/getcollection"
#define kUserAddCollection       @"/user/addcollection"
#define kUserCancelCollection    @"/user/cancelcollection"

/** 订阅 */
#define kUserGetSubscribe        @"/user/getsubscribe"
#define kUserAddSubscribe        @"/user/addsubscribe"
#define kUserCancelSubscribe     @"/user/cancelsubscribe"

#endif
