//
//  SquareViewController.m
//  graduate
//
//  Created by Sylar on 26/1/15.
//  Copyright (c) 2015 nju.excalibur. All rights reserved.
//

#import "ChatCenterVC.h"
#import "ChatCenterPostCell.h"
#import "MPosts.h"
#import "MPostList.h"
#import "MGetMsgCount.h"
#import "MReturn.h"
#import "MMsgCount.h"
#import "ChatCenterDetailViewController.h"
@interface ChatCenterVC ()
@property (nonatomic,strong)NSMutableArray* postArray;
@property (nonatomic,strong)UIView* sectionHeader;
@property (nonatomic)BOOL firstAppear;
@property (nonatomic,strong)UIButton* msgBt;
@end

@implementation ChatCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _sectionHeader = [[UIView alloc] initWithFrame:CGRectZero];
    [self setTitle:@"广场"];
    _firstAppear = YES;
    _postArray = [[NSMutableArray alloc]init];
       // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)initViews
{
    
}


-(void) addRightButton:(NSInteger)number
{
    if (!self.msgBt) {
        self.msgBt  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    }

    if (number>0) {
        [self.msgBt setImage:[UIImage imageNamed:@"广场消息提醒_p"] forState:UIControlStateNormal];
    } else {
        [self.msgBt setImage:[UIImage imageNamed:@"广场消息提醒"] forState:UIControlStateNormal];

    }
    
    [self.msgBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.msgBt addTarget:self action:@selector(newMsg) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *myAddButton = [[UIBarButtonItem alloc] initWithCustomView:self.msgBt];
    [myAddButton setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = myAddButton;
}

- (void)newMsg
{
    UIViewController* nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"message"];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (_firstAppear) {
        _firstAppear = NO;
    } else {
        MPosts* posts = [[MPosts alloc]init];
        posts = (MPosts*)[posts setPage:1 limit:pageCount];
        [posts load:self type:2];
        MGetMsgCount* msg = [[MGetMsgCount alloc]init];
        [msg load:self];
    }
}
- (IBAction)publish:(id)sender {
    UIViewController* nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"publish"];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)loadData
{
    MPosts* posts = [[MPosts alloc]init];
    posts = (MPosts*)[posts setPage:page limit:pageCount];
    [posts load:self type:2];
    MGetMsgCount* msg = [[MGetMsgCount alloc]init];
    [msg load:self];
}



#pragma mark -APiDelegate
- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MPosts"]) {
        MPostList* list = [MPostList objectWithKeyValues:data];
        if (self.postArray.count==0) {
            self.postArray = list.list_;
        } else {
            for (MPost* post in list.list_) {
                BOOL has = NO;
                for (MPost* currentPost in self.postArray) {
                    if ([post.id_ isEqualToString:currentPost.id_]) {
                        has = YES;
                        currentPost.commentCount_ = post.commentCount_;
                        break;
                    }
                }
                if (!has) {
                    if (page==1) {
                        [self.postArray insertObject:post atIndex:0];
                    } else {
                        [self.postArray addObject:post];
                    }
                }
            }
  
        }
        if (page==1) {
            [self doneWithView:_header];
        } else {
            [self doneWithView:_footer];
        }
    } else if ([names isEqualToString:@"MGetMsgCount"])
    {
        MMsgCount* ret = [MMsgCount objectWithKeyValues:data];
        [self addRightButton:ret.square_.integerValue];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPost* post = [_postArray objectAtIndex:indexPath.section];
    NSLog(@"%lf",110 + [ChatCenterPostCell getHeight:post.content_ hasConstraint:YES]);
    return 110 + [ChatCenterPostCell getHeight:post.content_ hasConstraint:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.postArray.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _sectionHeader;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCenterPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"square" forIndexPath:indexPath];
    MPost *post = [self.postArray objectAtIndex:indexPath.section];
    UIImage* placeHolder = [UIImage imageNamed:post.sex_.integerValue ==0?@"默认男头像":@"默认女头像"];
    [cell.postAltasImageView sd_setImageWithURL:[ToolUtils getImageUrlWtihString:post.headimg_ width:100 height:100] placeholderImage:placeHolder];
    [cell.postContextLabel setText:post.content_];
    [cell.postNickNameLabel setText:post.nickname_.length==0?@"   ":post.nickname_];
    [cell.postRepliedLabel setText:[NSString stringWithFormat:@"%d",post.commentCount_.integerValue]];
    [cell.postTitleLabel setText:post.title_];
    [cell.postIntervalLabel setText:post.time_];
    [cell.postSexImageView setImage:[UIImage imageNamed:post.sex_.integerValue==0?@"男生图标":@"广场女生图标" ]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPost* post = [self.postArray objectAtIndex:indexPath.section];
    ChatCenterDetailViewController* nextVC = (ChatCenterDetailViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"centerDetail"];
    nextVC.post = post;
    [self.navigationController pushViewController:nextVC animated:YES];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
