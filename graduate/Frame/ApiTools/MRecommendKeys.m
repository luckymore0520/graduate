//
//  MRecommendKeys.m
//  graduate
//
//  Created by luck-mac on 15/2/6.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MRecommendKeys.h"

@implementation MRecommendKeys
- (ApiHelper *)load:(id<ApiDelegate>)delegate key:(NSString*)key
{
    return [self load:@"MRecommendKeys" params:[NSDictionary dictionaryWithObjectsAndKeys:key,@"key", nil] delegate:delegate];
}
@end
