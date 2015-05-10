//
//  CourseModel.m
//  graduate
//
//  Created by yixiaoluo on 15/4/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "SubjectModel.h"
#import "AdModel.h"

@implementation SubjectModel

+ (SubjectModel *)fromDictionary:(NSDictionary *)note
{
    SubjectModel *model = [[SubjectModel alloc] init];
    model.subjectID = note[@"id_"];
    model.subjectTitle = note[@"title_"];
    
    NSArray *books = note[@"books_"];
    [books enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        [model.subjectBooks addObject:[SubjectNote fromDictionary:obj]];
    }];

    return model;
}

- (NSMutableArray *)subjectBooks
{
    if (_subjectBooks == nil) {
        _subjectBooks = [NSMutableArray array];
    }
    return _subjectBooks;
}

@end

@implementation SubjectNote
+ (SubjectNote *)fromDictionary:(NSDictionary *)book
{
    SubjectNote *model = [[SubjectNote alloc] init];
    model.noteTitle = book[@"title_"];
    NSArray *notes = book[@"books_"];
    [notes enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        [model.allBooks addObject:[BookModel fromDictionary:obj]];
    }];
    return model;
}

- (NSMutableArray *)allBooks
{
    if (!_allBooks) {
        _allBooks = [NSMutableArray array];
    }
    return _allBooks;
}
@end

@implementation BookModel

+ (BookModel *)fromDictionary:(NSDictionary *)note
{
    BookModel *model = [[BookModel alloc] init];
    model.bookID = note[@"id_"];
    model.bookCoverURL = note[@"cover_"];
    return model;
}

@end