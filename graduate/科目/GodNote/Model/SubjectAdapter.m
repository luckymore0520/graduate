//
//  SubjectAdapter.m
//  graduate
//
//  Created by yixiaoluo on 15/5/9.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "SubjectAdapter.h"
#import "SubjectModel.h"

@implementation SubjectAdapter

+ (SubjectModel *)buildAnEnglishSubject
{
    return [[self class] subjectModelWithType:SubjectTypeEnglish andTitle:@"英语"];;
}

+ (SubjectModel *)buildAMathSubject
{
    return [[self class] subjectModelWithType:SubjectTypeMath andTitle:@"数学"];;
}

+ (SubjectModel *)buildAPolitySubject
{
    return [[self class] subjectModelWithType:SubjectTypePolity andTitle:@"政治"];;
}

+ (SubjectModel *)subjectModelWithType:(SubjectType)type andTitle:(NSString *)title
{
    SubjectModel *model = [[SubjectModel alloc] init];
    model.subjectID = @(type);
    model.subjectTitle = title;
    return model;
}

@end
