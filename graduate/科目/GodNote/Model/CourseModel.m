//
//  CourseModel.m
//  graduate
//
//  Created by yixiaoluo on 15/4/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "CourseModel.h"

@interface CourseModel ()

@property (readwrite, nonatomic) NSString *courseName;
@property (readwrite, nonatomic) NSMutableArray *courseNotes;

@end

@implementation CourseModel

+ (CourseModel *)withCourseName:(NSString *)name andNotes:(NSArray *)notes
{
    CourseModel *model = [[CourseModel alloc] init];
    model.courseName = name;
    [model.courseNotes addObjectsFromArray:notes];
    return model;
}

- (NSMutableArray *)courseNotes
{
    if (_courseNotes == nil) {
        _courseNotes = [NSMutableArray array];
        for (NSInteger i = 0; i < 10; i++) {
            CourseNote *note = [[CourseNote alloc] init];
            note.noteCoverURL = @"http://ww4.sinaimg.cn/mw600/005vbOHfgw1erf6sxbi7tj30m80wxwi6.jpg";
            note.name = @"美女";
            [_courseNotes addObject:note];
        }
    }
    return _courseNotes;
}

@end

@implementation CourseNote
@end