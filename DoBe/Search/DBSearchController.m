//
//  DBSearchController.m
//  DoBe
//
//  Created by liuxuan on 15/6/3.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBSearchController.h"
#import "QJHTTPClient.h"
#import <MJExtension.h>
#import "DBNormalCell.h"
#import "DBArticleModel.h"
#import "DBArticleDetailVC.h"

@interface DBSearchController ()<UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate> {
    
    NSArray *_dataList;
    NSArray *_filterData;
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UISearchBar *_searchBar;
}

@end

@implementation DBSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackButton];
    [self requestSearchList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _tableView) {
        return _dataList.count;
    }else {
        // 谓词搜索
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",_searchBar.text];
//        _filterData =  [[NSArray alloc] initWithArray:[_filterData filteredArrayUsingPredicate:predicate]];
        return _filterData.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if (tableView == _tableView) {
        DBNormalCell *norcell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!norcell) {
            norcell = [[NSBundle mainBundle] loadNibNamed:@"DBNormalCell" owner:self options:nil][0];
        }
        DBArticleModel *model = _dataList[row];
        [norcell setCellData:model];
        return norcell;
    }else {
        cell.textLabel.text = [_filterData objectAtIndexSafe:row][keyTitle];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView ==  _tableView) {
        return 105.f;
    }else {
        return 44.f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (tableView != _tableView) {
        _searchBar.text = [_filterData objectAtIndexSafe:row][keyTitle];
        [self requestSearchArticle:_searchBar.text];
        return;
    }
    //TODO: 点击文章详情
    DBArticleDetailVC *detailVC = (DBArticleDetailVC *)[self instantiateViewControllerWithIdentifier:@"DBArticleDetailVC" withStoryboardName:@"DBArticle"];
    detailVC.articleInfo = [_dataList objectAtIndexSafe:row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark UISearchBarDelegate

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    DLog(@"%@",searchBar.text);
    if ([QJTools isBlankObject:searchBar.text]) {
        [self requestSearchArticle:@"d"];
    }else {
        [self requestSearchArticle:searchBar.text];
    }
}

#pragma mark UISearchDisplayDelegate

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
    DLog(@"searchDisplayControllerDidBeginSearch");
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    DLog(@"searchDisplayControllerDidEndSearch");
}

#pragma mark - request
/** 搜索文章 */
- (void)requestSearchArticle:(NSString *)title {
    [self showProgressHUD];
    QJHTTPClient *client = [QJHTTPClient defaultClient];
    [client getClientPath:kSiteSearchArticle parameters:@{keyUserId:@"1",
                                                          keyTitle:title} //5515
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [self hideProgressHUD];
                      NSData *data = responseObject;
                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                      DLog(@"搜索文章:%@",dic);
                      NSInteger code = [(NSNumber *)dic[keyRetCode] integerValue];
                      if (code == 200) {
                          NSArray *array = [dic objectSafeForKey:keyResult][keyList];
                         _dataList = [DBArticleModel objectArrayWithKeyValuesArray:array];
                          [_tableView reloadData];
                      }else {
                          [self showToastMessage:NETWORK_ERROR_MSG];
                      }
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [self hideProgressHUD];
                      DLog(@"%@",error.description);
                  }];
    
    /*result =     {
        count = 1;
        lists =         (
                         {
                             "article_id" = 5554;
                             "category_id" = 2;
                             "create_time" = 1440643467;
                             "get_time" = 1440432000;
                             "short_content" = "\U00b7\U70b9\U51fb\U5173\U6ce8\U60a6\U8bfb.\U4e3a\U6709\U601d\U8003\U7684\U9605\U8bfb.\U4f5c\U8005|\U6797\U590f\U8428\U6469 \U914d\U56fe|\U63d2\U753b\U5927\U5e08Rene Gruau1.\U5c0f\U82b1\U751f\U65e5\U90a3\U5929\U7ec4...";
                             tags = "<null>";
                             thum =                 (
                                                     "http://api.dobe.mobi/assets/thums/144133333331577.png",
                                                     "http://api.dobe.mobi/assets/thums/144133333379078.jpeg",
                                                     "http://api.dobe.mobi/assets/thums/144133333329375.jpeg",
                                                     "http://api.dobe.mobi/assets/thums/144133333412675.jpeg"
                                                     );
                             title = "\U4f60\U4e0d\U9700\U8981\U90a3\U4e48\U591a\U7684Hello Friend";
                             "wx_id" = 30;
                         }
                         );
    };
    "ret_code" = 200;
    "ret_msg" = ok;
}*/


}

/** 搜索记录 */
- (void)requestSearchList {
    [self showProgressHUD];
    QJHTTPClient *client = [QJHTTPClient defaultClient];
    [client getClientPath:kSiteSearchlist parameters:@{keyUserId:@"1",
                                                        keyOffset:@(1),
                                                        keyLimit:@(kDBLimitPerPage)} //5515
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       [self hideProgressHUD];
                       NSData *data = responseObject;
                       NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                       DLog(@"搜索列表:%@",dic);
                       NSInteger code = [(NSNumber *)dic[keyRetCode] integerValue];
                       if (code == 200) {
                           /*
                           "search_id": 2,
                           "title": '123',
                           "create_time": 1440326036*/
                           _filterData = dic[keyResult][keyList];
                           if (_filterData.count == 0 || !_filterData) {
                               _filterData = @[@"文艺青年",@"豆比青年",@"军事演习"];
                           }
                       }else {
                           [self showToastMessage:NETWORK_ERROR_MSG];
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
