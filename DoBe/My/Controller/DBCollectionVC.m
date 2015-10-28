//
//  DBCollectionVC.m
//  DoBe
//
//  Created by liuxu'an on 15/8/1.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBCollectionVC.h"
#import "QJHTTPClient.h"

@interface DBCollectionVC()<UITableViewDataSource, UITableViewDelegate>{
    NSArray *_dataList;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DBCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    [self showBackButton];
    [self requestUserCollectList];
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
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

/** 收藏列表 */
- (void)requestUserCollectList {
    [self showProgressHUD];
    
    QJHTTPClient *client = [QJHTTPClient defaultClient];
    [client getClientPath:kUserGetCollection parameters:@{keyUserId:[DBUserModel getUserId]}
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [self hideProgressHUD];
                      NSData *data = responseObject;
                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                      DLog(@"收藏列表：%@",dic);
                         
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      DLog(@"%@",error.description);
                      [self hideProgressHUD];
                  }];
}

@end
