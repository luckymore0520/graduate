//
//  MCommentsToMe.m
//  graduate
//
//  Created by luck-mac on 15/2/5.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MCommentsToMe.h"

@implementation MCommentsToMe
- (ApiHelper *)load:(id<ApiDelegate>)delegate
{
    return [self load:@"MCommentsToMe" params:nil delegate:delegate];
}
@end
