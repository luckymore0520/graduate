//
//  LoginVC.m
//  graduate
//
//  Created by luck-mac on 15/1/18.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "LoginVC.h"
#import "RegistVC.h"
#import "RootViewController.h"
#import "MLogin.h"
#import "MUser.h"
#import "MImgUpload.h"
#import "MUpdateUserInfo.h"
#import "MReturn.h"
#import "WBHttpRequest+WeiboUser.h"
#import "AppDelegate.h"
#import "WeiboUser.h"
#import "WKNavigationViewController.h"
#import "WXApi.h"
#import "ToolUtils.h"

@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UIView *usernameView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIButton *forgetBt;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginBt;
@property (weak, nonatomic) IBOutlet UIButton *registBt;
@property (weak, nonatomic) IBOutlet UIButton *qqBt;

@property (weak, nonatomic) IBOutlet UIButton *weiboBt;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
//@property (nonatomic,strong)CCPCallService* ccpService;
@property (weak, nonatomic) IBOutlet UIButton *weixinBt;
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
    [self setTitle:@"登陆页"];
    isThirdParty = NO;
    [self.navigationController setNavigationBarHidden:YES];
    [_passwordField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_usernameField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"忘记密码？"]];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    [content addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:16] range:contentRange];
    [self.forgetBt.titleLabel setAttributedText:content];
    self.textFields = [NSArray arrayWithObjects:_passwordField,_usernameField,nil];
    self.keyButtons = [NSArray arrayWithObjects:_loginBt, nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(handleWeiboLogin) name:@"weiboLogin" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(handleWeixinLogin) name:@"weixinLogin" object:nil];
    
         // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initTencent];
    [self.navigationController setNavigationBarHidden:YES];
    [self.waitingView setHidden:YES];
    [self.maskView setHidden:YES];
    
}

- (void)initViews
{
    CGFloat height = [[UIScreen mainScreen]bounds].size.height;
    [super initViews];
    if (height<500) {
        self.usernameView.transform
        = CGAffineTransformMake(self.scale, 0, 0, self.scale, 0, -30);
        self.passwordView.transform
        = CGAffineTransformMake(self.scale, 0, 0, self.scale, 0, -40);
        self.loginBt.transform
        = CGAffineTransformMake(self.scale, 0, 0, self.scale, 0, -50);
        self.registBt.transform
        = CGAffineTransformMake(self.scale, 0, 0, self.scale, 0, -60);
        self.forgetBt.transform = CGAffineTransformMake(self.scale, 0, 0, self.scale, -10, -100);

    }
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([ToolUtils getHasLogin]) {
        [self gotoMainMenu];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//前往主界面
- (void)gotoMainMenu
{
    [self waitingEnd];
    [self.waitingView setHidden:YES];
    [self.maskView setHidden:YES];
    [ToolUtils setHasLogin:YES];
    UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"Func" bundle:nil];
    RootViewController* _rootVC =(RootViewController*)[myStoryBoard instantiateViewControllerWithIdentifier:@"root"];
    [self.navigationController presentViewController:_rootVC animated:YES completion:^{
        [self waitingEnd];
    }];
}


//初始化腾讯第三方登陆
- (void) initTencent
{
    if (!_tencentOAuth) {
        _tencentOAuth = [[TencentOAuth alloc]initWithAppId:[ToolUtils qqAppid] andDelegate:self];
    }else{
        NSLog(@"出试试的数据:  %@-----%@",[_tencentOAuth accessToken],[_tencentOAuth openId]);
    }
}


#pragma mark buttonAction
- (IBAction)login:(id)sender {
    permissions = [[NSMutableArray alloc]initWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t",  nil];
    [_tencentOAuth authorize:permissions inSafari:NO];
    //[_tencentOAuth logout:self];
}



- (IBAction)weixinLogin:(id)sender {
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"; // @"post_timeline,sns"
    req.state = @"xxx";
    req.openID = @"0c806938e2413ce73eef92cc3";
    [WXApi sendAuthReq:req viewController:self delegate:[[UIApplication sharedApplication]delegate]];
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
        //清除第三方登录的一些信息
        [ToolUtils setHeadImgLocal:@""];
        [ToolUtils setThirdParyType:@""];
        [self waiting:@"正在登陆..."];
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
        NSLog(@"%@",user);
        [ToolUtils setUserInfomation:user.keyValues];
        //设置几个默认信息
        [ToolUtils setDiaryDefault:user.diaryDefault_];
        [ToolUtils setAboutUrl:user.aboutusUrl_];
        [ToolUtils setContactUrl:user.contactUrl_];
        [[QuestionBook getInstance] loadAllData];
        [self gotoMainMenu];
        //如果是第三方登录并且当前用户没头像，那么就重传头像
        if (isThirdParty && ![user.headImg_ length]) {
            NSURL* url = [NSURL URLWithString:[ToolUtils getHeadImgLocal]];
//           NSLog(@"url %@",url.absoluteString);
             NSData* img = [NSData dataWithContentsOfURL:url];
//            NSLog(@"Length of data; %d",[img length]);
            MImgUpload* upLoad = [[MImgUpload alloc]init];
            [ToolUtils setIgnoreNetwork:YES];
            [upLoad load:self img:[UIImage imageWithData:img] name:[NSString stringWithFormat:@"%@.png",[ToolUtils getIdentify]]];
             NSDictionary *userInfoFromThird = [ToolUtils getUserInfo];
             user.nickname_ = [userInfoFromThird objectForKey:@"nickname"];
             user.sex_ = [NSNumber numberWithInt:([[userInfoFromThird objectForKey:@"gender"]isEqualToString:@"男"]? 0 : 1)];
            [ToolUtils setUserInfomation:[user keyValues]];
            [ToolUtils setIgnoreNetwork:NO];
        }else{
            [ToolUtils setHeadImgLocal:@""];
             NSDictionary *userInfoFromThird = [ToolUtils getUserInfo];
             if(isThirdParty){
                 user.sex_ = [NSNumber numberWithInt:([[userInfoFromThird objectForKey:@"gender"]
                                                      isEqualToString:@"男"]? 0 : 1)];
             }
            if(![user.nickname_ length]){
                user.nickname_ = [userInfoFromThird objectForKey:@"nickname"];
            }
            [ToolUtils setUserInfomation:[user keyValues]];
            MUpdateUserInfo* updateUserInfo = [[MUpdateUserInfo alloc]init];
            [updateUserInfo load:self nickname:user.nickname_ headImg:user.headImg_  sex:user.sex_.integerValue email:nil];
        }
      } else if ([names isEqualToString:@"MImgUpload"]) {
        //头像重传成功，则更改个人信息并同步服务器
        MReturn* ret = [MReturn objectWithKeyValues:data];
        if (ret.code_.integerValue==1) {
            //首先取出第三方登录获得的昵称和头像
            NSDictionary *userInfoFromThird = [ToolUtils getUserInfo];
//            NSLog(@"%@return msg",ret.msg_);
            NSDictionary *userInfo = [ToolUtils getUserInfomation];
//            NSLog(@"%@sdds0-----",userInfo);
            MUser *user = [MUser objectWithKeyValues:userInfo];
            user.headImg_ = ret.msg_;
            user.nickname_ = [userInfoFromThird objectForKey:@"nickname"];
            user.sex_ = [NSNumber numberWithInt:([[userInfoFromThird objectForKey:@"gender"]
            isEqualToString:@"男"]? 0 : 1)];
            [ToolUtils setUserInfomation:[user keyValues]];
            MUpdateUserInfo* updateUserInfo = [[MUpdateUserInfo alloc]init];
            [updateUserInfo load:self nickname:user.nickname_ headImg:ret.msg_  sex:user.sex_.integerValue email:nil];
        } else {
            //[self gotoMainMenu];
        }
    } else if ([names isEqualToString:@"download"])
    {
        //先把本地头像存一下
        [ToolUtils setHeadImgLocal:[NSString stringWithFormat:@"%@",[data objectForKey:@"path"]]];
        //需要根据不同的第三方登录类型判定
        MLogin* login = [[MLogin alloc]init];
        if([[ToolUtils getThirdParyType] isEqualToString:@"qq"]){
            [login load:self phone:nil account:nil password:nil qqAcount:[ToolUtils getIdentify] wxAccount:nil wbAccount:nil];
        }else if([[ToolUtils getThirdParyType] isEqualToString:@"weixin"]){
            [login load:self phone:nil account:nil password:nil qqAcount:nil wxAccount:[ToolUtils getIdentify] wbAccount:nil];
        }else{
            [login load:self phone:nil account:nil password:nil qqAcount:nil wxAccount:nil wbAccount:[ToolUtils getIdentify]];
        }

    } else if ([names isEqualToString:@"MUpdateUserInfo"])
    {
        NSDictionary* userinfo = [ToolUtils getUserInfo];
//        NSLog(@"用户昵称等%@",userinfo);
    }
}

- (void)showAlert:(NSString *)alert functionName:(NSString *)names
{
    [self waitingEnd];
    if ([names isEqualToString:@"MLogin"]) {
        [ToolUtils showMessage:@"请输入正确的用户名密码" title:@"用户名密码不正确"];
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
    NSLog(@"Success");
    //NSLog(@"%@",[_tencentOAuth openId]);
    //NSLog(@"%@",[_tencentOAuth accessToken]);
    [ToolUtils setIdentify:[_tencentOAuth openId]];
    [self waiting:@"Loading"];
    if ([_tencentOAuth getUserInfo]) {
        NSLog(@"正在获取用户数据");
    } else {
        NSLog(@"授权过期");
        [self waitingEnd];
        [self.waitingView setHidden:YES];
        [self.maskView setHidden:YES];
        [ToolUtils showMessage:@"请尝试其他方式登录" title:@"登录失败"];
    }
}


#pragma mark -loginHandler

- (void)handleWeiboLogin
{
    MLogin* login = [[MLogin alloc]init];
    isThirdParty = YES;
//    [login load:self phone:nil account:nil password:nil qqAcount:nil wxAccount:nil wbAccount:[ToolUtils getIdentify]];
    [self waiting:@"正在获取个人信息"];
    [WBHttpRequest requestForUserProfile:[ToolUtils getIdentify] withAccessToken:[ToolUtils getToken] andOtherProperties:[NSDictionary dictionaryWithObjectsAndKeys:[ToolUtils weiboAppid], @"source",[ToolUtils getToken],@"access_token",nil] queue:[[NSOperationQueue alloc]init] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        NSLog(@"erro is %@", error);
//      [self waitingEnd];
        NSLog(@"获取成功");
        WeiboUser* user = (WeiboUser*)result;
        if(user) {
            ApiHelper* api = [[ApiHelper alloc]init];
            api.fileId =user.avatarHDUrl;
            [ToolUtils setIgnoreNetwork:YES];
            [api download:self url:user.avatarHDUrl];
            [ToolUtils setIgnoreNetwork:NO];
            isThirdParty = YES;
            [ToolUtils setThirdParyType:@"weibo"];
            [ToolUtils setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:user.gender,@"gender",user.name,@"nickname", nil]];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
            [self waitingEnd];
            [self.waitingView setHidden:YES];
            [self.maskView setHidden:YES];
            [ToolUtils showMessage:@"请尝试其他方式登录" title:@"微博授权失败"];
            });
        }
        
    }];
    
    
}

- (void)handleWeixinLogin
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",[ToolUtils weixinAppkey],[ToolUtils weixinSecretKey],[ToolUtils getWeixinCode]];
    //NSLog(@"%@",url);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        //NSLog(@"%@",zoneStr);
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *token = [dic objectForKey:@"access_token"];
                NSString *openid = [dic objectForKey:@"openid"];
                [ToolUtils setIdentify:openid];
                [ToolUtils setToken:token];
                [self getWeixinUserInfo];
            }
        });
    });
}
                       
-(void)getWeixinUserInfo
{
    //获取个人信息
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",[ToolUtils getToken],[ToolUtils getIdentify]];
    [self waiting:@"正在获取个人信息"];
    NSURL *zoneUrl = [NSURL URLWithString:url];
    NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
//    MLogin* login = [[MLogin alloc]init];
    isThirdParty = YES;
//    [login load:self phone:nil account:nil password:nil qqAcount:nil wxAccount:[ToolUtils getIdentify] wbAccount:nil];
    if (data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        ApiHelper* api = [[ApiHelper alloc]init];
        api.fileId = [dic objectForKey:@"headimgurl"];
        NSLog(@"%@",api.fileId);
        [ToolUtils setIgnoreNetwork:YES];
        [api download:self url:[dic objectForKey:@"headimgurl"]];
        //[self waitingEnd];
        [ToolUtils setIgnoreNetwork:NO];
        isThirdParty = YES;
        [ToolUtils setThirdParyType:@"weixin"];
//        NSLog(@"nickname---%@",[dic objectForKey:@"nickname"]);
        [ToolUtils setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:((NSNumber*)[dic objectForKey:@"sex"]).integerValue==1 ? @"男" : @"女",@"gender",[dic objectForKey:@"nickname"],@"nickname", nil]];
    }
}

- (void)getUserInfoResponse:(APIResponse *)response
{
    NSDictionary* userInfo =response.jsonResponse;
//    NSLog(@"%@",userInfo);
//    NSLog(@"%@",[userInfo objectForKey:@"nickname"]);
//    NSLog(@"%@",userInfo);
//    NSLog(@"sex of %@",[(NSNumber*)[userInfo objectForKey:@"sex"] intValue]==1? @"yes":@"no");
    [ToolUtils setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:[userInfo objectForKey:@"gender"],@"gender",[userInfo objectForKey:@"nickname"],@"nickname",@"",@"headImg", nil]];
    if (userInfo) {
        NSLog(@"%@",[userInfo objectForKey:@"figureurl_qq_1"]);
        ApiHelper* api = [[ApiHelper alloc]init];
        api.fileId =[userInfo objectForKey:@"figureurl_qq_1"];
        [ToolUtils setIgnoreNetwork:YES];
        [api download:self url:[userInfo objectForKey:@"figureurl_qq_1"]];
        [ToolUtils setIgnoreNetwork:NO];
        isThirdParty = YES;
        [ToolUtils setThirdParyType:@"qq"];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self waitingEnd];
            [self.waitingView setHidden:YES];
            [self.maskView setHidden:YES];
            [ToolUtils showMessage:@"请重新登录" title:@"QQ授权失败"];
        });
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
        NSString* string = (NSString*)sender;
        RegistVC* nextVC = (RegistVC*)[segue destinationViewController];
        if ([string isEqualToString:@"forget"]) {
            nextVC.type = FORGET;
        } else {
            nextVC.type = REGIST;

        }
    }
}

#pragma mark -textfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==self.usernameField) {
        [self.passwordField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        [self normalLogin:nil];
        [self animationReturn];
    }
    return YES;
}

//增加遮罩按钮，点击键盘弹回
- (void)addMaskBt
{
    if (self.maskBt) {
        [self.maskBt setHidden:YES];
        [self.maskBt removeFromSuperview];
    }
    self.maskBt = [[UIButton alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.maskBt];
    [self.maskBt addTarget:self action:@selector(resignAll) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:self.passwordView];
    [self.view bringSubviewToFront:self.usernameView];
    for (UIButton* button in self.keyButtons) {
        [self.view bringSubviewToFront:button];
    }
}


#pragma mark -textFieldDelegate
//开始编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGRect frame;
    frame= _loginBt.frame;
    int offset = frame.origin.y - (self.view.frame.size.height - MAX(keyboardHeight, 240));//键盘高度216
    NSLog(@"offset is %d",offset);
    if (textField.inputAccessoryView) {
        offset = offset+ textField.inputAccessoryView.frame.size.height;
    }
    NSTimeInterval animationDuration = 0.30f;
    if (offset>0) {
        [UIView animateWithDuration:animationDuration animations:^{
            self.view.transform = CGAffineTransformMake(self.scale, 0, 0, self.scale, 0.0, -offset);
        }];
    }
    [self addMaskBt];
    
    return YES;
}

@end
