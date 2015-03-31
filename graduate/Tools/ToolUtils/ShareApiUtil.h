//
//  ShareApiUtil.h
//  graduate
//
//  Created by TracyLin on 15/3/18.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WBHttpRequest+WeiboUser.h"
#import "AppDelegate.h"
#import "WeiboUser.h"
#import "WXApi.h"
#import "WXApiObject.h"
@interface ShareApiUtil : NSObject
+(void)qqShare:(NSString *)title description:(NSString *)description imageUrl:(NSString *)imageUrl shareUrl:(NSString *)shareUrl from:(id)from;

+(void)weixinShare:(NSString *)title description:(NSString *)description imageUrl:(NSString *)imageUrl shareUrl:(NSString *)shareUrl scene:(int)scene;

+(void)weiboShare:(NSString *)title description:(NSString *)description imageUrl:(NSString *)imageUrl shareUrl:(NSString *)shareUrl;
+(void)showShareSuccessAlert;

@end
