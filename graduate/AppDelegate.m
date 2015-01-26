//
//  AppDelegate.m
//  graduate
//
//  Created by luck-mac on 15/1/16.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "AppDelegate.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "SubjectVC.h"
#import "MainFunVC.h"
#import "RootViewController.h"
#import "OtherViewController.h"
#import "ToolUtils.h"
#import "MediaPlayVC.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    #warning Change Storyboard for dev test
    
//    UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"Func" bundle:nil];
    
    UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"Other" bundle:nil];
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    MediaPlayVC* _rootVC = (MediaPlayVC*)[myStoryBoard instantiateViewControllerWithIdentifier:@"media"];
//    RootViewController* _rootVC =(RootViewController*)[myStoryBoard instantiateViewControllerWithIdentifier:@"root"];
//    [_window setRootViewController:_rootVC];

    OtherViewController* _otherVC = (OtherViewController*) [myStoryBoard instantiateViewControllerWithIdentifier:@"ChatCenter"];
    [_window setRootViewController:_otherVC];
    
//    if (![ToolUtils getFirstUse])
//    {
//        SubjectVC* _rootVC = (SubjectVC*)[myStoryBoard instantiateViewControllerWithIdentifier:@"Subject"];
//        [_window setRootViewController:_rootVC];
//
//    } else {
//        MainFunVC* _rootVC = (MainFunVC*)[myStoryBoard instantiateViewControllerWithIdentifier:@"MainFun"];
//        [_window setRootViewController:_rootVC];
//
//    }
    [_window makeKeyAndVisible];
    return YES;
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
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [TencentOAuth HandleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [TencentOAuth HandleOpenURL:url];
}
@end
