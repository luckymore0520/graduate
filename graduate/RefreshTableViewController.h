//
//  RefreshTableViewController.h
//  MallTemplate
//
//  Created by Stephen Zhuang on 14-4-8.
//  Copyright (c) 2014年 udows. All rights reserved.
//

#import "MJRefresh.h"
#import "BaseFuncVC.h"
//#import "FootView.h"
@interface RefreshTableViewController : BaseFuncVC<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    @protected
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
//    FootView *_footer;
    int page;
    NSInteger pageCount;
    BOOL hasMore;
    BOOL isLoading;
}
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *dataArray;
- (void)doneWithView:(MJRefreshBaseView *)refreshView;
- (void)addHeader;
- (void)addFooter;
- (void)loadData;
@end
