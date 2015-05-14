//
//  CourseModel.h
//  graduate
//
//  Created by yixiaoluo on 15/4/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AdModel;
@interface SubjectModel : NSObject

@property (nonatomic) NSNumber *subjectID;
@property (copy, nonatomic) NSString *subjectTitle;
@property (nonatomic) NSMutableArray *subjectBooks;//SubjectBook array

@property (nonatomic) AdModel *adModel;

/**
 *  @param subject 数据格式参考接口文档：获取笔记本列表(V2.1)
 */
+ (SubjectModel *)fromDictionary:(NSDictionary *)subject;

@end

@interface SubjectNote : NSObject

@property (copy, nonatomic) NSString *noteTitle;
@property (nonatomic) NSMutableArray *allBooks;//BookModel array. currently max count is 3

/**
 *  @param note 数据格式参考接口文档：获取笔记本列表(V2.1)
 "title_": "完型",
 "books_": [
 {
 "id_": "ea5fcd49-f4cf-11e4-9812-ac853dac2305",
 "cover_": "1b48dd11b7b5404c8f9d84974e5d8e15"
 }
 ]
 }
 */
+ (SubjectNote *)fromDictionary:(NSDictionary *)note;

@end

@interface BookModel : NSObject

@property (nonatomic) NSNumber *bookID;
@property (copy, nonatomic) NSString *bookCoverURL;

+ (BookModel *)fromDictionary:(NSDictionary *)book;

@end
