//
//  NoteDetail.h
//  graduate
//
//  Created by yixiaoluo on 15/5/8.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteDetail : NSObject

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
