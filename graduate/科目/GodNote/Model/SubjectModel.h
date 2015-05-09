//
//  CourseModel.h
//  graduate
//
//  Created by yixiaoluo on 15/4/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubjectModel : NSObject

@property (nonatomic) NSNumber *subjectID;
@property (copy, nonatomic) NSString *subjectTitle;
@property (nonatomic) NSMutableArray *subjectNotes;//SubjectNote array

+ (SubjectModel *)withID:(NSNumber *)sid title:(NSString *)title andNotes:(NSArray *)notes;

@end

@interface SubjectNote : NSObject

@property (nonatomic) NSNumber *noteID;
@property (copy, nonatomic) NSString *noteTitle;
@property (copy, nonatomic) NSString *noteCoverURL;

//currently max count is 3
@property (nonatomic) NSMutableArray *allChapters;//ChapterModel array

@end

@interface ChapterModel : NSObject

//chapter info
@property (nonatomic) NSNumber *parentID;
@property (nonatomic) NSNumber *chapterID;
@property (nonatomic) NSNumber *numberID;//科目编号
@property (copy, nonatomic) NSString *chapterDes;
@property (nonatomic) BOOL isLock;//是否加锁

//author info
@property (nonatomic) NSNumber *authorID;
@property (copy, nonatomic) NSString *authorName;
@property (copy, nonatomic) NSString *authorDes;
@property (copy, nonatomic) NSString *authorImg;
@property (copy, nonatomic) NSString *authorVideo;


@end
