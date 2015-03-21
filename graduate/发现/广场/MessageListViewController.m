//
//  MessageListViewController.m
//  graduate
//
//  Created by luck-mac on 15/2/5.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MessageListViewController.h"
#import "ChatCenterDetailViewController.h"
#import "MCommentList.h"
#import "MessageCell.h"
#import "MCommentsToMe.h"
@interface MessageListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray* commentList;
@property (nonatomic)BOOL firstAppear;
@end

@implementation MessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _firstAppear = YES;
    [self setTitle:@"消息列表"];
    self.commentList = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
}

- (void)loadData
{
    MCommentsToMe* commentToMe = [[MCommentsToMe alloc]init];
    commentToMe = (MCommentsToMe*)[commentToMe setPage:page limit:pageCount];
    [commentToMe load:self];
}


- (void)viewDidAppear:(BOOL)animated
{
    if (_firstAppear) {
        _firstAppear=NO;
    } else {
        [self loadData];
    }
}

- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ( [names isEqualToString:@"MCommentsToMe"]) {
        MCommentList* list = [MCommentList objectWithKeyValues:data];
        for (MComment* comment in list.comments_) {
            BOOL has = NO;
            for (MComment* currentComment in self.commentList) {
                if ([currentComment.id_ isEqualToString:comment.id_]) {
                    has = YES;
                    currentComment.isNew_ = comment.isNew_;
                    break;
                }
            }
            if (!has) {
                [self.commentList addObject:comment];
            }
        }
        
        if (page==1) {
            [self doneWithView:_header];
        } else {
            [self doneWithView:_footer];
        }
        
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -tableViewDelegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell* cell = [tableView dequeueReusableCellWithIdentifier:@"message"];
    MComment* comment = [self.commentList objectAtIndex:indexPath.row];
    NSRange range = [comment.content_ rangeOfString:@":"];
    [cell.contentLabel setText:[NSString stringWithFormat:@"%@回复:%@",comment.nickname_,[comment.content_ substringFromIndex:(int)range.location+1]]];
    [cell.stateLabel setText:comment.isNew_.integerValue==0?@"已读":@"未读"];
    if (comment.isNew_.integerValue==0) {
        [cell.contentLabel setTextColor:[UIColor colorOfGrayText]];
        [cell.stateLabel setTextColor:[UIColor colorOfGrayText]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MComment* comment = [self.commentList objectAtIndex:indexPath.row];
    ChatCenterDetailViewController* nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"centerDetail"];
    nextVC.postId = comment.pid_;
    nextVC.replyNickname = comment.nickname_;
    nextVC.selectFloor = comment.userid_;
    [self.navigationController pushViewController:nextVC animated:YES];
}


@end
