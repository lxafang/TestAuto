//
//  DBSubscribeVC.m
//  DoBe
//
//  Created by liuxu'an on 15/9/9.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBSubscribeVC.h"
#import "DBSearchController.h"
#import "QJHTTPClient.h"
#import "DBSubsCell.h"
#import "DBArticleModel.h"
#import <MJExtension.h>

@interface DBSubscribeVC ()<UITableViewDataSource, UITableViewDelegate> {
    
    NSString *_selecCategoryId;
    NSString *_selectWXId;
}

@property (nonatomic, strong) NSArray *wxList;     /**< DBWXModel */
@property (nonatomic, strong) NSMutableArray *categoryList;  /**< @[@{},@{}] */
@property (nonatomic, strong) NSMutableArray *subscribeList;  /**< DBWXModel */
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

@property (nonatomic, strong) NSMutableDictionary *subscribeListDic; //@{@"分类名称":@[DBWXModel]}


@end

@implementation DBSubscribeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订阅豆比资讯";
    [self showBackButton];
    [self showRightButtonWithImage:[UIImage imageNamed:@"icon_search"] andHigImage:nil];
    
    _selecCategoryId = @"0";
    _subscribeList = [[NSMutableArray alloc] init];
    _subscribeListDic = [[NSMutableDictionary alloc] init];
    [self requestSiteCategoryList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBarButtonPressed:(id)sender {
    //去搜索页
    
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _leftTableView) {
        return _categoryList.count;
    }
    return _subscribeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    UITableViewCell *cell = nil;
    if (tableView == _leftTableView) {
        static NSString *cellID = @"leftCellID";
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        NSDictionary *itemDic = [_categoryList objectAtIndexSafe:row];
        cell.textLabel.text = [itemDic objectSafeForKey:keyCategoryName];
        cell.backgroundColor = RGB(234, 235, 236);
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        return cell;
    }else {
        static NSString *cellid = @"rightCellID";
        DBSubsCell *subsCell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!subsCell) {
            subsCell = [[NSBundle mainBundle] loadNibNamed:@"DBSubsCell" owner:self options:nil][0];
        }
        DBWXModel *model = [_subscribeList objectAtIndexSafe:row];
        [subsCell setCellInfoWithModel:model];
        subsCell.subscribeEventBlock = ^(BOOL isDone) {
            //取消/订阅
            _selectWXId = model.wx_id;
            if (isDone) {
                model.is_subscribe = NO;
                [self requestCancelSubcribe];
            }else {
                model.is_subscribe = YES;
                [self requestAddSubscribe];
            }
        };
        return subsCell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    if (tableView == _leftTableView) {
        NSDictionary *itemDic = [_categoryList objectAtIndexSafe:row];
        _selecCategoryId = [itemDic stringSafeForKey:keyCategoryId];
        [_subscribeList removeAllObjects];
        /** wxlist 根据分类id 筛选出对于的微信列表  subscribeList */
        for (DBWXModel *model in _wxList) {
            if ([_selecCategoryId isEqualToString:model.category_id]) {
                [_subscribeList addObject:model];
            }
        }
        [_rightTableView reloadData];
    }else {
        
    }
}

//处理分割线
-  (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _rightTableView) {
        return;
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
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

#pragma mark - data

/** 首个分类列表 */
- (void)handleSubscribeWXList {
    NSDictionary *itemDic = [_categoryList objectAtIndexSafe:0];
    _selecCategoryId = [itemDic stringSafeForKey:keyCategoryId];
    [_subscribeList removeAllObjects];
    /** wxlist 根据分类id 筛选出对于的微信列表  subscribeList */
    for (DBWXModel *model in _wxList) {
        if ([_selecCategoryId isEqualToString:model.category_id]) {
            [_subscribeList addObject:model];
        }
        _subscribeListDic[itemDic[keyCategoryName]] = _subscribeList;
    }
    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    [_rightTableView reloadData];
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
                      NSInteger code = [(NSNumber *)dic[keyRetCode] integerValue];
                      NSString *ret_msg = dic[keyRetMsg];
                      if (code == 200) {
                          NSArray *array = [dic objectSafeForKey:@"result"][@"lists"];
                          self.categoryList = [NSMutableArray arrayWithArray:array];
                          [_leftTableView reloadData];
                          [self requestWXList];
                      }else {
                          [self showToastMessage:ret_msg];
                      }
                      
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [self hideProgressHUD];
                      DLog(@"%@",error.description);
                      [self showToastMessage:NETWORK_ERROR_MSG];
                  }];
    
}

/** 获取用户订阅列表 */
- (void)requestSubscribeList {
    [self showProgressHUD];
    
    QJHTTPClient *client = [QJHTTPClient defaultClient];
    [client getClientPath:kUserGetSubscribe parameters:@{keyUserId:[DBUserModel getUserId],
                                                         keyCategoryId:_selecCategoryId}
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
                      [self hideProgressHUD];
                      
                      NSData *data = responseObject;
                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                      DLog(@"订阅列表:%@",dic);
                      NSInteger code = [(NSNumber *)dic[keyRetCode] integerValue];
                      NSString *ret_msg = dic[keyRetMsg];
                      if (code == 200) {
                          NSArray *array = [dic objectSafeForKey:@"result"][@"lists"];
                          self.subscribeList = [NSMutableArray arrayWithArray:array];
                          [_rightTableView reloadData];
                      }else {
                          [self showToastMessage:ret_msg];
                      }
                      
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [self hideProgressHUD];
                      DLog(@"%@",error.description);
                      [self showToastMessage:NETWORK_ERROR_MSG];
                  }];
}

/** 获取微信列表 */
- (void)requestWXList {
    [self showProgressHUD];
    
    QJHTTPClient *client = [QJHTTPClient defaultClient];
    [client getClientPath:kSiteWXList parameters:@{keyUserId:[DBUserModel getUserId]}
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      
                      [self hideProgressHUD];
                      
                      NSData *data = responseObject;
                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                      DLog(@"微信列表:%@",dic);
                      NSInteger code = [(NSNumber *)dic[keyRetCode] integerValue];
                      NSString *ret_msg = dic[keyRetMsg];
                      if (code == 200) {
                          NSArray *array = [dic objectSafeForKey:@"result"][@"lists"];
                          self.wxList = [DBWXModel objectArrayWithKeyValuesArray:array];
                          [self handleSubscribeWXList];
                      }else {
                          [self showToastMessage:ret_msg];
                      }
                      
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [self hideProgressHUD];
                      DLog(@"%@",error.description);
                      [self showToastMessage:NETWORK_ERROR_MSG];
                  }];
}

/** 获取添加订阅 */
- (void)requestAddSubscribe {
    [self showProgressHUD];
    
    QJHTTPClient *client = [QJHTTPClient defaultClient];
    [client postClientPath:kUserAddSubscribe parameters:@{keyUserId:[DBUserModel getUserId],
                                                         keyWXId:_selectWXId}
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      
                      [self hideProgressHUD];
                      
                      NSData *data = responseObject;
                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                      DLog(@"添加订阅:%@",dic);
                      NSInteger code = [(NSNumber *)dic[keyRetCode] integerValue];
                      NSString *ret_msg = dic[keyRetMsg];
                      if (code == 200) {
                          [_rightTableView reloadData];
                      }else {
                          [self showToastMessage:ret_msg];
                      }
                      
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [self hideProgressHUD];
                      DLog(@"%@",error.description);
                      [self showToastMessage:NETWORK_ERROR_MSG];
                  }];
}

/** 用户取消 */
- (void)requestCancelSubcribe {
    QJHTTPClient *client = [QJHTTPClient defaultClient];
    [client postClientPath:kUserCancelSubscribe parameters:@{keyUserId:[DBUserModel getUserId],
                                                          keyWXId:_selectWXId}
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       
                       [self hideProgressHUD];
                       NSData *data = responseObject;
                       NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                       DLog(@"取消订阅:%@",dic);
                       NSInteger code = [(NSNumber *)dic[keyRetCode] integerValue];
                       NSString *ret_msg = dic[keyRetMsg];
                       if (code == 200) {
                           [_rightTableView reloadData];
                       }else {
                           [self showToastMessage:ret_msg];
                       }
                       
                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       [self hideProgressHUD];
                       DLog(@"%@",error.description);
                       [self showToastMessage:NETWORK_ERROR_MSG];
                   }];
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
