//
//  MQuesPrint.h
//  graduate
//
//  Created by luck-mac on 15/2/23.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "ApiHelper.h"

@interface MQuesPrint : ApiHelper
- (ApiHelper *)load:(id<ApiDelegate>)delegate startDate:(NSString*)startDate endDate:(NSString*)endDate type:(NSString*)type;
@end
