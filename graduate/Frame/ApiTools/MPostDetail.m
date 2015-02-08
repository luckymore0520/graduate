//
//  MPostDetail.m
//  graduate
//
//  Created by luck-mac on 15/2/6.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MPostDetail.h"

@implementation MPostDetail
- (ApiHelper *)load:(id<ApiDelegate>)delegate postid:(NSString*)postid
{
    return [self load:@"MPostDetail" params:[NSDictionary dictionaryWithObjectsAndKeys:postid,@"postid", nil] delegate:delegate];
}
@end
