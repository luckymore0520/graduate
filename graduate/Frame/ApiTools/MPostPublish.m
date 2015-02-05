//
//  MPostPublish.m
//  graduate
//
//  Created by luck-mac on 15/2/5.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MPostPublish.h"

@implementation MPostPublish
- (ApiHelper *)load:(id<ApiDelegate>)delegate content:(NSString *)content title:(NSString *)title
{
    return [self post:@"MPostPublish" params:[NSDictionary dictionaryWithObjectsAndKeys:content,@"content",title,@"title",nil] delegate:delegate];
}
@end
