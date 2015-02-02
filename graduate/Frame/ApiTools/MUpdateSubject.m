//
//  MUpdateSubject.m
//  graduate
//
//  Created by luck-mac on 15/1/31.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MUpdateSubject.h"

@implementation MUpdateSubject
- (ApiHelper *)load:(id<ApiDelegate>)delegate subjectMath:(NSString *)subjectMath subjectMajor1:(NSString *)subjectMajor1 subjectMajor2:(NSString *)subjectMajor2 subjectEng:(NSString *)subjectEng
{
    NSDictionary* subjectDic = [NSDictionary dictionaryWithObjectsAndKeys:subjectMath,@"subjectMath",subjectMajor1,@"subjectMajor1",subjectMajor2,@"subjectMajor2",subjectEng,@"subjectEng" ,nil];
    return [self load:@"MUpdateSubject" params:subjectDic delegate:delegate];
}
@end
