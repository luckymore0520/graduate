//
//  ChatCenterDetailViewController.m
//  graduate
//
//  Created by luck-mac on 15/2/5.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "ChatCenterDetailViewController.h"
#import "MComments.h"
#import "MCommentList.h"
#import "MCommentPublish.h"
#import "ChatCenterPostCell.h"
#import "UIPlaceHolderTextView.h"
@interface ChatCenterDetailViewController ()
@property (nonatomic,strong)NSMutableArray* commentList;
@property (nonatomic,strong)UIView* editView;
@property (nonatomic,strong)UIPlaceHolderTextView* editTextView;
@property (nonatomic,strong)NSString* selectFloor;
@end

@implementation ChatCenterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"帖子详情"];
    self.commentList = [[NSMutableArray alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view.
}


- (void)loadData
{
    MComments* comments = [[MComments alloc]init];
    comments = (MComments*)[comments setPage:page limit:pageCount];
    [comments load:self postid:self.post.id_];
}



- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MComments"]) {
        MCommentList* list = [MCommentList objectWithKeyValues:data];
        for (MComment* comment in list.comments_) {
            NSLog(@"______________%@",comment.id_);
            BOOL has = NO;
            for (MComment* currentComment in self.commentList) {
                if ([currentComment.id_ isEqualToString:comment.id_]) {
                    has = YES;
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
    } else if ([names isEqualToString:@"MCommentPublish"])
    {
        MComments* comments = [[MComments alloc]init];
        comments = (MComments*)[comments setPage:1 limit:self.commentList.count+1];
        [self.commentList removeAllObjects];
        [comments load:self postid:self.post.id_];
        
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
    if (section==0) {
        return 1;
    }
    return _commentList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 100+[ChatCenterPostCell getHeight:self.post.content_];
    } else if (indexPath.section==1)
    {
        MComment* comment = [self.commentList objectAtIndex:indexPath.row];
        return 80+[ChatCenterPostCell getHeight:comment.content_];
    }
    return 0;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        ChatCenterPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"square" forIndexPath:indexPath];
        [cell.postAltasImageView sd_setImageWithURL:[ToolUtils getImageUrlWtihString:_post.headimg_ width:100 height:100] placeholderImage:nil];
        [cell.postContextLabel setText:_post.content_];
        [cell.postNickNameLabel setText:_post.nickname_.length==0?@"   ":_post.nickname_];
        [cell.postIntervalLabel setText:_post.time_];
        [cell.postTitleLabel setText:_post.title_];
        
        return cell;
    } else if (indexPath.section==1){
        ChatCenterPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reply" forIndexPath:indexPath];
        MComment *comment = [self.commentList objectAtIndex:indexPath.row];
        [cell.postAltasImageView sd_setImageWithURL:[ToolUtils getImageUrlWtihString:comment.headimg_ width:100 height:100] placeholderImage:nil];
        [cell.postContextLabel setText:comment.content_];
        [cell.postNickNameLabel setText:comment.nickname_.length==0?@"   ":comment.nickname_];
        [cell.postIntervalLabel setText:comment.time_];
        [cell.replyBt setTag:indexPath.row];
        return cell;
    }
    return nil;
}



- (IBAction)comment:(id)sender {
    
    [self editRemark:sender];
    
    
}


- (void)editRemark:(id)sender
{
    [self addMask];
    if (!_editView) {
        CGRect frame = CGRectMake(0, SC_DEVICE_SIZE.height, SC_DEVICE_SIZE.width, 200);
        _editView = [[UIView alloc]initWithFrame:frame];
        [self.view addSubview:_editView];
        
        CGRect textFrame = CGRectMake(0, 50, SC_DEVICE_SIZE.width, 160);
        
        _editTextView = [[UIPlaceHolderTextView alloc]initWithFrame:textFrame];
        
        
        
        
        [_editView addSubview:_editTextView];
       
        
        CGRect leftBtFrame = CGRectMake(5, 0, 50, 50);
        UIButton* cancelButton = [[UIButton alloc]initWithFrame:leftBtFrame];
        [cancelButton addTarget:self action:@selector(cancelEdit) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton.titleLabel setTextColor:[UIColor blueColor]];
        [_editView addSubview:cancelButton];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        CGRect rightBtFrame = CGRectMake(SC_DEVICE_SIZE.width-55, 5, 50, 50);
        UIButton* saveButton = [[UIButton alloc]initWithFrame:rightBtFrame];
        [saveButton addTarget:self action:@selector(saveRemark) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setTitle:@"发表" forState:UIControlStateNormal];
        [saveButton.titleLabel setTextColor:[UIColor blueColor]];
        [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
        [_editView addSubview:saveButton];
    }
    NSInteger tag = ((UIButton*)sender).tag;
    if (tag>=0) {
        MComment* comment = [self.commentList objectAtIndex:tag];
        _editTextView.placeholder = [NSString stringWithFormat:@"回复%@:",comment.nickname_];
        self.selectFloor = comment.id_;
    }
    [self.editTextView becomeFirstResponder];
    CGRect frame = _editView.frame;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        NSLog(@"%lf",-frame.size.height-(keyboardHeight==0?240:keyboardHeight));
        self.editView.transform = CGAffineTransformMakeTranslation(0, -frame.size.height-(keyboardHeight==0?240:keyboardHeight));
    } completion:^(BOOL finished) {
        //        [self.keyboardBt setHidden:NO];
    }];
    [self.view bringSubviewToFront:self.editView];
    
}


-(void)cancelEdit
{
    [self.editTextView resignFirstResponder];
}

-(void)saveRemark
{
    
    if (self.editTextView.text.length==0) {
        [ToolUtils showMessage:@"评论不能为空"];
        return;
    }
    
    MCommentPublish* publish = [[MCommentPublish alloc]init];
    [publish load:self postid:_post.id_ content:self.editTextView.text replyid:self.selectFloor];
    
    
    [self.editTextView resignFirstResponder];
    
}




- (void) keyboardWasHidden:(NSNotification *) notif
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.editView.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        
    }];
    [self removeMask];
}

@end
