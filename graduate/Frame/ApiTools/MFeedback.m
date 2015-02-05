//
//  MFeedback.m
//  graduate
//
//  Created by luck-mac on 15/2/5.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MFeedback.h"

@implementation MFeedback
- (ApiHelper *)load:(id<ApiDelegate>)delegate content:(NSString*)content contact:(NSString*)contact
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:contact==nil?@"":contact forKey:@"contact"];
    [params setObject:content==nil?@"":content forKey:@"content"];
    return [self post:@"MFeedback" params:params delegate:delegate];
    
}
@end
