//
//  MQuestionRecommand.m
//  graduate
//
//  Created by luck-mac on 15/1/31.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MQuestionRecommand.h"

@implementation MQuestionRecommand
- (ApiHelper *)load:(id<ApiDelegate>)delegate date:(NSString *)date
{
    if (date == nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        date = [dateFormatter stringFromDate:[NSDate date]];
    }
    return [self load:@"MQuesRecommend" params:@{@"date":date} delegate:delegate];
}
@end
