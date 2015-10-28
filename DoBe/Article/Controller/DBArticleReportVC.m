//
//  DBArticleReportVC.m
//  DoBe
//
//  Created by liuxuan on 15/6/4.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBArticleReportVC.h"
#import "QJHTTPClient.h"

@interface DBArticleReportVC ()<UITableViewDelegate, UITableViewDataSource> {
    NSArray  *_datalist;
    NSInteger _currentRow;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DBArticleReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"举报具体问题";
    [self showBackButton];
    [self showRightButtonWithBackgroundImage:[UIImage imageNamed:@"button_bg"] andTitle:@"发送"];
    
    _datalist = [NSArray arrayWithObjects:@"重复",@"过时", @"广告", @"低俗", nil];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [self setExtraCellLineHidden:_tableView];
    _currentRow = -1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBarButtonPressed:(id)sender {
    NSString *message = _datalist[_currentRow];
    [self requestUserFeedback:message];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datalist.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"DBArticleReportCellID";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger row = indexPath.row;
    [cell.textLabel setFont:[UIFont systemFontOfSize:15.0f]];
    if (row == 4) {
        [cell.textLabel setNumberOfLines:2];
        [cell.textLabel setText:@"上述内容仅对“豆比”工作人员课件，可帮助我们更快与您沟通并解决问题。"];
    }else {
        if (row == _currentRow) {
            cell.imageView.image = [UIImage imageNamed:@"article_circle_selected"];
        }else {
            cell.imageView.image = [UIImage imageNamed:@"article_circle"];
        }
        [cell.textLabel setText:[_datalist objectAtIndexSafe:row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 4) {
        NSLog(@"%@",[_datalist objectAtIndex:indexPath.row]);
        _currentRow = indexPath.row;
        [tableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        return 60.0f;
    }
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
 
    return nil;
    /*
    UILabel *label = [[UILabel alloc] init];
    label.text = @"上述内容仅对“豆比”工作人员课件，可帮助我们更快与您沟通并解决问题。";
    label.numberOfLines = 2;
    [label setFont:kNormalFont];
    return label;*/
}

#pragma mark - 设置分隔线

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //分隔线顶头显示 或设置两侧的间距
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15.0f, 0, 0)];
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

/*
//If all fails, you may brute-force your Table View margins:
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Force your tableview margins (this may be a bad idea)
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}*/


- (void)requestUserFeedback:(NSString *)message {
    
    [self showProgressHUD];
    QJHTTPClient *client = [QJHTTPClient defaultClient];
    [client getClientPath:kUserFeedback parameters:@{keyUserId:@"1",
                                                     @"message":message} //5515
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [self hideProgressHUD];
                      NSData *data = responseObject;
                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                      DLog(@"反馈意见:%@",dic);
                      NSInteger code = [(NSNumber *)dic[keyRetCode] integerValue];
                      if (code == 200) {
                          [self showToastMessage:@"提交成功"];
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
