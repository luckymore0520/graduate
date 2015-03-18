//
//  AppDelegate.h
//  graduate
//
//  Created by luck-mac on 15/1/16.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"
#import "QuestionBook.h"
#import "MediaPlayController.h"
#import "ThirdPartyCallBackDelegate.h"
#define WEIBOAPPKEY @"77238273"

#define KREDIRECTURL @"https://api.weibo.com/oauth2/default.html"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong,nonatomic)MediaPlayController* mediaPlayController;
@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic)QuestionBook* book;
@end

