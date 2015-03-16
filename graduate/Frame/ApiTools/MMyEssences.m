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

- (ApiHelper *)load:(id<ApiDelegate>)delegate resType:(NSString *)resType
{
    NSDictionary* dic = nil;
    if (resType!=nil) {
        dic = @{@"resType":resType};
    }
    return [self load:@"MMyEssences" params:dic delegate:delegate];
}
@end
