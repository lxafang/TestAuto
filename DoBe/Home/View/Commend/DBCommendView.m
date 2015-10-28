//
//  DBCommendView.m
//  DoBe
//
//  Created by liuxuan on 15/6/4.
//  Copyright (c) 2015年 liuxuan. All rights reserved.
//

#import "DBCommendView.h"
#import "DBNormalCell.h"
#import "DBMultiImageCell.h"
#import "DBArticleModel.h"
#import "SRRefreshView.h"
#import "MJRefresh.h"

@interface DBCommendView ()<SRRefreshDelegate>

@end

@implementation DBCommendView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _offset = 0;
        [self loadSubView];
    }
    return self;
}

- (void)loadSubView {
    _tableView = [[UITableView alloc] initWithFrame:self.bounds];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self addSubview:_tableView];
    
    //阅读精品 分享人生
    
    [_tableView addFooterWithTarget:self action:@selector(requestMoreData)];
    [_tableView addHeaderWithTarget:self action:@selector(reloadData)];
    
    _refreshView = [[SRRefreshView alloc] init];
    _refreshView.delegate = self;
    _refreshView.upInset = 0;
    _refreshView.slimeMissWhenGoingBack = YES;
    _refreshView.slime.bodyColor = [UIColor lightGrayColor];
    _refreshView.slime.skinColor = UIColorFromRGB(0xefeff4);
    _refreshView.slime.lineWith = 1;
    _refreshView.slime.shadowBlur = 4;
    _refreshView.slime.shadowColor = [UIColor blackColor];
    [_tableView addSubview:_refreshView];
}

#pragma mark - setter

- (void)setCategoryName:(NSString *)categoryName {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(endFooterNotification:)
                                                 name:[NSString stringWithFormat:@"%@_%@",kNotificationEndFooter,categoryName] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(endHeaderNotification:)
                                                 name:[NSString stringWithFormat:@"%@_%@",kNotificationEndHeader,categoryName] object:nil];

}

/** 未用 */
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshHeaderNotification:)
                                                 name:kNotificationRefreshHeader object:nil];

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _articleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    UITableViewCell *cell = nil;
    /** 判断单图多图 */
    DBArticleModel *model = _articleList[row];
    if (model.thum.count > 0 && model.thum.count < 3) {
        static NSString *cellID = @"NormalCellID";
        //单图
        DBNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"DBNormalCell" owner:self options:nil][0];
        }
        [cell setCellData:model];
        return cell;
    }else if (model.thum.count >= 3) {
        static NSString *cellid = @"multiImgCellID";
        DBMultiImageCell *imgCell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!imgCell) {
            imgCell = [[NSBundle mainBundle] loadNibNamed:@"DBMultiImageCell" owner:self options:nil][0];
        }
        [imgCell setCellInfoWithModel:model];
        return imgCell;
    }
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    DBArticleModel *model = _articleList[row];
    if (model.thum.count > 0 && model.thum.count < 3) {
        return 105.0f;
    }
    return 150.f;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_didSelectRowBlock) {
        _didSelectRowBlock(indexPath.row);
    }
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

//处理分割线
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

#pragma mark SRRefreshViewDelegate

- (void)slimeRefreshStartRefresh:(SRRefreshView*)refreshView {
    
}

#pragma mark event

- (void)reloadData {
    if (_reloadDataBlock) {
        _reloadDataBlock();
    }
}

- (void)requestMoreData {
    if (_requestMoreBlock) {
        _offset = _offset + kDBLimitPerPage;
        _requestMoreBlock(_offset);
    }
}

#pragma mark notification

- (void)endFooterNotification:(NSNotification *)noti {
    if (_tableView.footerRefreshing) {
        [_tableView footerEndRefreshing];
    }
    if ([noti.object isKindOfClass:[NSArray class]]) {
        self.articleList = noti.object;
        [_tableView reloadData];
    }
}

- (void)endHeaderNotification:(NSNotification *)noti {
    if (_tableView.headerRefreshing) {
        [_tableView headerEndRefreshing];
    }
    if ([noti.object isKindOfClass:[NSArray class]]) {
        self.articleList = noti.object;
        [_tableView reloadData];
    }
}

- (void)refreshHeaderNotification:(NSNotification *)noti {
    [_tableView headerBeginRefreshing];
    if ([noti.object isKindOfClass:[NSArray class]]) {
        self.articleList = noti.object;
        [_tableView reloadData];
    }else {
        [_tableView reloadData];
    }
    [_tableView headerEndRefreshing];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
