//
//  LoginVC.m
//  graduate
//
//  Created by luck-mac on 15/1/18.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "LoginVC.h"
#import "MainFunVC.h"
@interface LoginVC ()
//@property (nonatomic,strong)CCPCallService* ccpService;
@end

@implementation LoginVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTencent];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{

}
- (void) initTencent
{
    _tencentOAuth = [[TencentOAuth alloc]initWithAppId:@"222222" andDelegate:self];
}
- (IBAction)login:(id)sender {
    permissions = [[NSMutableArray alloc]initWithObjects:kOPEN_PERMISSION_GET_USER_INFO,kOPEN_PERMISSION_GET_INFO,   nil];
    [_tencentOAuth authorize:permissions inSafari:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"Func" bundle:nil];
    MainFunVC* _rootVC = (MainFunVC*)[myStoryBoard instantiateViewControllerWithIdentifier:@"MainFun"];
    [self.navigationController presentViewController:_rootVC animated:YES completion:^{
    }];

}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    NSLog(@"Fail");

}

- (void)reveiveData:(NSDictionary *)data method:(NSString *)method
{
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
