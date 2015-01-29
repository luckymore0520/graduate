//
//  MGetWelcome.m
//  graduate
//
//  Created by luck-mac on 15/1/29.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MGetWelcome.h"

@implementation MGetWelcome
- (ApiHelper *)load:(id<ApiDelegate>)delegate
{
    return [self load:@"MGetWelcomePage" params:nil delegate:delegate];
}
@end
