//
//  EssenceDetailViewController.m
//  graduate
//
//  Created by luck-mac on 15/2/6.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "EssenceDetailViewController.h"
#import "MUser.h"
#import "MEssenceDownload.h"
#import "MUpdateUserInfo.h"
#import "MEssenceDetail.h"
#import "MEssenceCollect.h"
#import "EssenceMediaCell.h"

@interface EssenceDetailViewController ()<UIAlertViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *essenceCollectButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *essenceShareLabel;
@property (weak, nonatomic) IBOutlet UIView *maskBackView;
@property (weak, nonatomic) IBOutlet UILabel *essenceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *essenceTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *essenceSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *essenceDownloadTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *essenceShowTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *essenceUploadLabel;
@property (weak, nonatomic) IBOutlet UIButton *essenceDownloadBt;
@property (weak, nonatomic) IBOutlet UICollectionView *videoCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoCollectionViewHeight;
@property (nonatomic,strong)MUser* user;
@property (nonatomic,strong)UITextField* editTextView;
@property (nonatomic,strong)UIView* editView;
@property (nonatomic,strong)UIAlertView* emailAlert;
@property (nonatomic,strong)UIAlertView* shareAlert;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (nonatomic,strong)NSArray* typeList;
@end

@implementation EssenceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"精华详情"];
    _user = [MUser objectWithKeyValues:[ToolUtils getUserInfomation]];
    self.typeList = [NSArray arrayWithObjects:@"视频",@"音频",@"文档" ,nil];
    // Do any additional setup after loading the view.
    [self loadData];
    [[[MEssenceDetail alloc]init]load:self id:self.essence.id_];
    if (_user.email_.length>0) {
        [self.essenceDownloadBt setTitle:[NSString stringWithFormat:@"下载至%@",_user.email_] forState:UIControlStateNormal];
    }
    _essenceDownloadBt.layer.cornerRadius = 5;
    [self.navigationController setNavigationBarHidden:NO];
    if (_isMyCollection) {
        [_essenceDownloadBt setHidden:YES];
        [_essenceCollectButton setHidden:YES];
    }
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(processShareSuccess) name:@"shareSuccess" object:nil];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addRightButton
{
    [self addRightButton:@"更多精华" action:@selector(showMore) img:nil];
}

- (void)showMore
{
    BaseFuncVC* more = (BaseFuncVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"essenceRoot"];
    [self.navigationController pushViewController:more
                                         animated:YES];
}
- (void)loadData
{
    [self.essenceTitleLabel setText:self.essence.title_];
    [self.essenceTypeLabel setText:[self.typeList objectAtIndex:self.essence.resType_.integerValue]];
    [self.essenceUploadLabel setText:self.essence.source_];
    if (self.essence.resSize_) {
        [self.essenceSizeLabel setText:self.essence.resSize_];
    }
    if (self.essence.browseTimes_) {
        [self.essenceShowTimeLabel setText:[NSString stringWithFormat:@"%ld次",(long)self.essence.browseTimes_.integerValue]];
    }
    if (self.essence.downloadTimes_) {
         [self.essenceDownloadTimeLabel setText:[NSString stringWithFormat:@"%ld次",(long)self.essence.downloadTimes_.integerValue]];
    }
    if (self.essence.needShare_.integerValue==1) {
        NSLog(@"");
        self.essenceShareLabel.text = @"这是研友辛辛苦苦找的哦！为了帮助更多研伴，请先分享哦！";
        [self.essenceShareLabel setHidden:NO];
    }
    if (self.essence.media_.count==0) {
        _videoCollectionViewHeight.constant = 0;
    } else {
        _videoCollectionViewHeight.constant = (self.essence.media_.count/5+1)*50-15;
    }
    [self.view layoutIfNeeded];
}


- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MEssenceDownload"])
    {
        [ToolUtils showToast:@"已发送至您的邮箱" toView:self.view];
    } else if ([names isEqualToString:@"MEssenceDetail"])
    {
        self.essence = [MEssence objectWithKeyValues:data];
        [self loadData];
    } else if ([names isEqualToString:@"MEssenceCollect"])
    {
        [ToolUtils showToast:@"收藏成功" toView:self.view];
    }
}
- (IBAction)collect:(id)sender {
    if (self.essence.isCollected_.boolValue) {
        [ToolUtils showToast:@"您已收藏该资料" toView:self.view];
        return;
    }
    self.essence.isCollected_ = @YES;
    [[[MEssenceCollect alloc]init]load:self id:self.essence.id_ type:1];
}

-(void)hideShareView
{
    [_maskBackView setHidden:YES];
    [self removeMaskAtNavigation];
    [UIView animateWithDuration:0.3 animations:^{
        self.shareView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
    }];
}

- (IBAction)cancelShare:(id)sender {
    [self hideShareView];

}
- (IBAction)share:(id)sender {
    [_maskBackView setHidden:NO];
    [self addMaskAtNavigation];
    [UIView animateWithDuration:0.3 animations:^{
        self.shareView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, -self.shareView.frame.size.height);
    }];
}

- (IBAction)download:(id)sender {
    if (!_user.email_||_user.email_.length==0) {
        if (!self.emailAlert) {
            _emailAlert = [[UIAlertView alloc]initWithTitle:@"设置邮箱" message:@"下载前请先设置邮箱" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
        }
        [_emailAlert show];
        return;
    } else if (_essence.isDownloaded_.integerValue==1||_essence.needShare_.integerValue==0) {
         [[[MEssenceDownload alloc]init]load:self id:_essence.id_ resid:_essence.resid_ email:_user.email_ isShared:@"1"];
    } else {
        if (!self.shareAlert) {
            _shareAlert = [[UIAlertView alloc]initWithTitle:@"先分享，再下载" message:@"因为是星级帖，所以要先分享后再下载" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"分享", nil];
        }
        [_shareAlert show];
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
            [self share:nil];
        }
    }
    
}

-(void)sendEmail
{
    [[[MEssenceDownload alloc]init]load:self id:_essence.id_ resid:_essence.resid_ email:_user.email_ isShared:@"1"];
}

- (void)editEmail
{
    [self addMask];
    [self addMaskAtNavigation];
    if (!_editView) {
        CGRect frame = CGRectMake(0, SC_DEVICE_SIZE.height, SC_DEVICE_SIZE.width, 120);
        _editView = [[UIView alloc]initWithFrame:frame];
        _editView.backgroundColor = [UIColor whiteColor];
        [self.navigationController.view addSubview:_editView];
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
    [self.editView setBackgroundColor:[UIColor whiteColor]];
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
    [self removeMaskAtNavigation];
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
        if (self.essence.isDownloaded_.integerValue==1||self.essence.needShare_.integerValue==0) {
            [[[MEssenceDownload alloc]init]load:self id:self.essence.id_ resid:self.essence.resid_ email:_user.email_ isShared:@"1"];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -UICollectionViewDatasource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EssenceMediaCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EssenceMediaCell class]) forIndexPath:indexPath];
    if (indexPath.row<10) {
        [cell.numberButton setTitle:[NSString stringWithFormat:@"0%ld",(long)indexPath.row+1] forState:UIControlStateNormal];
    } else {
        [cell.numberButton setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row+1] forState:UIControlStateNormal];
    }
    cell.viewController = self;
    cell.media = self.essence.media_[indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.essence.media_.count;
}
#pragma mark -sharebuttons

- (IBAction)qqShare:(UIButton *)sender
{
    self.essence.hasDownload_ = @1;
    [ShareApiUtil qqShare:[self getShareTitle] description:[self getShareTitle] imageUrl:[BaseFuncVC getShareImgUrl] shareUrl:[self getShareUrl] from:self];
}

- (IBAction)friendsShare:(UIButton *)sender {
    [ShareApiUtil weixinShare:[self getShareTitle] description:[self getShareTitle] imageUrl:[BaseFuncVC getShareImgUrl] shareUrl:[self getShareUrl]scene:WXSceneTimeline];
}
- (IBAction)weixinShare:(UIButton *)sender {
    [ShareApiUtil weixinShare:[self getShareTitle] description:[self getShareTitle] imageUrl:[BaseFuncVC getShareImgUrl] shareUrl:[self getShareUrl]scene:WXSceneSession];
}


- (IBAction)weiboShare:(UIButton *)sender {
   // AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [ShareApiUtil weiboShare:[self getShareTitle] description:[self getShareTitle] imageUrl:[BaseFuncVC getShareImgUrl] shareUrl:[self getShareUrl]];
}

-(void)processShareSuccess{
    [self hideShareView];
    self.essence.isDownloaded_ = @1;
    [ShareApiUtil showShareSuccessAlert];
    [self sendEmail];
}

-(NSString *)getShareTitle
{
    return self.essence.title_;
}

-(NSString *)getShareUrl
{
    return self.essence.shareUrl_;
}


- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            //[msgbox release];
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            //[msgbox release];
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            //[msgbox release];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            //[msgbox release];
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            //[msgbox release];
            
            break;
        }
        default:
        {
            break;
        }
    }
    //[self processShareSuccess];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)onReq:(QQBaseReq *)req
{
    NSLog(@"过来了");

}
- (void)onResp:(QQBaseResp *)resp
{
    NSLog(@"过来了");
}
- (void)isOnlineResponse:(NSDictionary *)response
{
}
@end
