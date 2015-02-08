//
//  MMyEssences.m
//  graduate
//
//  Created by luck-mac on 15/2/6.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MMyEssences.h"

@implementation MMyEssences
- (ApiHelper *)load:(id<ApiDelegate>)delegate
{
    return [self load:@"MMyEssences" params:nil delegate:delegate];
}
@end
