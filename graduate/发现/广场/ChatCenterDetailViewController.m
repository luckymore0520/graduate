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
#import "MPostReport.h"
#import "MPostDetail.h"
#import "ChatCenterPostCell.h"
#import "UIPlaceHolderTextView.h"
@interface ChatCenterDetailViewController ()<UIActionSheetDelegate>
@property (nonatomic,strong)NSMutableArray* commentList;
@property (nonatomic,strong)UIView* editView;
@property (nonatomic,strong)UIPlaceHolderTextView* editTextView;
@property (nonatomic,strong)NSString* selectFloor;
@property (weak, nonatomic) IBOutlet UIView *shareView;
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

- (void)initViews
{
    
}
- (IBAction)share:(id)sender {
    [self addMask];
    [self.view bringSubviewToFront:_shareView];
    [UIView animateWithDuration:0.3 animations:^{
        _shareView.transform = CGAffineTransformMake(self.scale, 0, 0, self.scale, 0, -_shareView.frame.size.height);
    }];
    
}

- (void)addMask
{
    if (!self.maskView) {
        self.maskView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
        [self.maskView setAlpha:0.5];
        [self.maskView setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:self.maskView];
    }
    [self.maskView setHidden:NO];
}

- (IBAction)cancelShare:(id)sender {
    [self removeMask];
    [UIView animateWithDuration:0.3 animations:^{
        _shareView.transform = CGAffineTransformMake(self.scale, 0, 0, self.scale, 0, 0);
    }];
}


- (IBAction)showMore:(id)sender {
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报" otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
}
- (void)loadData
{
    if (!self.post) {
        [[[MPostDetail alloc]init]load:self postid:self.postId];
    } else {
        self.postId = self.post.id_;
    }
    MComments* comments = [[MComments alloc]init];
    comments = (MComments*)[comments setPage:page limit:pageCount];
    [comments load:self postid:_postId];
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
        
    } else if ([names isEqualToString:@"MPostDetail"])
    {
        MPost* post = [MPost objectWithKeyValues:data];
        self.post = post;
        [self doneWithView:_header];
    } else if ([names isEqualToString:@"MPostReport"])
    {
        [ToolUtils showToast:@"举报成功!" toView:self.view];
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
#pragma mark - actionsheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        MPostReport* report = [[MPostReport alloc]init];
        [report load:self pid:self.post.id_];
    }
}
#pragma mark - tableViewDelegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        if (self.post) {
            return 1;

        } else {
            return 0;
        }
    }
    return _commentList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    return 5;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.commentList.count>0) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 134+[ChatCenterPostCell getHeight:self.post.content_ hasConstraint:NO];
    } else if (indexPath.section==1)
    {
        MComment* comment = [self.commentList objectAtIndex:indexPath.row];
        return 80+[ChatCenterPostCell getHeight:comment.content_ hasConstraint:NO];
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
        CGRect frame = CGRectMake(0, SC_DEVICE_SIZE.height, SC_DEVICE_SIZE.width, 160);
        _editView = [[UIView alloc]initWithFrame:frame];
        _editView.backgroundColor = [UIColor whiteColor];
        [self.navigationController.view addSubview:_editView];
        CGRect textFrame = CGRectMake(0, 50, SC_DEVICE_SIZE.width, 110);
        
        _editTextView = [[UIPlaceHolderTextView alloc]initWithFrame:textFrame];
        _editTextView.layer.borderWidth = 1;
        _editTextView.layer.borderColor = [UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:0.5].CGColor;
        _editTextView.font = [UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:16];
        _editTextView.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        [_editView addSubview:_editTextView];
        CGRect leftBtFrame = CGRectMake(15, 5, 40, 40);
        UIButton* cancelButton = [[UIButton alloc]initWithFrame:leftBtFrame];
        [cancelButton addTarget:self action:@selector(cancelEdit) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor: [UIColor colorWithRed:31/255.0 green:118/255.0 blue:220/255.0 alpha:1] forState:UIControlStateNormal];
        [_editView addSubview:cancelButton];
        
        CGRect rightBtFrame = CGRectMake(SC_DEVICE_SIZE.width-55, 5, 40, 40);
        UIButton* saveButton = [[UIButton alloc]initWithFrame:rightBtFrame];
        [saveButton addTarget:self action:@selector(saveRemark) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [saveButton setTitleColor: [UIColor colorWithRed:31/255.0 green:118/255.0 blue:220/255.0 alpha:1] forState:UIControlStateNormal];
        [_editView addSubview:saveButton];
    }
    NSInteger tag = ((UIButton*)sender).tag;
    if (tag>=0) {
        MComment* comment = [self.commentList objectAtIndex:tag];
        _editTextView.text = [NSString stringWithFormat:@"回复%@:",comment.nickname_];
        self.selectFloor = comment.id_;
    } else {
        _editTextView.text = @"";

    }

    [self.editTextView becomeFirstResponder];
    CGRect frame = _editView.frame;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        NSLog(@"%lf",-frame.size.height-(keyboardHeight==0?240:keyboardHeight));
        self.editView.transform = CGAffineTransformMakeTranslation(0, -frame.size.height-(keyboardHeight==0?240:keyboardHeight));
    } completion:^(BOOL finished) {
        //        [self.keyboardBt setHidden:NO];
    }];
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
