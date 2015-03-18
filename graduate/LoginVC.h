//
//  LoginVC.h
//  graduate
//
//  Created by luck-mac on 15/1/18.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "BaseFuncVC.h"
@interface LoginVC : BaseFuncVC<TencentSessionDelegate>
{
    BOOL isThirdParty;
    TencentOAuth *_tencentOAuth;
    NSMutableArray* permissions;
}
@end
