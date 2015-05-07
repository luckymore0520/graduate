//
//  NewsListViewController.m
//  graduate
//
//  Created by TracyLin on 15/5/4.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "NewsListViewController.h"
#import "MNewsList.h"
#import "MNews.h"
#import "NewsListCell.h"
#import "MGetNewsList.h"
#import "EssenceDetailWebViewController.h"

@interface NewsListViewController()
@property (nonatomic,strong)NSMutableArray* newsArray;
@property (nonatomic,strong)UIView* sectionHeader;
@property (nonatomic)BOOL firstAppear;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation NewsListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _sectionHeader = [[UIView alloc] initWithFrame:CGRectZero];
    _firstAppear = YES;
    [self setTitle:@"新闻列表"];
    _newsArray = [[NSMutableArray alloc]init];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (_firstAppear) {
        _firstAppear = NO;
    }else{
        [self loadData];
    }
    //    [super viewDidAppear:animated];
    
}

- (void)loadData
{
    MGetNewsList* news = [[MGetNewsList alloc]init];
    news = (MGetNewsList*)[news setPage:page limit:pageCount];
    [news load:self type:1];
}


#pragma mark -backButtonItem


#pragma mark -APiDelegate
- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MIndexNews"]) {
        MNewsList* list = [MNewsList objectWithKeyValues:data];
        if (self.newsArray.count==0) {
            self.newsArray = list.news_;
        } else {
            for (MNews* post in list.news_) {
                BOOL has = NO;
                for (MNews* currentPost in self.newsArray) {
                    if ([post.id_ isEqualToString:currentPost.id_]) {
                        has = YES;
                        //                        currentPost.commentCount_ = post.commentCount_;
                        break;
                    }
                }
                if (!has) {
                    if (page==1) {
                        [self.newsArray insertObject:post atIndex:0];
                    } else {
                        [self.newsArray addObject:post];
                    }
                }
            }
            
        }
        if (page==1) {
            [self doneWithView:_header];
        } else {
            [self doneWithView:_footer];
        }
    }
}

#pragma mark - Table view data source
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    MNews* post = [_newsArray objectAtIndex:indexPath.section];
////    NSLog(@"%lf",110 + [ChatCenterPostCell getHeight:post.content_ hasConstraint:YES]);
//    return 90;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    // Return the number of sections.
//    return self.newsArray.count;
//}
//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 5;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return _sectionHeader;
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.newsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"news"];
    MNews *n = [self.newsArray objectAtIndex:indexPath.row];
    [cell.newsTitleLabel setText:n.title_];
    [cell.newsTimeLabel setText:@"| 2015-03-12"];
    NSLog(@"%@",n.time_);
    //        [cell.newsSourceTitle setText:[NSString stringWithFormat:@"来自 %@",n.source_]];
    [cell.newsSourceTitle setText:@"来自 研大大"];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MNews* n = [self.newsArray objectAtIndex:indexPath.section];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"EssenceStoryboard" bundle:nil];
    EssenceDetailWebViewController* detail = [storyboard instantiateViewControllerWithIdentifier:@"essenceWeb"];
    detail.url = [NSURL URLWithString:[n.url_ stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    detail.title = @"新闻详情";
    [self.navigationController pushViewController:detail animated:YES];
}



@end
