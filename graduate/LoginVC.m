//
//  LoginVC.m
//  graduate
//
//  Created by luck-mac on 15/1/18.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "LoginVC.h"
#import "RootViewController.h"

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
    self.textFields = [NSArray arrayWithObjects:_passwordField,_usernameField,nil];
    self.keyButtons = [NSArray arrayWithObjects:_loginBt, nil];
      // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initTencent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//前往主界面
- (void)gotoMainMenu
{
    UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"Func" bundle:nil];
    RootViewController* _rootVC =(RootViewController*)[myStoryBoard instantiateViewControllerWithIdentifier:@"root"];
    [self.navigationController presentViewController:_rootVC animated:YES completion:^{
    }];
}


//初始化腾讯第三方登陆
- (void) initTencent
{
    _tencentOAuth = [[TencentOAuth alloc]initWithAppId:@"222222" andDelegate:self];
}


#pragma mark buttonAction
- (IBAction)login:(id)sender {
    permissions = [[NSMutableArray alloc]initWithObjects:kOPEN_PERMISSION_GET_USER_INFO,kOPEN_PERMISSION_GET_INFO,   nil];
    [_tencentOAuth authorize:permissions inSafari:NO];
}

- (IBAction)normalLogin:(id)sender {
    if (_usernameField.text.length==0) {
        [ToolUtils showMessage:@"请输入登录号或者手机号"];
    } else if (_passwordField.text.length==0)
    {
        [ToolUtils showMessage:@"密码不得为空"];
    } else {
        [self gotoMainMenu];

    }
#warning 此处调用登录接口
    
    
}
- (IBAction)register:(id)sender {
    [self performSegueWithIdentifier:@"register" sender:@"regist"];
}

- (IBAction)forgetPassword:(id)sender {
    [self performSegueWithIdentifier:@"register" sender:@"forget"];
}




#pragma mark -QQ登陆
- (void)tencentDidNotNetWork
{
    
    NSLog(@"DidNotNetWork");
}

- (void)tencentDidLogin
{
    NSLog(@"Success");
    NSLog(@"%@",[_tencentOAuth openId]);
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
    [self gotoMainMenu];
#warning 此处需要根据openId和用户信息进行注册
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
