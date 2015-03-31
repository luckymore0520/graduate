//
//  MGetMsgCount.m
//  graduate
//
//  Created by luck-mac on 15/2/5.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MGetMsgCount.h"

@implementation MGetMsgCount
- (ApiHelper *)load:(id<ApiDelegate>)delegate
{
    return [self load:@"MGetMsgCount" params:nil delegate:delegate];
}
@end
