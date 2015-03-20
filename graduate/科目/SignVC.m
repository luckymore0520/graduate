//
//  SignVC.m
//  graduate
//
//  Created by luck-mac on 15/2/4.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "SignVC.h"
#import "Sign.h"
#import "CoreDataHelper.h"
#import "MSign.h"
#import "MReturn.h"


@implementation SignVC

- (void)viewDidLoad
{
    NSArray* signList = [CoreDataHelper query:[NSPredicate predicateWithFormat:@"userid=%@",[ToolUtils getUserid]] tableName:@"Sign"];
    int days = signList.count+1;
    for (Sign* sign in signList) {
        if ([sign.myDay isEqualToString:[NSString stringWithFormat:@"%d", [ToolUtils getCurrentDay].integerValue]]) {
            [_signButton setTitle:@"回到主页" forState:UIControlStateNormal];
            days = days-1;
            break;
        }
    }
    [_dayLabel setText:[NSString stringWithFormat:@"%d天",days]];
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setImage:[UIImage imageNamed:@"返回主页"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *myAddButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = myAddButton;
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(processShareSuccess) name:@"shareSuccess" object:nil];
}

-(int)getSignDaysLocal
{
    NSArray* signList = [CoreDataHelper query:[NSPredicate predicateWithFormat:@"userid=%@",[ToolUtils getUserid]] tableName:@"Sign"];
    return (int)signList.count;
}

- (void)backToMain
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)onSignSuccess
{
    CoreDataHelper* helper = [CoreDataHelper getInstance];
    NSArray* signList = [CoreDataHelper query:[NSPredicate predicateWithFormat:@"userid=%@",[ToolUtils getUserid]] tableName:@"Sign"];
    for (Sign* sign in signList) {
        if ([sign.myDay isEqualToString:[NSString stringWithFormat:@"%d", [ToolUtils getCurrentDay].integerValue]]) {
            sign.reviewCount = [NSNumber numberWithInteger:sign.reviewCount.integerValue+self.reviewCount];
            NSError* error;
            [helper.managedObjectContext save:&error];
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
            }];
            return;
        }
    }
    Sign* sign = (Sign*)[NSEntityDescription insertNewObjectForEntityForName:@"Sign" inManagedObjectContext:helper.managedObjectContext];
    sign.subject = self.subject;
    sign.myDay = [NSString stringWithFormat:@"%d", [ToolUtils getCurrentDay].integerValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:[NSDate date]];
    sign.date = destDateString;
    sign.userid = [ToolUtils getUserid];
    sign.reviewCount = [NSNumber numberWithInteger:self.reviewCount];
    NSError* error;
    BOOL isSaveSuccess=[helper.managedObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error:%@",error);
    }else{
        [ToolUtils showMessage:@"打卡成功，现在去分享吧"];
          }
    self.sign = sign;
    [[[MSign alloc]init]load:self type:self.type subject:self.subject date:sign.date];
}
- (IBAction)sign:(id)sender {
    CoreDataHelper* helper = [CoreDataHelper getInstance];
    NSArray* signList = [CoreDataHelper query:[NSPredicate predicateWithFormat:@"userid=%@",[ToolUtils getUserid]] tableName:@"Sign"];
    for (Sign* sign in signList) {
        if ([sign.myDay isEqualToString:[NSString stringWithFormat:@"%d", [ToolUtils getCurrentDay].integerValue]]) {
            sign.reviewCount = [NSNumber numberWithInteger:sign.reviewCount.integerValue+self.reviewCount];
            NSError* error;
            [helper.managedObjectContext save:&error];
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
            return;
        }
    }
    [self onSignSuccess];
//    [self.maskBackView setHidden:NO];
//    [UIView animateWithDuration:0.3 animations:^{
//        self.shareView.transform = CGAffineTransformMakeTranslation(0, -self.shareView.frame.size.height);
//    }];
}

- (IBAction)cancelShare:(id)sender {
    [self hideShareView];
    
}

-(void)hideShareView
{
    [self.maskBackView setHidden:YES];
        [UIView animateWithDuration:0.3 animations:^{
        self.shareView.transform = CGAffineTransformMakeTranslation(0,0);
    }];
}
- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MSign"]) {
        MReturn* ret = [MReturn objectWithKeyValues:data];
        if (ret.code_.integerValue==1) {
            self.sign.isUpload = @YES;
            self.sharedUrl = ret.msg_;
            NSLog(@"%@",self.sharedUrl);
            NSError* error;
            [[CoreDataHelper getInstance].managedObjectContext save:&error];
            NSLog(@"打卡,同步服务器成功");
            [self.maskBackView setHidden:NO];
            [UIView animateWithDuration:0.3 animations:^{
                self.shareView.transform = CGAffineTransformMakeTranslation(0, -self.shareView.frame.size.height);
            }];
        }
    }
    
}
#pragma mark -sharebuttons

- (IBAction)qqShare:(UIButton *)sender {
    [ShareApiUtil qqShare:[self getShareTitle] description:[self getShareTitle] imageUrl:[BaseFuncVC getShareImgUrl] shareUrl:[self getShareUrl] from:self];
}

- (IBAction)friendsShare:(UIButton *)sender {
     [ShareApiUtil weixinShare:[self getShareTitle] description:[self getShareTitle] imageUrl:[BaseFuncVC getShareImgUrl] shareUrl:[self getShareUrl]scene:WXSceneTimeline];
}
- (IBAction)weixinShare:(UIButton *)sender {
    [ShareApiUtil weixinShare:[self getShareTitle] description:[self getShareTitle] imageUrl:[BaseFuncVC getShareImgUrl] shareUrl:[self getShareUrl]scene:WXSceneSession];
}

- (IBAction)weiboShare:(UIButton *)sender {
   [ShareApiUtil weiboShare:[self getShareTitle] description:[self getShareTitle] imageUrl:[BaseFuncVC getShareImgUrl] shareUrl:[self getShareUrl]];
}


-(void)processShareSuccess{
    [self hideShareView];
    [ShareApiUtil showShareSuccessAlert];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}

-(NSString *)getShareTitle
{
    return [NSString stringWithFormat:@"研大大打卡第%d天",[self getSignDaysLocal]];
}

-(NSString *)getShareUrl
{
    return self.sharedUrl;
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
}
- (void)onResp:(QQBaseResp *)resp
{
    NSLog(@"过来了");
}
- (void)isOnlineResponse:(NSDictionary *)response
{
}

@end
