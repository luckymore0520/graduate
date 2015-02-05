//
//  MSign.m
//  graduate
//
//  Created by luck-mac on 15/2/4.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MSign.h"

@implementation MSign
- (ApiHelper *)load:(id<ApiDelegate>)delegate type:(NSInteger)type subject:(NSString *)subject date:(NSString *)date
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
    [params setObject:subject==nil?@"":subject forKey:@"subject"];
    [params setObject:date==nil?@"":date forKey:@"date"];
    return [self load:@"MSign" params:params delegate:delegate];
}
@end
