//
//  Question.h
//  graduate
//
//  Created by luck-mac on 15/1/31.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Question : NSManagedObject

@property (nonatomic, retain) NSString * create_time;
@property (nonatomic, retain) NSString * img;
@property (nonatomic, retain) NSNumber * is_highlight;
@property (nonatomic, retain) NSNumber * is_recommand;
@property (nonatomic, retain) NSNumber * isUpload;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * userid;
@property (nonatomic, retain) NSString * questionid;
@property (nonatomic, retain) NSNumber * is_master;
@property (nonatomic, retain) NSNumber * review_time;
@property (nonatomic, retain) NSString * myDay;
@property (nonatomic,retain)NSString *thumb_img;
@property (nonatomic,retain)NSNumber *orientation;
@end
