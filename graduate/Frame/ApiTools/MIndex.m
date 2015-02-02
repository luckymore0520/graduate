//
//  MIndex.m
//  graduate
//
//  Created by luck-mac on 15/1/29.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MIndex.h"

@implementation MIndex
- (ApiHelper *)load:(id<ApiDelegate>)delegate date:(NSString *)date type:(NSInteger)type days:(NSInteger)days
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    if (date) {
        [dic setObject:date forKey:@"date"];
    }
    if (days!=0) {
        [dic setObject:[NSString stringWithFormat:@"%d",days] forKey:@"days"];
    }
    [dic setObject:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
    
    return [self load:@"MIndex" params:dic delegate:delegate];
}
@end
