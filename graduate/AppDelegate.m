//
//  AppDelegate.m
//  graduate
//
//  Created by luck-mac on 15/1/16.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "AppDelegate.h"
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "SubjectVC.h"
#import "MainFunVC.h"
#import "RootViewController.h"
#import "ToolUtils.h"
#import "QuestionBook.h"
#import "MediaPlayVC.h"
#import "WXApi.h"
#import "APService.h"
#import "MobClick.h"
#import "Trace.h"
#import "MFootprint.h"
#import "MMainList.h"
#import "WKNavigationViewController.h"
#import "LoginVC.h"
#import "EssenceDetailViewController.h"
@interface AppDelegate ()<WeiboSDKDelegate,WXApiDelegate,QQApiInterfaceDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initDeviceid];
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if (![ToolUtils getFirstUse]) {
        UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"Func" bundle:nil];
        MediaPlayVC* _rootVC = (MediaPlayVC*)[myStoryBoard instantiateViewControllerWithIdentifier:@"media"];
        WKNavigationViewController* unv = [[WKNavigationViewController alloc]initWithRootViewController:_rootVC];
        [unv setNavigationBarHidden:YES];
        [_window setRootViewController:unv];
        [ToolUtils setFirstUse:@"NO"];
    } else if ([ToolUtils getHasLogin]){
        UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"Func" bundle:nil];
        RootViewController* _rootVC =(RootViewController*)[myStoryBoard instantiateViewControllerWithIdentifier:@"root"];
        [_window setRootViewController:_rootVC];
    } else {
        UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"User" bundle:nil];
        LoginVC* _rootVC = (LoginVC*)[myStoryBoard instantiateViewControllerWithIdentifier:@"login"];
        WKNavigationViewController* nav = [[WKNavigationViewController alloc]initWithRootViewController:_rootVC];
        [nav setNavigationBarHidden:YES];
        [_window setRootViewController:nav];
    }
    [_window makeKeyAndVisible];
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:[ToolUtils weiboAppid]];
    

    [WXApi registerApp:[ToolUtils weixinAppkey] withDescription:@"研大大"];
    [self initJPush:launchOptions];
    [self initUmen];
    
    
    self.mediaPlayController = [MediaPlayController getInstance];
    self.book = [QuestionBook getInstance];
    [_book loadAllData];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    return YES;
}


- (void)initUmen
{
    [MobClick startWithAppkey:@"54d46cc0fd98c574ef000420" reportPolicy:BATCH   channelId:@"App Store"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
        
}

- (void) initJPush:(NSDictionary*) launchOptions
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
}


#pragma mark getDeviceId
- (void)initDeviceid
{
    //获取deviceid，7以上使用udid，以下使用macaddress
    NSString *sysVersion = [UIDevice currentDevice].systemVersion;
    CGFloat version = [sysVersion floatValue];
    
    NSString *deviceid = @"";
    if (version >= 7.0) {
        deviceid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    else if (version >= 2.0) {
        deviceid =  [self getMacAddress];
    }
    [ToolUtils setDeviceId:deviceid];
}



- (NSString *)getMacAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        NSLog(@"Error: %@", errorFlag);
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    NSLog(@"Mac Address: %@", macAddressString);
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ENTERFOREGROUND" object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSInteger badge = application.applicationIconBadgeNumber;
    if (badge > 0) {
        badge = 0;
        [application setApplicationIconBadgeNumber:badge];
    }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    NSLog(@"source application:%@",sourceApplication);
    NSLog(@"urls:%@",url.absoluteString);
    if ([sourceApplication isEqualToString:@"com.tencent.mqq"]) {
        //[QQApiInterface handleOpenURL:url delegate:(id)[EssenceDetailViewController class]];
        return [TencentOAuth HandleOpenURL:url];
    } else if ([sourceApplication isEqualToString:@"com.sina.weibo"]){
        return [WeiboSDK handleOpenURL:url delegate:self];
    } else
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{

   // [QQApiInterface handleOpenURL:url delegate:(id)[EssenceDetailViewController class]];
    return [TencentOAuth HandleOpenURL:url] || [WXApi handleOpenURL:url delegate:self]|| [WeiboSDK handleOpenURL:url delegate:self];
//    if (YES == [TencentOAuth CanHandleOpenURL:url])
//    {
//        return [TencentOAuth HandleOpenURL:url];
//    }
//    return YES;

//    return YES;
}

//微博回调
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString* weiboId = [(WBAuthorizeResponse *)response userID];
        if (!weiboId) {
            return;
        }
        [ToolUtils setIdentify:weiboId];
        [ToolUtils setToken:[(WBAuthorizeResponse *)response accessToken]];
        
        NSLog(@"%@ Token---%@",[ToolUtils getToken],weiboId);
        [ToolUtils setUserInfo:nil];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"weiboLogin" object:nil];
    }else if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        if(response.statusCode == 0){
            [[NSNotificationCenter defaultCenter]postNotificationName:@"shareSuccess" object:nil];
        }    }

}

//微信回调
-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *temp = (SendAuthResp*)resp;
        NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
        //NSString *strMsg = [NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", temp.copy, temp.state, temp.errCode];
        if (temp.errCode== 0) {
            NSString *code = temp.code;
            NSLog(@"code%@",code);
            [ToolUtils setWeixinCode:temp.code];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"weixinLogin" object:nil];
        }
    }else if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if(resp.errCode == 0){
            [[NSNotificationCenter defaultCenter]postNotificationName:@"shareSuccess" object:nil];
        }
        
    }
}

-(void)onRespQQ:(QQBaseResp *)resp
{
    NSLog(@"dd0-0-0-0------d");
}



@end
