//
//  LoginVC.h
//  graduate
//
//  Created by luck-mac on 15/1/18.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "ToolUtils.h"
@interface LoginVC : UIViewController<TencentSessionDelegate>
{
    TencentOAuth* _tencentOAuth;
    NSMutableArray* permissions;
    
}
@end
