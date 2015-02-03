//
//  MQuesList.m
//  graduate
//
//  Created by luck-mac on 15/2/3.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MQuesList.h"

@implementation MQuesList
- (ApiHelper *)load:(id<ApiDelegate>)delegate type:(NSInteger)type date:(NSString*)date
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    if (type!=0) {
        [params setObject:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
    }
    [params setObject:date forKey:@"date"];
    return [self load:@"MQuesList" params:params delegate:delegate];
}
@end
