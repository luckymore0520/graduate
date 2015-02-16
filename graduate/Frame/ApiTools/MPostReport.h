//
//  MPostReport.h
//  graduate
//
//  Created by luck-mac on 15/2/16.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "ApiHelper.h"

@interface MPostReport : ApiHelper
- (ApiHelper *)load:(id<ApiDelegate>)delegate pid:(NSString*)pid;

@end
