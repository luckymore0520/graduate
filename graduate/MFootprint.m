//
//  MFootprint.m
//  graduate
//
//  Created by luck-mac on 15/2/6.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MFootprint.h"

@implementation MFootprint
- (ApiHelper *)load:(id<ApiDelegate>)delegate date:(NSString*)date type:(NSInteger)type days:(NSInteger)days
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:date forKey:@"date"];
    [params setObject:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
    [params setObject:[NSString stringWithFormat:@"%d",days] forKey:@"days"];
    return [self load:@"MFootprint" params:params delegate:delegate];
}

@end
