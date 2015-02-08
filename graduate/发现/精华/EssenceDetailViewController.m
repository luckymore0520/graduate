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
@interface EssenceDetailViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *essenceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *essenceTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *essenceSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *essenceDownloadTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *essenceShowTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *essenceUploadLabel;
@property (weak, nonatomic) IBOutlet UIButton *essenceDownloadBt;
@property (weak, nonatomic) IBOutlet UIButton *essenceCollectButton;
@property (nonatomic,strong)MUser* user;
@property (nonatomic,strong)UITextField* editTextView;
@property (nonatomic,strong)UIView* editView;
@property (nonatomic,strong)UIAlertView* emailAlert;
@property (nonatomic,strong)UIAlertView* shareAlert;
@property (nonatomic,strong)NSArray* typeList;
@end

@implementation EssenceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _user = [MUser objectWithKeyValues:[ToolUtils getUserInfomation]];
    self.typeList = [NSArray arrayWithObjects:@"视频",@"音频",@"文档" ,nil];
    // Do any additional setup after loading the view.
    [self initView];
    [[[MEssenceDetail alloc]init]load:self id:self.essence.id_];
    if (_user.email_.length>0) {
        [self.essenceDownloadBt setTitle:[NSString stringWithFormat:@"下载至%@",_user.email_] forState:UIControlStateNormal];
    }
}


- (void)initView
{
    [self.essenceTitleLabel setText:self.essence.title_];
    [self.essenceTypeLabel setText:[self.typeList objectAtIndex:self.essence.resType_.integerValue]];
    [self.essenceUploadLabel setText:self.essence.source_];
    if (self.essence.resSize_) {
        [self.essenceSizeLabel setText:self.essence.resSize_];
    }
    if (self.essence.browseTimes_) {
        [self.essenceShowTimeLabel setText:[NSString stringWithFormat:@"%d次",self.essence.browseTimes_.integerValue]];
        
    }
    if (self.essence.downloadTimes_) {
         [self.essenceShowTimeLabel setText:[NSString stringWithFormat:@"%d次",self.essence.downloadTimes_.integerValue]];
    }
    if (self.essence.isCollected_.integerValue==1) {
        [self.essenceCollectButton setSelected:YES];
    }
}


- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MEssenceDownload"])
    {
        [ToolUtils showToast:@"已发送至您的邮箱" toView:self.view];
    } else if ([names isEqualToString:@"MEssenceDetail"])
    {
        self.essence = [MEssence objectWithKeyValues:data];
        [self initView];
    } else if ([names isEqualToString:@"MEssenceCollect"])
    {
        if (self.essenceCollectButton.selected) {
            [ToolUtils showToast:@"收藏成功" toView:self.view];

        } else {
            [ToolUtils showToast:@"已取消收藏" toView:self.view];

        }
    }
}
- (IBAction)collect:(id)sender {
    [[[MEssenceCollect alloc]init]load:self id:self.essence.id_ type:self.essenceCollectButton.selected?0:1];
    [self.essenceCollectButton setSelected:!self.essenceCollectButton.selected];
}
- (IBAction)share:(id)sender {
    
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
            [[[MEssenceDownload alloc]init]load:self id:self.essence.id_ resid:self.essence.resid_ email:_user.email_ isShared:@"1"];
        }
    }
    
}


- (void)editEmail
{
    if (!_editView) {
        CGRect frame = CGRectMake(0, SC_DEVICE_SIZE.height, SC_DEVICE_SIZE.width, 200);
        _editView = [[UIView alloc]initWithFrame:frame];
        [self.view addSubview:_editView];
        
        CGRect textFrame = CGRectMake(0, 50, SC_DEVICE_SIZE.width, 50);
        
        _editTextView = [[UITextField alloc]initWithFrame:textFrame];
        _editTextView.font = [UIFont systemFontOfSize:12];
        [_editView addSubview:_editTextView];
        
        
        
        
        CGRect leftBtFrame = CGRectMake(5, 0, 50, 50);
        UIButton* cancelButton = [[UIButton alloc]initWithFrame:leftBtFrame];
        [cancelButton addTarget:self action:@selector(cancelEdit) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton.titleLabel setTextColor:[UIColor blueColor]];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_editView addSubview:cancelButton];
        
        CGRect rightBtFrame = CGRectMake(SC_DEVICE_SIZE.width-55, 5, 50, 50);
        UIButton* saveButton = [[UIButton alloc]initWithFrame:rightBtFrame];
        [saveButton addTarget:self action:@selector(saveEmail) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_editView addSubview:saveButton];
    }
    self.editTextView.placeholder = @"请设置您的电子邮箱，以便接收下载的资料";
    [self.editView setBackgroundColor:[UIColor whiteColor]];
    [self.editTextView becomeFirstResponder];
    CGRect frame = _editView.frame;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        NSLog(@"%lf",-frame.size.height-(keyboardHeight==0?240:keyboardHeight));
        self.editView.transform = CGAffineTransformMakeTranslation(0, -frame.size.height-(keyboardHeight==0?240:keyboardHeight));
    } completion:^(BOOL finished) {
    }];
    
}


- (void) keyboardWasHidden:(NSNotification *) notif
{
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
