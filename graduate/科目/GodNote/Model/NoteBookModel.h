//
//  NoteBookModel.h
//  graduate
//
//  Created by yixiaoluo on 15/5/15.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteBookModel : NSObject

@property (nonatomic) NSNumber *bookID;
@property (nonatomic) NSString *userID;
@property (nonatomic) NSString *imageURL;
@property (nonatomic) NSString *remark;
@property (nonatomic) NSString *subject;
@property (nonatomic) NSString *isHighlight;

@property (nonatomic) NSInteger orientation;//local flag to record the oritation

+ (instancetype)fromDictionary:(NSDictionary *)noteBook;

@end
