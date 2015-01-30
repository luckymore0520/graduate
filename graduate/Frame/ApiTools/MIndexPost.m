//
//  MIndexPost.m
//  graduate
//
//  Created by luck-mac on 15/1/30.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MIndexPost.h"

@implementation MIndexPost
- (ApiHelper *)load:(id<ApiDelegate>)delegate date:(NSString*)date
{
    NSDictionary* dic = nil;
    if (date) {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:date,@"date", nil];
    }
    return [self load:@"MIndexPost" params:dic delegate:delegate];
}
@end
