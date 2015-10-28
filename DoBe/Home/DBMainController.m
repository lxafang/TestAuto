//
//  DBMainController.m
//  BYDailyNews
//
//  Created by bassamyan on 15/1/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "DBMainController.h"
#import "BYListBar.h"
#import "BYArrow.h"
#import "BYDetailsList.h"
#import "BYDeleteBar.h"
#import "BYScroller.h"

#import "DBMyController.h"
#import "DBSearchController.h"
#import "DBArticleDetailVC.h"
#import "WXController.h"
#import "DBLoginController.h"

#import "DBCommendView.h"
#import "DBArticleModel.h"

#import "QJHTTPClient.h"
#import <MJExtension.h>

#define kListBarH 30
#define kArrowW 40
#define kAnimationTime 0.8

@interface DBMainController () <UIScrollViewDelegate> {
    
    BOOL _isHeaderReresh;
    BOOL _isFooterReresh;
    NSUInteger _offset;         /**< 请求页数，由各个commendView保存、更改 */
}

@property (nonatomic,strong) BYListBar *listBar;

@property (nonatomic,strong) BYDeleteBar *deleteBar;

@property (nonatomic,strong) BYDetailsList *detailsList;

@property (nonatomic,strong) BYArrow *arrow;

@property (nonatomic,strong) UIScrollView *mainScroller;

@property (nonatomic, strong) DBCommendView *currCommendView;

/** 文章数据 */
@property (nonatomic, strong) NSMutableArray *categoryList; /**< 分类列表 */
//@property (nonatomic, strong) NSMutableArray *articleList;  /**< @[{@"分类名称": [artivleModel]} ] */
@property (nonatomic, strong) NSMutableDictionary *articleListDic;  /**< {@"分类名称": [artivleModel],@""} */
@property (nonatomic, strong) NSMutableDictionary *listViewDic;     /**< {@"分类名称": [DBCommendView],@""} */

@end

@implementation DBMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"豆比";
    if (IOS7) {
        //self.edgesForExtendedLayout = UIRectEdgeNone;
        //self.extendedLayoutIncludesOpaqueBars = NO; //不透明的操作栏
        //self.modalPresentationCapturesStatusBarAppearance = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;//ios7 导航控制器切换影响UIScrollView布局的问题
    }
    //self.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self showBackButtonWithImage:@"home-my"];
    [self showRightButtonWithImage:[UIImage imageNamed:@"icon_search"] andHigImage:nil];
    
    if (!_loadedSortList) {
        _loadedSortList = [[NSMutableArray alloc] init];
    }
//    if (!_articleList) {
//        _articleList = [[NSMutableArray alloc] init];
//    }
    
    _articleListDic = [[NSMutableDictionary alloc] init];
    _listViewDic = [[NSMutableDictionary alloc] init];
    
    self.currentIndex = 0;
    self.currentItem = @"推荐";
    _offset = 0;
    
    [self requestSiteCategoryList];
    
    _wxVC = [[WXController alloc] init];
    _loginVC = [[DBLoginController alloc] init];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

-(void)makeContent {
    /*
    "category_id" = 16;
    "category_name" = "\U4e50\U6d3b";

    NSMutableArray *listTop = [[NSMutableArray alloc] initWithArray:@[@"推荐",@"热点",@"杭州",@"社会",@"娱乐",@"科技",@"汽车",@"体育",@"订阅",@"财经",@"军事",@"国际",@"正能量",@"段子",@"趣图",@"美女",@"健康",@"教育",@"特卖",@"彩票",@"辟谣"]];*/
    NSMutableArray *listTop = [[NSMutableArray alloc] init];
    NSMutableArray *listBottom = [[NSMutableArray alloc] init];
    
    NSInteger count = _categoryList.count;
    
    for (int i = 0; i < count; i++) {
        NSDictionary *dic = _categoryList[i];
        if (i < count - 4) {
            [listTop addObject:dic[@"category_name"]];
        }else {
            [listBottom addObject:dic[@"category_name"]];
        }
    }
    [listTop insertObject:@"推荐" atIndex:0];
    
    /*
    for (NSDictionary *dic in _categoryList) {
        [listTop addObject:dic[@"category_name"]];
    }
    NSMutableArray *listBottom = [[NSMutableArray alloc] initWithArray:@[@"电影",@"数码",@"时尚",@"奇葩",@"游戏",@"旅游",@"育儿",@"减肥",@"养生",@"美食",@"政务",@"历史",@"探索",@"故事",@"美文",@"情感",@"语录",@"美图",@"房产",@"家居",@"搞笑",@"星座",@"文化",@"毕业生",@"视频"]];*/
    
    __weak typeof(self) unself = self;
    
    if (!self.detailsList) {
        self.detailsList = [[BYDetailsList alloc] initWithFrame:CGRectMake(0, -(kScreenH-kListBarH), kScreenW, kScreenH-kListBarH)];
        self.detailsList.listAll = [NSMutableArray arrayWithObjects:listTop,listBottom, nil];
        
        self.detailsList.longPressedBlock = ^(){
            [unself.deleteBar sortBtnClick:unself.deleteBar.sortBtn];
        };
        
        self.detailsList.opertionFromItemBlock = ^(animateType type, NSString *itemName, int index){
            [unself.listBar operationFromBlock:type itemName:itemName index:index];
        };
        [self.view addSubview:self.detailsList];
    }
    
    if (!self.listBar) {
        self.listBar = [[BYListBar alloc] initWithFrame:CGRectMake(0, 64.0f, kScreenW, kListBarH)];
        self.listBar.visibleItemList = listTop;
        self.listBar.arrowChange = ^(){
            if (unself.arrow.arrowBtnClick) {
                unself.arrow.arrowBtnClick();
            }
        };
        self.listBar.listBarItemClickBlock = ^(NSString *itemName , NSInteger itemIndex){
            //顶部显示button
            [unself.detailsList itemRespondFromListBarClickWithItemName:itemName];
            DLog(@"====选择%@ 第%ld",itemName,itemIndex);
            unself.currentItem = itemName;
            unself.currentIndex = itemIndex;
            [unself addScrollViewWithItemName:itemName index:itemIndex];
            //移动到该位置
            unself.mainScroller.contentOffset = CGPointMake(itemIndex * unself.mainScroller.frame.size.width,0);
            
        };
        [self.view addSubview:self.listBar];
    }
    
    if (!self.deleteBar) {
        self.deleteBar = [[BYDeleteBar alloc] initWithFrame:self.listBar.frame];
        [self.view addSubview:self.deleteBar];
    }
    
    if (!self.arrow) {
        self.arrow = [[BYArrow alloc] initWithFrame:CGRectMake(kScreenW-kArrowW, 64.0f, kArrowW, kListBarH)];
        self.arrow.arrowBtnClick = ^(){
            unself.deleteBar.hidden = !unself.deleteBar.hidden;
            [UIView animateWithDuration:kAnimationTime animations:^{
                CGAffineTransform rotation = unself.arrow.imageView.transform;
                unself.arrow.imageView.transform = CGAffineTransformRotate(rotation,M_PI);
                unself.detailsList.transform = (unself.detailsList.frame.origin.y<0)?CGAffineTransformMakeTranslation(0, kScreenH + 64.0f):CGAffineTransformMakeTranslation(0, -kScreenH - 64.0f);
            }];
        };
        [self.view addSubview:self.arrow];
    }
    
    if (!self.mainScroller) {
        self.mainScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kListBarH + 64.0f, kScreenW, kScreenH-kListBarH-64)];
        self.mainScroller.bounces = NO;
        self.mainScroller.pagingEnabled = YES;
        self.mainScroller.showsHorizontalScrollIndicator = NO;
        self.mainScroller.showsVerticalScrollIndicator = NO;
        self.mainScroller.delegate = self;
        [self.view insertSubview:self.mainScroller atIndex:0];
        self.mainScroller.contentSize = CGSizeMake(kScreenW * listTop.count,_mainScroller.height);
        [self addScrollViewWithItemName:_currentItem index:_currentIndex];
    }
}

-(void)addScrollViewWithItemName:(NSString *)itemName index:(NSInteger)index{
    BOOL loadedFlag = NO;
    //判断是否已加载过
    if (_loadedSortList.count > 0) {
        for (NSString *item in _loadedSortList) {
            if ([item isEqualToString:itemName]) {
                loadedFlag = YES;
                break;
            }
        }
    }
    if (!loadedFlag) {
        
        /*!
         * 未加载过 根据分类名称请求数据 @lxa
         */
        
        [_loadedSortList addObject:itemName];
        
        CGFloat width = _mainScroller.width;
        CGFloat height = _mainScroller.height;
        CGRect iFrame = CGRectMake(index *width, 0.f, width, height);

        //判断分类名称
        if ([itemName isEqualToString:@"推荐"] /*|| [itemName isEqualToString:@"热点"]*/) {
            
            DBCommendView *commendView = [[DBCommendView alloc] initWithFrame:iFrame];
            _currCommendView = commendView;
            ///_currCommendView.articleList = _articleList[0][@"推荐"];
            _currCommendView.articleList = [_articleListDic objectSafeForKey:@"推荐"];
            commendView.categoryName = _currentItem;
            [_mainScroller addSubview:commendView];
            _listViewDic[_currentItem] = commendView;
            [commendView.tableView reloadData];
            
            commendView.didSelectRowBlock = ^(NSInteger row){
                //TODO: 点击文章详情
                DLog(@"点击文章详情");
                ///NSArray *array = _articleList[0][_currentItem];
                NSArray *array = [_articleListDic objectSafeForKey:_currentItem];
                DBArticleDetailVC *detailVC = (DBArticleDetailVC *)[self instantiateViewControllerWithIdentifier:@"DBArticleDetailVC"
                                         withStoryboardName:@"DBArticle"];
                detailVC.articleInfo = [array objectAtIndexSafe:row];
                [self.navigationController pushViewController:detailVC animated:YES];
            };
            
            commendView.reloadDataBlock = ^{
                DLog(@"刷新数据");
                _isHeaderReresh = YES;
                _offset = 0;
                [self requestSiteRecommendArticleList];
            };
            
            commendView.requestMoreBlock = ^(NSUInteger offset){
                DLog(@"加载更多");
                _isFooterReresh = YES;
                _offset = offset;
                [self requestSiteRecommendArticleList];
            };
        }else {
            if (!_isFooterReresh && !_isHeaderReresh) {
                _offset = 0;
            }
            [self requestSiteCategoryArticleList];
            /*
            UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(index * width, 0.0f, width, height)];
            scroller.backgroundColor = RGBColor(arc4random()%255, arc4random()%255, arc4random()%255);
            [_mainScroller addSubview:scroller];*/
        }
    }else {
        /*!
         * 加载过 从articleList加载数据 @lxa
         */
        
    }
}

#pragma mark - custom

/** 根据频道id 获取文章列表 */
- (void)getCurrentCategoryArticleList {
    
}

- (void)loadCategoryArticleList {
    CGFloat width = _mainScroller.width;
    CGFloat height = _mainScroller.height;
    CGRect iFrame = CGRectMake(_currentIndex *width, 0.f, width, height);
    DBCommendView *commendView = [[DBCommendView alloc] initWithFrame:iFrame];
    commendView.categoryName = _currentItem;
    ///commendView.articleList = [[_articleList objectAtIndexSafe:_currentIndex] objectForKey:_currentItem];
    commendView.articleList = [_articleListDic objectSafeForKey:_currentItem];
    [_mainScroller addSubview:commendView];
    _listViewDic[_currentItem] = commendView;
    [commendView.tableView reloadData];
    /** 选择文章 */
    commendView.didSelectRowBlock = ^(NSInteger row) {
        
        ///NSArray *array = _articleList[_currentIndex][_currentItem];
        NSArray *array = [_articleListDic objectSafeForKey:_currentItem];
        DBArticleDetailVC *detailVC = (DBArticleDetailVC *)[self instantiateViewControllerWithIdentifier:@"DBArticleDetailVC"
                                 withStoryboardName:@"DBArticle"];
        detailVC.articleInfo = [array objectAtIndexSafe:row];
        [self.navigationController pushViewController:detailVC animated:YES];

    };
    commendView.reloadDataBlock = ^{
        DLog(@"刷新数据");
        _isHeaderReresh = YES;
        _offset = 0;
        [self requestSiteCategoryArticleList];
    };
    
    commendView.requestMoreBlock = ^(NSUInteger offset){
        DLog(@"加载更多");
        _isFooterReresh = YES;
        _offset = offset;
        [self requestSiteCategoryArticleList];
    };
}

#pragma mark - request

/** 获取推荐频道文章列表 */
- (void)requestSiteRecommendArticleList {
    [self.mainScroller showProgressHUD];
    QJHTTPClient *client = [QJHTTPClient defaultClient];
    [client getClientPath:kSiteRecommend parameters:@{keyUserId:[DBUserModel getUserId],
                                                      keyLimit:@(kDBLimitPerPage),
                                                      keyOffset:@(_offset)}
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      
                      [self.mainScroller hideProgressHUD];
                      
                      NSData *data = responseObject;
                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                      DLog(@"推荐文章列表:%@",dic);
                      NSInteger code = [(NSNumber *)dic[keyRetCode] integerValue];
                      NSString *msg = [dic stringSafeForKey:keyRetMsg];
                      if (code == 200) {
                          NSArray *array = [dic objectSafeForKey:@"result"][@"lists"];
                          NSArray *modelArr = [DBArticleModel objectArrayWithKeyValuesArray:array];
                          if (!_isHeaderReresh) {
                              if (_isFooterReresh) {
                                  if (modelArr.count == 0) {
                                      [self showToastMessage:@"没有更多内容了"];
                                      [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@_%@",kNotificationEndFooter,_currentItem] object:nil];
                                  }else {
                                      NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:[_articleListDic objectSafeForKey:_currentItem]];
                                      [mutableArr addObjectsFromArray:modelArr];
                                      [_articleListDic setObject:mutableArr forKey:_currentItem];
                                      [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@_%@",kNotificationEndFooter,_currentItem] object:mutableArr];
                                  }
                                  _isFooterReresh = NO;
                              }else {
                                  [_articleListDic setObject:modelArr forKey:_currentItem];
                                  [self makeContent];
                              }
                          }else {
                              [_articleListDic setObject:modelArr forKey:_currentItem];
                              _isHeaderReresh = NO;
                              [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@_%@",kNotificationEndHeader,_currentItem] object:modelArr];
                          }
                          
                      }else {
                          [self showToastMessage:msg];
                          [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@_%@",kNotificationEndHeader,_currentItem] object:nil];
                          [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@_%@",kNotificationEndFooter,_currentItem] object:nil];
                      }
                      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.mainScroller hideProgressHUD];
        DLog(@"%@",error.description);
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@_%@",kNotificationEndHeader,_currentItem] object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@_%@",[NSString stringWithFormat:@"%@_%@",kNotificationEndFooter,_currentItem],_currentItem] object:nil];
        [self showToastMessage:NETWORK_ERROR_MSG];
    }];
}
/** 获取频道文章列表 */
- (void)requestSiteCategoryArticleList {
    [self.mainScroller showProgressHUD];
    QJHTTPClient *client = [QJHTTPClient defaultClient];
    [client getClientPath:kSiteArticlelist parameters:@{keyCategoryId:@(_currentIndex),
                                                        keyUserId:[DBUserModel getUserId],
                                                        keyLimit:@(kDBLimitPerPage),
                                                        keyOffset:@(_offset)}
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [self.mainScroller hideProgressHUD];
                      NSData *data = responseObject;
                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                      DLog(@"频道文章列表:%@",dic);
                      NSInteger code = [(NSNumber *)dic[keyRetCode] integerValue];
                      NSString *retMsg = [dic stringSafeForKey:keyRetMsg];
                      if (code == 200) {
                          NSArray *array = [dic objectSafeForKey:keyResult][@"lists"];
                          NSArray *modelArr = [DBArticleModel objectArrayWithKeyValuesArray:array];
                          ///[_articleList addObject:@{_currentItem:modelArr}];
                          
                          if (_isHeaderReresh) {
                              _isHeaderReresh = NO;
                              [_articleListDic setObject:modelArr forKey:_currentItem];
                              [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@_%@",kNotificationEndHeader,_currentItem] object:modelArr];
                          }else {
                              if (!_isFooterReresh) {
                                  [_articleListDic setObject:modelArr forKey:_currentItem];
                                  if (modelArr.count == 0) {
                                      [self showToastMessage:@"暂无内容"];
                                  }else {
                                      [self loadCategoryArticleList];
                                  }
                              }else {
                                  _isFooterReresh = NO;
                                  if (modelArr.count == 0) {
                                      [self showToastMessage:@"没有更多内容了"];
                                      [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@_%@",kNotificationEndFooter,_currentItem] object:nil];
                                  }else {
                                      NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:[_articleListDic objectSafeForKey:_currentItem]];
                                      [mutableArr addObjectsFromArray:modelArr];
                                      _articleListDic[_currentItem] = mutableArr;
                                      [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@_%@",kNotificationEndFooter,_currentItem] object:mutableArr];
                                  }
                              }
                          }
                      }else {
                          [self showToastMessage:retMsg];
                          [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@_%@",kNotificationEndHeader,_currentItem] object:nil];
                          [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@_%@",kNotificationEndFooter,_currentItem] object:nil];
                      }
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [self.mainScroller hideProgressHUD];
                      DLog(@"%@",error.description);
                      [self showToastMessage:NETWORK_ERROR_MSG];
                      [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@_%@",kNotificationEndHeader,_currentItem] object:nil];
                      [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@_%@",kNotificationEndFooter,_currentItem] object:nil];
                  }];

}

/** 获取分类列表 */
- (void)requestSiteCategoryList {
    [self showProgressHUD];
    
    QJHTTPClient *client = [QJHTTPClient defaultClient];
    [client getClientPath:kSiteCategotyList parameters:nil
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      
                      [self hideProgressHUD];
                      
                      NSData *data = responseObject;
                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                      DLog(@"分类列表:%@",dic);
                      NSInteger code = [(NSNumber *)dic[@"ret_code"] integerValue];
                      NSString *ret_msg = dic[keyRetMsg];
                      if (code == 200) {
                          NSArray *array = [dic objectSafeForKey:@"result"][@"lists"];
                          self.categoryList = [NSMutableArray arrayWithArray:array];
                          [self requestSiteRecommendArticleList];
                      }else {
                          [self showToastMessage:ret_msg];
                      }
                      
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [self hideProgressHUD];
                      DLog(@"%@",error.description);
                      [self showToastMessage:NETWORK_ERROR_MSG];
                  }];
}

/** 是否对文章表态 */
- (void)requestSiteIsStand {
    QJHTTPClient *client = [QJHTTPClient defaultClient];
    [client getClientPath:kSiteIsStand parameters:@{keyUserId:[DBUserModel getUserId]/*,
                                                    keyArticleId:_articleInfo.article_id*/}
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      
                      NSData *data = responseObject;
                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                      DLog(@"是否对文章表态:%@",dic);
                      NSInteger code = [(NSNumber *)dic[keyRetCode] integerValue];
                      NSString *ret_msg = dic[keyRetMsg];
                      if (code == 200) {
                          
                      }else {
                          [self showToastMessage:ret_msg];
                      }
                      
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      DLog(@"%@",error.description);
                      [self showToastMessage:NETWORK_ERROR_MSG];
                  }];
}

/** 对文章表态 */
- (void)requestSitePraise:(DBStandType)standType {
    QJHTTPClient *client = [QJHTTPClient defaultClient];
    [client getClientPath:kSitePraise parameters:@{keyUserId:[DBUserModel getUserId],
                                                   @"praise":@(standType)/*,
                                                   keyArticleId:_articleInfo.article_id*/}
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      
                      NSData *data = responseObject;
                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                      DLog(@"对文章表态:%@",dic);
                      NSInteger code = [(NSNumber *)dic[keyRetCode] integerValue];
                      NSString *ret_msg = dic[keyRetMsg];
                      [self showToastMessage:ret_msg];
                      if (code == 200) {
                          
                      }else {
                          [self showToastMessage:ret_msg];
                      }
                      
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      DLog(@"%@",error.description);
                      [self showToastMessage:NETWORK_ERROR_MSG];
                  }];
}

#pragma mark - event

- (void)backBarButtonPressed:(id)sender {
    //my
    UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"My"
                                                            bundle:nil];
    DBMyController *myVC = [myStoryBoard instantiateViewControllerWithIdentifier:@"DBMyVC"];
    [self.navigationController pushViewController:myVC animated:YES];
}

- (void)rightBarButtonPressed:(id)sender {
    //search
    DBSearchController *searchVC = (DBSearchController *)[self instantiateViewControllerWithIdentifier:@"DBSearchController" withStoryboardName:@"Main"];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self.listBar itemClickByScrollerWithIndex:scrollView.contentOffset.x / self.mainScroller.frame.size.width];
}
@end
