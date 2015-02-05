//
//  MComments.m
//  graduate
//
//  Created by luck-mac on 15/2/5.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MComments.h"

@implementation MComments
- (ApiHelper *)load:(id<ApiDelegate>)delegate postid:(NSString*)postid
{
    return [self load:@"MComments" params:[NSDictionary dictionaryWithObjectsAndKeys:postid,@"postid", nil] delegate:delegate];
}
@end
