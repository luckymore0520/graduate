//
//  MQuesPrint.m
//  graduate
//
//  Created by luck-mac on 15/2/23.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MQuesPrint.h"

@implementation MQuesPrint
- (ApiHelper *)load:(id<ApiDelegate>)delegate startDate:(NSString *)startDate endDate:(NSString *)endDate type:(NSString *)type
{
    return [self load:@"MQuesPrint" params:@{@"startDate":startDate,@"endDate":endDate,@"type":type} delegate:delegate];
}
@end
