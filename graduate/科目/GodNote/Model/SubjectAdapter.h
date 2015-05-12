//
//  SubjectAdapter.h
//  graduate
//
//  Created by yixiaoluo on 15/5/9.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SubjectType) {
    SubjectTypeEnglish = 1,
    SubjectTypePolity,
    SubjectTypeMath
};

@class SubjectModel;
@interface SubjectAdapter : NSObject

+ (SubjectModel *)buildAnEnglishSubject;
+ (SubjectModel *)buildAMathSubject;
+ (SubjectModel *)buildAPolitySubject;

@end
