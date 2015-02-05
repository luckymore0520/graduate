//
//  MPasswdChange.h
//  graduate
//
//  Created by luck-mac on 15/1/29.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "ApiHelper.h"

@interface MPasswdChange : ApiHelper
- (ApiHelper *)load:(id<ApiDelegate>)delegate password:(NSString *)password nickname:(NSString*)nickname sex:(NSInteger)sex ;
- (ApiHelper *)load:(id<ApiDelegate>)delegate password:(NSString *)password nickname:(NSString*)nickname sex:(NSInteger)sex oldPassword:(NSString*)oldPassword;
@end
