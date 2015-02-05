//
//  MUploadQues.m
//  graduate
//
//  Created by luck-mac on 15/2/1.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MUploadQues.h"

@implementation MUploadQues
- (ApiHelper *)load:(id<ApiDelegate>)delegate question:(Question*)question
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    if (question.questionid) {
        [params setObject:question.questionid forKey:@"id"];
    }
    if (question.remark) {
        [params setObject:question.remark forKey:@"remark"];
    }
    if (question.img) {
        [params setObject:question.img forKey:@"img"];
    }
    if (question.create_time) {
        [params setObject:question.create_time forKey:@"createTime"];
    }
    if (question.subject) {
        [params setObject:question.subject forKey:@"subject"];
    }
    
    
    [params setObject:question.is_highlight forKey:@"isHighlight"];
    [params setObject:question.is_recommand forKey:@"isRecommend"];
    [params setObject:question.type forKey:@"type"];
    
    [params setObject:question.review_time==nil?[NSNumber numberWithInt:0]:question.review_time forKey:@"reviewCount"];
    [params setObject:question.is_master==nil?[NSNumber numberWithBool:NO]:question.is_master forKey:@"hasLearned"];
    
    
    return [self post:@"MUploadQues" params:params delegate:delegate];
}
@end
