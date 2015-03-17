//
//  EssenceDetailViewController.h
//  graduate
//
//  Created by luck-mac on 15/2/6.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "BaseFuncVC.h"
#import "MEssence.h"
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WBHttpRequest+WeiboUser.h"
#import "AppDelegate.h"
#import "WeiboUser.h"
#import "WXApi.h"
#import "WXApiObject.h"
@interface EssenceDetailViewController : BaseFuncVC
@property (nonatomic,strong)MEssence* essence;
- (void)addRightButton;

@end
