//
//  MEssenceDetail.m
//  graduate
//
//  Created by Sylar on 1/2/15.
//  Copyright (c) 2015 nju.excalibur. All rights reserved.
//

#import "MEssenceDetail.h"

@implementation MEssenceDetail

- (ApiHelper *)load:(id<ApiDelegate>)delegate id:(NSString *)id
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    if (id) {
        [dic setObject:id forKey:@"id"];
    }
    return [self load:@"MEssenceDetail" params:dic delegate:delegate];
}

@end
