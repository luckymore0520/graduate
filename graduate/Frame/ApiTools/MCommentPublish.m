//
//  MCommentPublish.m
//  graduate
//
//  Created by luck-mac on 15/2/5.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MCommentPublish.h"

@implementation MCommentPublish
- (ApiHelper *)load:(id<ApiDelegate>)delegate postid:(NSString*)postid content:(NSString*)content replyid:(NSString*)replyid
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setObject:postid forKey:@"postid"];
    [dic setObject:content forKey:@"content"];
    [dic setObject:replyid==nil?@"":replyid forKey:@"replyid"];
    return [self post:@"MCommentPublish" params:dic delegate:delegate];
}
@end
