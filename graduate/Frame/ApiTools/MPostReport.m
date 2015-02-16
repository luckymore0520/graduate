//
//  MPostReport.m
//  graduate
//
//  Created by luck-mac on 15/2/16.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MPostReport.h"

@implementation MPostReport
- (ApiHelper *)load:(id<ApiDelegate>)delegate pid:(NSString *)pid
{
    return [self load:@"MPostReport" params:@{@"pid":pid} delegate:delegate];
}
@end
