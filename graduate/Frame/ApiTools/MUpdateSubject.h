//
//  MUpdateSubject.h
//  graduate
//
//  Created by luck-mac on 15/1/31.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "ApiHelper.h"

@interface MUpdateSubject : ApiHelper
- (ApiHelper *)load:(id<ApiDelegate>)delegate subjectMath:(NSString*)subjectMath subjectMajor1:(NSString*)subjectMajor1 subjectMajor2:(NSString*)subjectMajor2 subjectEng:(NSString*)subjectEng;
@end
