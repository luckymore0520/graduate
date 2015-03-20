//
//  SelfCenterViewController.m
//  graduate
//
//  Created by luck-mac on 15/2/5.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "SelfCenterViewController.h"
#import "SelfHeaderCell.h"
#import "SelfOtherCell.h"
#import "MUser.h"
#import "MUpdateUserInfo.h"
#import "MReturn.h"
#import "WKNavigationViewController.h"
#import "LoginVC.h"
#import "MyCollectionRootView.h"
#import "AboutUsWebViewController.h"
#define HEADIMG 200

@interface SelfCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) MUser* user;
@property (nonatomic,strong)UIView* editView;
@property (nonatomic,strong)UITextField* editTextView;
@end

@implementation SelfCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _user = [MUser objectWithKeyValues:[ToolUtils getUserInfomation]];
}

- (void)initViews
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _user = [MUser objectWithKeyValues:[ToolUtils getUserInfomation]];
    [self.tableView reloadData];
}

#pragma mark -TableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        SelfHeaderCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"imgHeader"];
        UIImage* placeHolder = [UIImage imageNamed:_user.sex_.integerValue ==0?@"默认男头像":@"默认女头像"];
        [cell.headImg sd_setImageWithURL:[ToolUtils getImageUrlWtihString:_user.headImg_ width:HEADIMG height:HEADIMG] placeholderImage:placeHolder];
        [cell.nickNameLabel setText:_user.nickname_];
        [cell.genderImgView setImage:[UIImage imageNamed:_user.sex_.integerValue==0?@"个人中心-男生图标":@"个人中心-女生图标"]];
        [cell.userIdLabel setText:[NSString stringWithFormat:@"研大大ID:%@",_user.account_]];
        
        return cell;
    } else if (indexPath.section == 1)
    {
        SelfOtherCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"email"];
        if (_user.email_.length>0) {
            [cell.emailAddressLabel setText:_user.email_];
            [cell.emailTipLabel setText:@"修改"];
        } else {
            [cell.emailAddressLabel setText:@""];
            [cell.emailTipLabel setText:@"添加"];
        }
        [cell.cellImgView setImage:[UIImage imageNamed:@"下载邮箱"]];
        return cell;
    } else if (indexPath.section == 2)
    {
        SelfOtherCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"email"];
        [cell.cellNameLabel setText:@"密码管理"];
        if (_user.hasPassword_.integerValue==0) {
            [cell.emailTipLabel setText:@"设置"];
        } else {
            [cell.emailTipLabel setText:@"修改"];

        }
        [cell.emailAddressLabel setHidden:YES];
        [cell.cellImgView setImage:[UIImage imageNamed:@"密码管理图标"]];
        return cell;
    } else if (indexPath.section==3)
                               {
        SelfOtherCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"other"];
                                   switch (indexPath.row) {
                                       case 0:
                                           [cell.cellNameLabel setText:@"我的收藏"];
                                           [cell.cellImgView setImage:[UIImage imageNamed:@"我的收藏"]];
                                           break;
                                       case 1:
                                           [cell.cellImgView setImage:[UIImage imageNamed:@"个人-联系我们"]];
                                           [cell.cellNameLabel setText:@"联系我们"];
                                           break;
                                       case 2:
                                           [cell.cellImgView setImage:[UIImage imageNamed:@"关于我们"]];
                                           [cell.cellNameLabel setText:@"关于我们"];
                                           break;
                                     
                                       default:
                                           break;
                                   }
                                   
        return cell;
    } else if (indexPath.section==4)
    {
        UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"logout"];
        return cell;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section==0) {
        [self performSegueWithIdentifier:@"editSelfInfo" sender:nil];
    } else if (indexPath.section==1)
    {
        [self editEmail];
    } else if (indexPath.section ==4)
        
    {
        UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"退出后不会删除任何历史数据，下次登录依然可以使用本账号" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登录" otherButtonTitles:nil, nil];
        [actionSheet showInView:self.view];
    } else if (indexPath.section==2)
    {
        if (_user.hasPassword_&&_user.hasPassword_.integerValue==1) {
            [self performSegueWithIdentifier:@"changePassword" sender:nil];
        } else {
            [self performSegueWithIdentifier:@"setPassword" sender:nil];
        }
    } else if (indexPath.section==3)
    {
        if (indexPath.row==0) {
//            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"EssenceStoryboard" bundle:nil];
//            UIViewController* nextVC = [storyboard instantiateViewControllerWithIdentifier:@"myCollection"];
            MyCollectionRootView* myCollection = [[MyCollectionRootView alloc]initWithNibName:NSStringFromClass([MyCollectionRootView class]) bundle:nil];
            [self.navigationController pushViewController:myCollection animated:YES];
        } else if (indexPath.row == 1)
        {
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"DiscoverStoryBoard" bundle:nil];
            SelfCenterViewController* nextVC = [storyboard instantiateViewControllerWithIdentifier:@"feedback"];
            [self.navigationController pushViewController:nextVC animated:YES];
        }else if(indexPath.row == 2){
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"DiscoverStoryBoard" bundle:nil];
            AboutUsWebViewController *abvc = [storyboard instantiateViewControllerWithIdentifier:@"aboutus"];
            [self.navigationController pushViewController:abvc animated:YES];
        }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 100;
    }
    return 59;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
        case 2:
            return 1;
        case 3:
            return 3;
        case 4:
            return 1;
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 15)];
    return view;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)editEmail
{
    [self addMask];
    if (!_editView) {
        CGRect frame = CGRectMake(0, SC_DEVICE_SIZE.height, SC_DEVICE_SIZE.width, 120);
        _editView = [[UIView alloc]initWithFrame:frame];
        _editView.backgroundColor = [UIColor whiteColor];
        [self.navigationController.view addSubview:_editView];
        CGRect textFrame = CGRectMake(0, 50, SC_DEVICE_SIZE.width, 70);
        
        _editTextView = [[UITextField alloc]initWithFrame:textFrame];
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
        [saveButton addTarget:self action:@selector(saveEmail) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [saveButton setTitleColor: [UIColor colorWithRed:31/255.0 green:118/255.0 blue:220/255.0 alpha:1] forState:UIControlStateNormal];
        [_editView addSubview:saveButton];
        
    }
    self.editTextView.placeholder = @"请设置您的电子邮箱，以便接收下载的资料";
    if (self.user.email_&&self.user.email_.length>0) {
        self.editTextView.text = self.user.email_;
    }
    [self.navigationController.view bringSubviewToFront:self.editView];
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
    [self removeMask];
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
        SelfOtherCell* cell = (SelfOtherCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
        [cell.emailAddressLabel setText:self.editTextView.text];
        [cell.emailTipLabel setText:@"修改"];
        self.user.email_ = self.editTextView.text;
        [ToolUtils setUserInfomation:self.user.keyValues];
        
        [[[MUpdateUserInfo alloc]init]load:self nickname:_user.nickname_ headImg:_user.headImg_ sex:_user.sex_.integerValue email:_user.email_];
        
        
        
    } else {
        [ToolUtils showMessage:@"邮箱格式不合法,请输入正确的邮箱"];
    }
}

#pragma mark -ActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==0) {
        [ToolUtils setHasLogin:NO];
        [ToolUtils setUserId:nil];
        [ToolUtils setVerify:nil];
        UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"User" bundle:nil];
        LoginVC* _rootVC = (LoginVC*)[myStoryBoard instantiateViewControllerWithIdentifier:@"login"];
        WKNavigationViewController* nav = [[WKNavigationViewController alloc]initWithRootViewController:_rootVC];
        [nav setNavigationBarHidden:YES];
        [[[UIApplication sharedApplication].delegate window] setRootViewController:nav];
    }
}

#pragma mark -ApiDelegate
- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MUpdateUserInfo"]) {
        MReturn* ret = [MReturn objectWithKeyValues:data];
        if (ret.code_.integerValue==0) {
            NSLog(@"修改邮箱成功");
        }
    }
}
@end
