//
//  MQuesCountStatus.m
//  graduate
//
//  Created by luck-mac on 15/2/3.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MQuesCountStatus.h"

@implementation MQuesCountStatus
- (ApiHelper *)load:(id<ApiDelegate>)delegate
{
    return [self load:@"MQuesCountStatus" params:nil delegate:delegate];
}
@end
