//
//  MIndex.m
//  graduate
//
//  Created by luck-mac on 15/1/29.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MIndex.h"

@implementation MIndex
- (ApiHelper *)load:(id<ApiDelegate>)delegate date:(NSString *)date
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    if (date) {
        [dic setObject:date forKey:@"date"];
    }
    return [self load:@"MIndex" params:dic delegate:delegate];
}
@end
