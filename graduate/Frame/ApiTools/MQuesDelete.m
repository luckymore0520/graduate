//
//  MQuesDelete.m
//  graduate
//
//  Created by luck-mac on 15/2/3.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MQuesDelete.h"

@implementation MQuesDelete
- (ApiHelper *)load:(id<ApiDelegate>)delegate id:(NSString *)questionId
{
    return [self load:@"MQuesDelete" params:[NSDictionary dictionaryWithObjectsAndKeys:questionId,@"id", nil] delegate:delegate];
}
@end
