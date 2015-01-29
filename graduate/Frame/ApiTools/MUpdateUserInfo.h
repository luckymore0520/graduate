//
//  MUpdateUserInfo.h
//  graduate
//
//  Created by luck-mac on 15/1/29.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "ApiHelper.h"

@interface MUpdateUserInfo : ApiHelper
- (ApiHelper *)load:(id<ApiDelegate>)delegate nickname:(NSString *)nickname headImg:(NSString*)headImg sex:(NSInteger)sex email:(NSString*)email;
@end
