//
//  CourseModel.m
//  graduate
//
//  Created by yixiaoluo on 15/4/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "SubjectModel.h"

@implementation SubjectModel

+ (SubjectModel *)withID:(NSNumber *)sid title:(NSString *)title andNotes:(NSArray *)notes;
{
    SubjectModel *model = [[SubjectModel alloc] init];
    model.subjectID = sid;
    model.subjectTitle = title;
    [model.subjectNotes addObjectsFromArray:notes];
    return model;
}

- (NSMutableArray *)subjectNotes
{
    if (_subjectNotes == nil) {
        _subjectNotes = [NSMutableArray array];
        for (NSInteger i = 0; i < 10; i++) {
            SubjectNote *note = [[SubjectNote alloc] init];
            note.noteCoverURL = @"http://ww4.sinaimg.cn/mw600/005vbOHfgw1erf6sxbi7tj30m80wxwi6.jpg";
            note.noteTitle = @"美女";
            note.noteID = @1;
            [_subjectNotes addObject:note];
        }
    }
    return _subjectNotes;
}

@end

@implementation SubjectNote
@end

@implementation ChapterModel
@end