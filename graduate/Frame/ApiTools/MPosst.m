//
//  MPost.m
//  graduate
//
//  Created by luck-mac on 15/2/5.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MPosts.h"

@implementation MPosts
- (ApiHelper *)load:(id<ApiDelegate>)delegate type:(NSInteger)type
{
    return  [self load:@"MPosts" params:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",type],@"type", nil] delegate:delegate];
}
@end
