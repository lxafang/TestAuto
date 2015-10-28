//
//  DBArticleDetailVC.m
//  DoBe
//
//  Created by liuxuan on 15/6/4.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBArticleDetailVC.h"
#import "DBArticleReportVC.h"
#import "DBArticleCommentVC.h"

#import "DBHeadlineView.h"
#import "DBBottomView.h"
#import "DBCoverView.h"
#import "DBCommentView.h"
#import "DBCommentCell.h"

#import "DBCommentModel.h"
#import "DBArticleModel.h"
#import "QJHTTPClient.h"
#import "AppDelegate.h"
#import <MJExtension.h>
#import <ReactiveCocoa.h>
#import "UIWebView+HTML5.h"


@interface DBArticleDetailVC ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIWebViewDelegate> {
    
    DBBottomView   *_bottomView;  //H:50
    DBCommentView  *_commentView; //H:125
    
    CGFloat keyboardHeight;  //键盘高度
    NSInteger commentCount;  //评论数
    
    BOOL _isCollected;     //是否已收藏
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet DBHeadlineView *headlineView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView        *colorView;
@property (nonatomic, strong) DBCoverView   *coverView;
@property (nonatomic, strong) DBCommentView *commentView;

@property (nonatomic, strong) NSArray *typeList;    // 相关新闻、更多频道、最新评论
@property (nonatomic, strong) NSMutableArray *commentList; //评论

@property (nonatomic, strong) UIWebView *webView;
@end

@implementation DBArticleDetailVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"文章详情";
    [self showBackButton];
    
    [self requestArticleDetail];
    [self requestCommentList];
    
    [self initData];
    [self loadSubViews];
    [self handleSubViewsEvent];
    [self addKeyboardNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //评论数
    if (_commentList.count > 0) {
        commentCount = _commentList.count;
        [_bottomView resetCommentCount:commentCount];
    }
}

#pragma mark - view

- (void)loadSubViews{
    /*
    [_scrollView setContentSize:CGSizeMake(kScreenWidth, MAXFLOAT)];
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.showsVerticalScrollIndicator = YES;
    
    _headlineView = [[NSBundle mainBundle] loadNibNamed:@"DBHeadlineView" owner:self options:nil][0];
    CGFloat headH = _headlineView.height;
    _headlineView.frame = CGRectMake(0.f, 0.f, kScreenWidth, headH);

    _tableView.frame = CGRectMake(0.f, headH, kScreenWidth, kScreenHeight - headH - 50.0f);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;*/
    
    _bottomView = [[NSBundle mainBundle] loadNibNamed:@"DBBottomView" owner:self options:nil][0];
    _bottomView.frame = CGRectMake(0.f, kScreenHeight - 50.0f, self.view.width, 50.0f);
    [self.view addSubview:_bottomView];
    
    
    
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    // h:340
    _coverView = [[NSBundle mainBundle] loadNibNamed:@"DBCoverView" owner:self options:nil][0];
    _coverView.frame = CGRectMake(0.f, kScreenHeight, kScreenWidth, 340.0f);
    [window addSubview:_coverView];
    
}

- (void)loadColorViewInWindowBelowSubView:(UIView *)subView  {
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    
    _colorView = [[UIView alloc] initWithFrame:CGRectMake(window.frame.origin.x, window.frame.origin.y, window.frame.size.width, window.frame.size.height)];
    _colorView.backgroundColor = [UIColor blackColor];
    _colorView.alpha = 0.5;
    [window insertSubview:_colorView belowSubview:subView];
}

- (void)loadSendCommentViewInWindow {
    if (!_commentView) {
        _commentView = [[NSBundle mainBundle] loadNibNamed:@"DBCommentView" owner:self options:nil][0];
    }
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:_commentView];
    [_commentView setFirstResponder];
}

#pragma mark - webView

- (void)loadHeadWebView {
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    _webView.opaque = NO;
    _webView.scalesPageToFit = YES;
    _webView.frame = CGRectMake(0, 64.f, kScreenWidth, self.view.height - 50.f - 64.f);
    [_webView loadHTMLString:_articleInfo.content baseURL:nil];
    [self.view addSubview:_webView];
}
//http://www.uml.org.cn/mobiledev/201108181.asp
//http://zxs19861202.iteye.com/blog/1853102
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //设置字体
//    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '260%'"];//修改百分比即可
    
    DBFontSize fontSize = [AppDelegate sharedDelegate].fontSize;
    [webView stringByEvaluatingJavaScriptFromString: [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%ld%%'",fontSize]];//修改百分比即可

    
    //设置webView内容宽度等于屏幕宽度显示,设置webView的缩放效果
    //(initial-scale是初始缩放比,minimum-scale=1.0最小缩放比,maximum-scale=5.0最大缩放比,user-scalable=yes是否支持缩放)
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"",webView.width];
    [webView stringByEvaluatingJavaScriptFromString:meta];
    
//    NSArray *imgs = [webView getImgs];
    
//    [webView setImgWidth:webView.width];
    
    //拦截网页图片  并修改图片大小
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth=500;" //缩放系数
     "for(i=0;i <document.images.length;i++){"
         "myimg = document.images[i];"
         "if(myimg.width > maxwidth){"
             "oldwidth = myimg.width;"
             "myimg.width = maxwidth;"
             "myimg.height = myimg.height * (maxwidth/oldwidth);"
          "}"
       "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    //边距
    [webView stringByEvaluatingJavaScriptFromString:
     @"var tagHead =document.documentElement.firstChild;"
     "var tagStyle = document.createElement(\"style\");"
     "tagStyle.setAttribute(\"type\", \"text/css\");"
     "tagStyle.appendChild(document.createTextNode(\"BODY{padding: 20pt 15pt}\"));"
     "var tagHeadAdd = tagHead.appendChild(tagStyle);"];
}

/* 计算UIWebView的高度
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    const CGFloat defaultWebViewHeight = 22.0;
    //reset webview size
    CGRect originalFrame = webView.frame;
    webView.frame = CGRectMake(originalFrame.origin.x, originalFrame.origin.y, 320, defaultWebViewHeight);
    
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    if (actualSize.height <= defaultWebViewHeight) {
        actualSize.height = defaultWebViewHeight;
    }
    CGRect webViewFrame = webView.frame;
    webViewFrame.size.height = actualSize.height;
    webView.frame = webViewFrame;
    
}*/

#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _typeList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 1;
    if (section == 0) {
        
        NSDictionary *dic = _typeList[section];
        NSArray *array = dic[@"相关新闻"];
        count = array.count + 1;
    }else if (section == 1) {
        count = 2;
    }else {
        count = commentCount + 1;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSDictionary *dic = [_typeList objectAtIndexSafe:section];
    if (row == 0) {
        CellID = @"newsCellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        }
        [cell.textLabel setText:[dic allKeys][0]];
        if (section == 0) {
            [cell.imageView setImage:[UIImage imageNamed:@"article_news"]];
            [cell.textLabel setText:@"相关新闻"];
        }else if (section == 1) {
            [cell.imageView setImage:[UIImage imageNamed:@"article_morechannel"]];
            [cell.textLabel setText:@"更多频道"];
        }else {
            [cell.imageView setImage:[UIImage imageNamed:@"article_newcomment"]];
            [cell.textLabel setText:@"最新评论"];
        }
        return cell;
    }else if (section == 1 && row > 0) {
        CellID = @"channelCellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        }
        [cell.textLabel setText:dic[@"更多频道"][row - 1]];
        return cell;
        
    }else if(section == 2 && row > 0) {
        //最新评论
        static NSString *cellID = @"DBCommentCellID";
        DBCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"DBCommentCell" owner:self options:nil][0];
        }
        [cell setCommentModel:[_commentList objectAtIndexSafe:indexPath.row - 1]];
        
        cell.cellMessageEventBlock = ^ {
            //回复
            NSLog(@"回复");
        };
        cell.cellPraiseEventBlock = ^ {
            //点赞
            DBCommentModel *model = [_commentList objectAtIndexSafe:indexPath.row - 1];
            
            if (!model.isLiked) {
                model.isLiked = YES;
                model.likedCount =  [NSString stringWithFormat:@"%ld", model.likedCount.integerValue + 1];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                 withRowAnimation:UITableViewRowAnimationFade];
            }else {
                [self showToastMessage:@"您已顶过"];
            }
        };
        return cell;
    }else if(section == 0 && row > 0 ){
        CellID = @"newsCellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        }
        [cell.textLabel setText:dic[@"相关新闻"][row - 1]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0 || row == 0) {
        return 44.0f;
    }else if (section == 1 && row > 0) {
        return 100.0f;
    }else if(section == 2 && row > 0) {
        DBCommentCell *cell = (DBCommentCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        CGFloat height = cell.height;
        return height;
    }
    return 0.f;
}

-  (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 20)];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark UIScrollViewDelegate 


#pragma mark - event

- (void)handleSubViewsEvent {
    
    __weak __typeof(self)weakSelf = self;
    //底部事件
    _bottomView.bottomEventBlock = ^(NSInteger tag) {
        switch (tag) {
            case 101:{
                
                if (![[DBLoginModel sharedInstance] isLogin]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationToLoginPage object:weakSelf];
                    return;
                }
                //写评论
                [weakSelf loadSendCommentViewInWindow];
                [weakSelf loadColorViewInWindowBelowSubView:weakSelf.commentView];
                //发送评论事件
                weakSelf.commentView.sendCommentBlock = ^(NSString *commentStr, BOOL isSend) {
                    if (isSend) {
                        DLog(@"%@",commentStr);
                        [weakSelf requestComment:commentStr];
                        //提交评论接口
                        /*
                        DBCommentModel *model = [[DBCommentModel alloc] init];
                        model.detail = commentStr;
                        model.guestName = [DBUser sharedInstance].name;
                        model.headImage = [UIImage imageNamed:[DBUser sharedInstance].headImage];
                        [weakSelf.commentList insertObject:model atIndex:0];
                        commentCount = _commentList.count;
                        [_bottomView resetCommentCount:commentCount];*/
                    }
                    [weakSelf.colorView removeFromSuperview];
                    [weakSelf.commentView removeFromSuperview];
                };

            }
                break;

            case 102:{
                //查看评论
                DBArticleCommentVC *commentVC = (DBArticleCommentVC*)[weakSelf instantiateViewControllerWithIdentifier:@"DBArticleCommentVC"
                                                                           withStoryboardName:@"DBArticle"];
                commentVC.commentList = weakSelf.commentList;
                commentVC.articleInfo = weakSelf.articleInfo;
                [weakSelf.navigationController pushViewController:commentVC animated:YES];
                
                commentVC.resetCommentCount = ^(NSInteger count){
                    [weakSelf requestCommentList];
                };
            }
                break;
            case 103:{
                //收藏
                if (![[DBLoginModel sharedInstance] isLogin]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationToLoginPage object:weakSelf];
                    return;
                }
                if (_isCollected) {
                    [weakSelf requestUserCancelCollection];
                }else {
                    [weakSelf requestUserAddCollection];
                }
            }
                break;
            case 104:{
                //转发分享
            }
                break;
            case 105:{
                //设置
                [weakSelf loadColorViewInWindowBelowSubView:weakSelf.coverView];
                [UIView animateWithDuration:0.5f animations:^{
                    weakSelf.coverView.frame = CGRectMake(0.f, kScreenHeight, kScreenWidth, 340.0f);
                } completion:^(BOOL finished) {
                    weakSelf.coverView.frame = CGRectMake(0.f, kScreenHeight - 340.0f, kScreenWidth, 340.0f);

                }];
            }
                break;

            default:
                break;
        }
    };
    
    //评论文章
    _coverView.coverBottomBlock = ^(NSInteger tag) {
        if (tag == 201) {
            //不感兴趣
        }else if (tag == 202) {
            //劣质文章
        }else {
            //举报问题
            [weakSelf.colorView removeFromSuperview];
            [UIView animateWithDuration:0.5f animations:^{
                weakSelf.coverView.frame = CGRectMake(0.f, kScreenHeight - 340.0f, kScreenWidth, 340.0f);
            } completion:^(BOOL finished) {
                weakSelf.coverView.frame = CGRectMake(0.f, kScreenHeight, kScreenWidth, 340.0f);
                
                DBArticleReportVC *reportVC = (DBArticleReportVC *)[weakSelf instantiateViewControllerWithIdentifier:@"DBArticleReportVC" withStoryboardName:@"DBArticle"];
                if (reportVC) {
                    [weakSelf.navigationController pushViewController:reportVC animated:YES];
                }
            }];
        }
    };
    
    _coverView.coverFinishBlock = ^ {
        [weakSelf.colorView removeFromSuperview];
        [UIView animateWithDuration:0.5f animations:^{
            weakSelf.coverView.frame = CGRectMake(0.f, kScreenHeight - 340.0f, kScreenWidth, 340.0f);
        } completion:^(BOOL finished) {
            weakSelf.coverView.frame = CGRectMake(0.f, kScreenHeight, kScreenWidth, 340.0f);
            
        }];
    };
    
    //设置字体
    _coverView.coverFontSizeBlock = ^(NSInteger index) {
      //@[@"小", @"中", @"大", @"超大"]
        [[AppDelegate sharedDelegate] setArticleFontSizeWithIndex:index];
        DBFontSize fontSize = [AppDelegate sharedDelegate].fontSize;
        [_webView stringByEvaluatingJavaScriptFromString: [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%ld%%'",fontSize]];//修改百分比即可
    };
    
}

#pragma mark notification

- (void)addKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    keyboardHeight = keyboardRect.size.height;
    
    _commentView.frame = CGRectMake(0.f, kScreenHeight - keyboardHeight - 125.0f, kScreenWidth, 125.0f);
}


#pragma mark - data

- (void)initData {
    //评论 测试数据
    /*_commentList = [[NSMutableArray alloc] initWithCapacity:4];
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"交管部门真该管管了",
                             @"专车已经势不可挡了",
                             @"专车已经势不可挡了就是您本次获取到的Access Token值。在具体操作过程中，您将获得一个与示例中完全不同的，与您的账号绑定的Access Token值，请您保存下来，做为后续操作的输入。",
                             @"当然铁哥不反对专车的社交属性，有人的地方自然就有社交需求，这是毋庸置疑的。但在陌生场合和陌生人之间，如果毫无防备进行社交其风险是相当大的，也是伤害用户体验的。据新华网的一份调查报告显示，61.8%的乘客认为专车司机过于话痨，影响乘客休息，不难发现，社交对于多数乘客并非是刚性需求。",nil];
    for (int i = 0; i < 4; i ++) {
        DBCommentModel *model = [DBCommentModel initCommentModelWithDictionay:nil];
        model.detail = [array objectAtIndex:i];
        model.likedCount = [NSString stringWithFormat:@"%ld",(long)i];
        [_commentList addObject:model];
    }
    commentCount = _commentList.count;
    //分类
    _typeList = @[@{@"相关新闻":@[@"爸妈出行，最让儿女牵挂",@"端午节送粽子活动开始了"]},
                  @{@"更多频道":@[@"北京市", @"CocoChina"]},
                  @{@"最新评论":_commentList}];*/

}

#pragma mark request

- (void)requestArticleDetail {
//    if (![[QJNetManger instance] isNetworkRunning]) {
//        [self showNetWorkFailToast];
//        return;
//    }
    [self showProgressHUD];
    QJHTTPClient *client = [QJHTTPClient defaultClient];
    [client getClientPath:kSiteArticleDetail parameters:@{keyArticleId:_articleInfo.article_id} //5515
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [self hideProgressHUD];
                      NSData *data = responseObject;
                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                      DLog(@"文章详情:%@",dic);
                      NSInteger code = [(NSNumber *)dic[keyRetCode] integerValue];
                      if (code == 200) {
                          _articleInfo = [DBArticleModel objectWithKeyValues:[dic objectSafeForKey:keyResult]];
                          [self loadHeadWebView];
                      }else {
                          [self showToastMessage:NETWORK_ERROR_MSG];
                      }
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          [self hideProgressHUD];
                          [self showToastMessage:error.description];
                  }];
}

/** 收藏 */
- (void)requestUserAddCollection {
    [self showProgressHUD];
    QJHTTPClient *client = [QJHTTPClient defaultClient];
    [client postClientPath:kUserAddCollection parameters:@{keyUserId:[DBUserModel getUserId],
                                                          keyArticleId:_articleInfo.article_id} //5515
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [self hideProgressHUD];
                      NSData *data = responseObject;
                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                      DLog(@"收藏:%@",dic);
                      NSInteger code = [(NSNumber *)dic[keyRetCode] integerValue];
                      if (code == 200) {
                          [self showToastMessage:@"收藏成功"];
                          _isCollected = YES;
                      }else {
                          [self showToastMessage:NETWORK_ERROR_MSG];
                      }
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [self hideProgressHUD];
                      DLog(@"%@",error.description);
                      [self showToastMessage:@"收藏失败"];
                  }];

}
/** 取消收藏 */
- (void)requestUserCancelCollection {
    [self showProgressHUD];
    QJHTTPClient *client = [QJHTTPClient defaultClient];
    [client postClientPath:kUserCancelCollection parameters:@{keyUserId:[DBUserModel getUserId],
                                                             keyArticleId:_articleInfo.article_id} //5515
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [self hideProgressHUD];
                      NSData *data = responseObject;
                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                      DLog(@"取消收藏:%@",dic);
                      NSInteger code = [(NSNumber *)dic[keyRetCode] integerValue];
                      if (code == 200) {
                          [self showToastMessage:@"取消收藏"];
                          _isCollected = NO;
                      }else {
                          [self showToastMessage:@"网络不畅，请稍后重试"];
                      }
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [self hideProgressHUD];
                      DLog(@"%@",error.description);
                      [self showToastMessage:@"取消收藏失败"];
                  }];
}

//提交评论
- (void)requestComment:(NSString *)commentStr {
    [self showProgressHUD];
    QJHTTPClient *client = [QJHTTPClient defaultClient];
    [client postClientPath:kSitComment parameters:@{keyUserId:[DBUserModel getUserId],
                                                keyArticleId:_articleInfo.article_id,
                                          @"comment_message":commentStr} //5515
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [self hideProgressHUD];
                      NSData *data = responseObject;
                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                      DLog(@"提交评论:%@",dic);
                      NSInteger code = [(NSNumber *)dic[keyRetCode] integerValue];
                      if (code == 200) {
                          [self showToastMessage:@"评论成功"];
                          [self requestCommentList];
                      }else {
                          [self showToastMessage:NETWORK_ERROR_MSG];
                      }
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [self hideProgressHUD];
                      DLog(@"%@",error.description);
                      [self showToastMessage:@"评论失败"];
                  }];
}

/** 评论列表 */
- (void)requestCommentList {
    if (![[QJNetManger instance] isNetworkRunning]) {
        [self showNetWorkFailToast];
        return;
    }
    QJHTTPClient *client = [QJHTTPClient defaultClient];
    [client getClientPath:kSiteCommentList parameters:@{@"article_id":_articleInfo.article_id,
                                                        keyLimit:@(1000),
                                                        keyOffset:@(0)}
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      NSData *data = responseObject;
                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                      DLog(@"评论列表%@",dic);
                      NSInteger code = [(NSNumber *)dic[keyRetCode] integerValue];
                      if (code == 200) {
                          NSArray *array = [DBCommentModel objectArrayWithKeyValuesArray:[dic objectSafeForKey:keyResult][keyList]];
                          self.commentList = [NSMutableArray arrayWithArray:array];
                          commentCount = _commentList.count;
                          [_bottomView resetCommentCount:commentCount];
                      }else {
                          [self showToastMessage:NETWORK_ERROR_MSG];
                      }
                  }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      DLog(@"%@",error.description);
                  }];
}

#pragma mark - memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
