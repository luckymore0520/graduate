//
//  NoteBookModel.m
//  graduate
//
//  Created by yixiaoluo on 15/5/15.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "NoteBookModel.h"

@implementation NoteBookModel

+ (instancetype)fromDictionary:(NSDictionary *)noteBook
{
    NoteBookModel *model = [[NoteBookModel alloc] init];
    model.bookID = noteBook[@"id_"];
    model.userID = noteBook[@"userid_"];
    model.imageURL = noteBook[@"img_"];
    model.remark = noteBook[@"remark_"];
    model.subject = noteBook[@"subject_"];
    model.isHighlight = noteBook[@"isHighlight_"];
    model.orientation = 1;//default is portrait
    
    return model;
}

@end