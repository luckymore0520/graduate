//
//  MFeedback.h
//  graduate
//
//  Created by luck-mac on 15/2/5.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "ApiHelper.h"

@interface MFeedback : ApiHelper
- (ApiHelper *)load:(id<ApiDelegate>)delegate content:(NSString*)content contact:(NSString*)contact;

@end
