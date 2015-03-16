    //
//  MGetEssenceList.m
//  graduate
//
//  Created by luck-mac on 15/2/6.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MGetEssenceList.h"

@implementation MGetEssenceList
- (ApiHelper *)load:(id<ApiDelegate>)delegate type:(NSInteger)type key:(NSString*)key
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:[NSString stringWithFormat:@"%ld",type] forKey:@"subType"];
    if (key) {
        [params setObject:key forKey:@"key"];
    }
    return [self load:@"MEssenceList" params:params delegate:delegate];
}
@end
