//
//  MGetNewsList.m
//  graduate
//
//  Created by TracyLin on 15/4/26.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MGetNewsList.h"

@implementation MGetNewsList
- (ApiHelper *)load:(id<ApiDelegate>)delegate type:(NSInteger)type
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    
//    [params setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"subType"];
    if (type) {
        [params setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"type"];
    }
    return [self load:@"MIndexNews" params:params delegate:delegate];
}
@end