//
//  MUploadDiary.m
//  graduate
//
//  Created by luck-mac on 15/2/4.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MUploadDiary.h"

@implementation MUploadDiary
- (ApiHelper *)load:(id<ApiDelegate>)delegate content:(NSString *)content date:(NSString *)date
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:content==nil?@"":content forKey:@"content"];
    [params setObject:date==nil?@"":date forKey:@"date"];
    return [self load:@"MUploadDiary" params:params delegate:delegate];
}
@end
