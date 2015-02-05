//
//  LoginVC.m
//  graduate
//
//  Created by luck-mac on 15/1/18.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "LoginVC.h"
#import "RootViewController.h"
#import "MLogin.h"
#import "MUser.h"
#import "MImgUpload.h"
#import "MUpdateUserInfo.h"
#import "MReturn.h"
#import "WBHttpRequest+WeiboUser.h"
#import "AppDelegate.h"
#import "WeiboUser.h"
@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginBt;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
//@property (nonatomic,strong)CCPCallService* ccpService;
@end

@implementation LoginVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isThirdParty = NO;
    self.textFields = [NSArray arrayWithObjects:_passwordField,_usernameField,nil];
    self.keyButtons = [NSArray arrayWithObjects:_loginBt, nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(handleWeiboLogin) name:@"weiboLogin" object:nil];
    [self.navigationController setNavigationBarHidden:YES];
      // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initTencent];
    if ([ToolUtils getHasLogin]) {
        [self gotoMainMenu];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)handleWeiboLogin
{
    MLogin* login = [[MLogin alloc]init];
    isThirdParty = YES;
    [login load:self phone:nil account:nil password:nil qqAcount:nil wxAccount:nil wbAccount:[ToolUtils getIdentify]];
    [WBHttpRequest requestForUserProfile:[ToolUtils getIdentify] withAccessToken:[ToolUtils getToken] andOtherProperties:[NSDictionary dictionaryWithObjectsAndKeys:@"77238273", @"source",[ToolUtils getToken],@"access_token",nil] queue:[[NSOperationQueue alloc]init] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        NSLog(@"获取成功");
        WeiboUser* user = (WeiboUser*)result;
        ApiHelper* api = [[ApiHelper alloc]init];
        api.fileId =user.avatarHDUrl;
        [ToolUtils setIgnoreNetwork:YES];
        [api download:self url:user.avatarHDUrl];
        [ToolUtils setIgnoreNetwork:NO];
        isThirdParty = YES;
        [ToolUtils setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:user.gender,@"gender",user.name,@"nickname", nil]];
    }];
    
   
}//前往主界面
- (void)gotoMainMenu
{
    
    UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"Func" bundle:nil];
    RootViewController* _rootVC =(RootViewController*)[myStoryBoard instantiateViewControllerWithIdentifier:@"root"];
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:_rootVC];
    [nav setNavigationBarHidden:YES];
    [self.navigationController presentViewController:nav animated:YES completion:^{
    }];
    [ToolUtils setHasLogin:YES];
}


//初始化腾讯第三方登陆
- (void) initTencent
{
    if (!_tencentOAuth) {
        _tencentOAuth = [[TencentOAuth alloc]initWithAppId:@"222222" andDelegate:self];
    }
}


#pragma mark buttonAction
- (IBAction)login:(id)sender {
    permissions = [[NSMutableArray alloc]initWithObjects:kOPEN_PERMISSION_GET_USER_INFO,kOPEN_PERMISSION_GET_INFO,   nil];
    [_tencentOAuth authorize:permissions inSafari:NO];
    
    
    
    [_tencentOAuth logout:self];
}
- (IBAction)weiboLogin:(id)sender {
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = KREDIRECTURL;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"LoginVC",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (IBAction)normalLogin:(id)sender {
    if (_usernameField.text.length==0) {
        [ToolUtils showMessage:@"请输入登录号或者手机号"];
    } else if (_passwordField.text.length==0)
    {
        [ToolUtils showMessage:@"密码不得为空"];
    } else {
        isThirdParty = NO;
        MLogin* login = [[MLogin alloc]init];
        NSString* password = [ToolUtils md5:_passwordField.text];
        if ([ToolUtils checkTel:_usernameField.text showAlert:NO]) {
            [login load:self phone:_usernameField.text account:nil password:password qqAcount:nil wxAccount:nil wbAccount:nil];
        } else {
            [login load:self phone:nil account:_usernameField.text password:password qqAcount:nil wxAccount:nil wbAccount:nil];
        }
    }
    
}
- (IBAction)register:(id)sender {
    [self performSegueWithIdentifier:@"register" sender:@"regist"];
}

- (IBAction)forgetPassword:(id)sender {
    [self performSegueWithIdentifier:@"register" sender:@"forget"];
}

#pragma mark -ApiDelegate
- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MLogin"]) {
        MUser* user = [MUser objectWithKeyValues:data];
        [ToolUtils setUserInfomation:user.keyValues];
        if (!isThirdParty) {
            [self gotoMainMenu];
        }
//        [self gotoMainMenu];
    } else if ([names isEqualToString:@"MImgUpload"]) {
        MReturn* ret = [MReturn objectWithKeyValues:data];
        NSLog(@"%@",ret.msg_);
        if (ret.code_.integerValue==1) {
            NSDictionary* userinfo = [ToolUtils getUserInfo];
            MUpdateUserInfo* updateUserInfo = [[MUpdateUserInfo alloc]init];
            [updateUserInfo load:self nickname:[userinfo objectForKey:@"nickname"] headImg:ret.msg_ sex:[[userinfo objectForKey:@"gender"]isEqualToString:@"男"]?0:1 email:nil];
            
            
        } else {
            [self gotoMainMenu];
        }
        
    } else if ([names isEqualToString:@"download"])
    {
        
        NSURL* url = [data objectForKey:@"path"];
        NSData* img = [NSData dataWithContentsOfURL:url];
        MImgUpload* upLoad = [[MImgUpload alloc]init];
        [ToolUtils setIgnoreNetwork:YES];
        [upLoad load:self img:[UIImage imageWithData:img] name:[NSString stringWithFormat:@"%@.png",[ToolUtils getIdentify]]];
        [ToolUtils setIgnoreNetwork:NO];
        
    } else if ([names isEqualToString:@"MUpdateUserInfo"])
    {
        NSDictionary* userinfo = [ToolUtils getUserInfo];
        MUser* user = [MUser objectWithKeyValues:[ToolUtils getUserInfomation]];
        user.nickname_ = [userinfo objectForKey:@"username"];;
        user.sex_ = [NSNumber numberWithInt:[[userinfo objectForKey:@"gender"]isEqualToString:@"男"]?0:1];
        MReturn* ret = [MReturn objectWithKeyValues:data];
        [self gotoMainMenu];
    }
}


#pragma mark -QQ登陆
- (void)tencentDidUpdate:(TencentOAuth *)tencentOAuth
{
    NSLog(@"Update");
}
- (void)tencentDidNotNetWork
{
    
    NSLog(@"DidNotNetWork");
}


- (void)tencentDidLogin
{
    NSLog(@"Success");      NSLog(@"%@",[_tencentOAuth openId]);
    NSLog(@"%@",[_tencentOAuth accessToken]);
    [ToolUtils setIdentify:[_tencentOAuth openId]];
    if ([_tencentOAuth getUserInfo]) {
        NSLog(@"正在获取用户数据");
    } else {
        NSLog(@"授权过期");
    }
}

- (void)getUserInfoResponse:(APIResponse *)response
{
    NSDictionary* userInfo =response.jsonResponse;
    NSLog(@"%@",[userInfo objectForKey:@"nickname"]) ;
    [ToolUtils setUserInfo:userInfo];
    MLogin* login = [[MLogin alloc]init];
    [login load:self phone:nil account:nil password:nil qqAcount:[ToolUtils getIdentify] wxAccount:nil wbAccount:nil];
    if (userInfo) {
        NSLog(@"%@",[userInfo objectForKey:@"figureurl_qq_1"]);
        ApiHelper* api = [[ApiHelper alloc]init];
        api.fileId =[userInfo objectForKey:@"figureurl_qq_1"];
        [ToolUtils setIgnoreNetwork:YES];
        [api download:self url:[userInfo objectForKey:@"figureurl_qq_1"]];
        [ToolUtils setIgnoreNetwork:NO];
        isThirdParty = YES;
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    NSLog(@"Fail");

}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"register"]) {
        
    }
}

@end
