//
//  MLogin.h
//  graduate
//
//  Created by luck-mac on 15/1/29.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "ApiHelper.h"

@interface MLogin : ApiHelper
- (ApiHelper *)load:(id<ApiDelegate>)delegate phone:(NSString *)phone account:(NSString*)account password:(NSString*)password
           qqAcount:(NSString*)qqAccount wxAccount:(NSString*)wxAccount wbAccount:(NSString*)wbAccount;
@end
