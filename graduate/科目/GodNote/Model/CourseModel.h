//
//  CourseModel.h
//  graduate
//
//  Created by yixiaoluo on 15/4/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseModel : NSObject

@property (readonly, nonatomic) NSString *courseName;
@property (readonly, nonatomic) NSMutableArray *courseNotes;

+ (CourseModel *)withCourseName:(NSString *)name andNotes:(NSArray *)notes;

@end

@interface CourseNote : NSObject

@property (copy, nonatomic) NSString *noteCoverURL;
@property (copy, nonatomic) NSString *name;

@end
