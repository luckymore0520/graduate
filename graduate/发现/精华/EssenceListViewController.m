//
//  EssenceListViewController.m
//  graduate
//
//  Created by luck-mac on 15/2/6.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "EssenceListViewController.h"
#import "MEssenceCollect.h"
#import "EssenceListCell.h"
#import "ButtonGroup.h"
#import "MGetEssenceList.h"
#import "MEssenceList.h"
#import "MUpdateUserInfo.h"
#import "MUser.h"
#import "MKeys.h"
#import "MEssenceDownload.h"
#import "EssenceDetailViewController.h"
#import "EssenceDetailWebViewController.h"
@interface EssenceListViewController ()<ButtonGroupDelegate,UIAlertViewDelegate,UIActionSheetDelegate>

@property (nonatomic,strong)NSMutableArray* essenceList;
@property (nonatomic,strong)UIView* editView;
@property (nonatomic,strong)UITextField* editTextView;
@property (nonatomic,strong)MUser* user;
@property (nonatomic,strong)UIAlertView* emailAlert;
@property (nonatomic,strong)UIAlertView* shareAlert;
@property (nonatomic,strong)MEssence* selectEssence;
@property (nonatomic,strong)NSArray* typeArray;
@end

@implementation EssenceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.essenceList = [[NSMutableArray alloc]init];
    _user = [MUser objectWithKeyValues:[ToolUtils getUserInfomation]];
    _typeArray = @[@"视频图标",@"音频图标",@"文档图标"];
}


- (void)initViews
{
    
}

- (void)reloadData
{
    page = 1;
    [_essenceList removeAllObjects];
    [_header beginRefreshing];
}

- (void)loadData
{

    MGetEssenceList* getEssenceList = [[MGetEssenceList alloc]init];
    getEssenceList = (MGetEssenceList*)[getEssenceList setPage:page limit:pageCount];
    [getEssenceList load:self type:self.type key:_key];
}


- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MEssenceList"]) {
        MEssenceList* essences = [MEssenceList objectWithKeyValues:data];
        for (MEssence* essence in essences.essence_) {
            BOOL has = NO;

            for (MEssence* currentEssence in self.essenceList) {
                if ([currentEssence.id_ isEqualToString:essence.id_]) {
                    has = YES;
                    break;
                }
            }
            if (!has) {
                [self.essenceList addObject:essence];
            }
        }
        if (page==1) {
            [self doneWithView:_header];
        } else {
            [self doneWithView:_footer];
        }
    } else if ([names isEqualToString:@"MEssenceDownload"])
    {
        [ToolUtils showToast:@"已发送至您的邮箱" toView:self.view];
    } else if ([names isEqualToString:@"MEssenceCollect"])
    {
        [ToolUtils showToast:@"收藏成功" toView:self.view];
        self.selectEssence.isCollected_ = @1;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)download:(id)sender {
    UIButton* button = (UIButton*)sender;
    self.selectEssence = [self.essenceList objectAtIndex:button.tag];
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发送至邮箱",@"保存至我的收藏", nil];
    [actionSheet showInView:self.view];
    
}

#pragma mark -ButtonGroupDelegate
- (void)selectIndex:(NSInteger)index name:(NSString *)buttonName
{
    page = 1;
    [_header beginRefreshing];
    [self.essenceList  removeAllObjects];
    [self loadData];
}

#pragma mark -TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return self.essenceList.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.tableView) {
        EssenceListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"essence"];
        MEssence* essence = [self.essenceList objectAtIndex:indexPath.row];
        [cell.essenceTitleLabel setText:essence.title_];
        [cell.essenceSourceLabel setText:[NSString stringWithFormat:@"来自网友%@的分享",essence.source_]];
        [cell.essenceTimeLabel setText:[NSString stringWithFormat:@"| %@",essence.time_]];
        [cell.essenceDownloadBt setTag:indexPath.row];
        if (essence.hasDownload_.integerValue == 0) {
            [cell.essenceDownloadBt setHidden:YES];
        }
        [cell.essenceIsVipLabel setHidden:!essence.needShare_.boolValue];
        [cell.essenceTypeImage setImage:[UIImage imageNamed:_typeArray[essence.resType_.integerValue]]];
        return cell;

    } 
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (tableView==self.tableView) {
        MEssence* essence = [self.essenceList objectAtIndex:indexPath.row];
        if (essence.hasDownload_.integerValue==1) {
            EssenceDetailViewController* detail = [self.storyboard instantiateViewControllerWithIdentifier:@"essenceDetail"];
            detail.essence = essence;
            [self.parentVC.navigationController pushViewController:detail animated:YES];
        } else {
            EssenceDetailWebViewController* detail = [self.storyboard instantiateViewControllerWithIdentifier:@"essenceWeb"];
            detail.url = [NSURL URLWithString:essence.url_];
            detail.postId = essence.id_;
            [self.parentVC.navigationController pushViewController:detail animated:YES];
        }
    }
}

#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        MEssence* essence = self.selectEssence;
        if (!_user.email_||_user.email_.length==0) {
            if (!self.emailAlert) {
                _emailAlert = [[UIAlertView alloc]initWithTitle:@"设置邮箱" message:@"下载前请先设置邮箱" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            }
            [_emailAlert show];
            return;
        } else if (essence.isDownloaded_.integerValue==1||essence.needShare_.integerValue==0) {
            [[[MEssenceDownload alloc]init]load:self id:self.selectEssence.id_ resid:self.selectEssence.resid_ email:_user.email_ isShared:@"1"];
        } else {
            if (!self.shareAlert) {
                _shareAlert = [[UIAlertView alloc]initWithTitle:@"先分享，再下载" message:@"因为是星级帖，所以要先分享后再下载" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"分享", nil];
            }
            [_shareAlert show];
        }
    } else {
        if (self.selectEssence.isCollected_) {
            [ToolUtils showToast:@"您已收藏该资料" toView:self.view];
            return;
        }
        [[[MEssenceCollect alloc]init]load:self id:self.selectEssence.id_ type:1];
    }
}

#pragma mark -AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.emailAlert) {
        if (buttonIndex==1) {
            [self editEmail];
        }
    } else if (alertView == self.shareAlert)
    {
        if (buttonIndex==1) {
             [[[MEssenceDownload alloc]init]load:self id:self.selectEssence.id_ resid:self.selectEssence.resid_ email:_user.email_ isShared:@"1"];
        }
    }
    
}

- (void)editEmail
{
    [self.parentVC addMask];
    if (!_editView) {
        CGRect frame = CGRectMake(0, SC_DEVICE_SIZE.height, SC_DEVICE_SIZE.width, 120);
        _editView = [[UIView alloc]initWithFrame:frame];
        _editView.backgroundColor = [UIColor whiteColor];
        [self.parentVC.navigationController.view addSubview:_editView];
        CGRect textFrame = CGRectMake(0, 50, SC_DEVICE_SIZE.width, 70);
        
        _editTextView = [[UITextField alloc]initWithFrame:textFrame];
        _editTextView.layer.borderWidth = 1;
        _editTextView.keyboardType = UIKeyboardTypeEmailAddress;
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
        [saveButton addTarget:self action:@selector(saveEmail) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [saveButton setTitleColor: [UIColor colorWithRed:31/255.0 green:118/255.0 blue:220/255.0 alpha:1] forState:UIControlStateNormal];
        [_editView addSubview:saveButton];
    }
    self.editTextView.placeholder = @"请设置您的电子邮箱，以便接收下载的资料";
    [self.parentVC.navigationController.view bringSubviewToFront:self.editView];
    [self.editTextView becomeFirstResponder];
}

- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    keyboardHeight = keyboardSize.height>=240?keyboardSize.height:240;
    [ToolUtils setKeyboardHeight:[NSNumber numberWithDouble:keyboardHeight]];
    CGRect frame = self.editView.frame;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.editView.transform = CGAffineTransformMakeTranslation(0, -frame.size.height-(keyboardHeight==0?240:keyboardHeight));
    } completion:^(BOOL finished) {
    }];
}


- (void) keyboardWasHidden:(NSNotification *) notif
{
    [self.parentVC removeMask];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.editView.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        
    }];
}



-(void)cancelEdit
{
    [self.editTextView resignFirstResponder];
}

-(void)saveEmail
{
    if ([ToolUtils checkEmail:self.editTextView.text]) {
        [self.editTextView resignFirstResponder];

        self.user.email_ = self.editTextView.text;
        [ToolUtils setUserInfomation:self.user.keyValues];
        
        [[[MUpdateUserInfo alloc]init]load:self nickname:_user.nickname_ headImg:_user.headImg_ sex:_user.sex_.integerValue email:_user.email_];
        if (self.selectEssence.isDownloaded_.integerValue==1||self.selectEssence.needShare_.integerValue==0) {
            [[[MEssenceDownload alloc]init]load:self id:self.selectEssence.id_ resid:self.selectEssence.resid_ email:_user.email_ isShared:@"1"];
        } else {
            if (!self.shareAlert) {
                _shareAlert = [[UIAlertView alloc]initWithTitle:@"先分享，再下载" message:@"因为是星级帖，所以要先分享后再下载" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"分享", nil];
            }
            [_shareAlert show];
        }
    } else {
        [ToolUtils showMessage:@"邮箱格式不合法,请输入正确的邮箱"];
    }
}

@end
