//
//  MEssenceList.m
//  graduate
//
//  Created by Sylar on 30/1/15.
//  Copyright (c) 2015 nju.excalibur. All rights reserved.
//

#import "MEssenceList.h"

@implementation MEssenceList

- (ApiHelper *)load:(id<ApiDelegate>)delegate type:(NSInteger)type keyword:(NSString *)keyword
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    if (type) {
        [dic setObject:[NSString stringWithFormat:@"%d", type] forKey:@"type"];
    }
    if (keyword) {
        [dic setObject:keyword forKey:@"keyword"];
    }
    return [self load:@"MEssenceList" params:dic delegate:delegate];
}

@end
