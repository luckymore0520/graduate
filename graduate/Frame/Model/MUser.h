//
//  MUser.h
//  graduate
//
//  Created by luck-mac on 15/1/29.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "BaseModel.h"

@interface MUser : BaseModel
@property (copy,nonatomic) NSString *id_;

@property (copy,nonatomic) NSString *account_;

@property (copy,nonatomic) NSString *headImg_;

@property (copy,nonatomic) NSString *nickname_;

@property (copy,nonatomic) NSString *verify_;

@property (retain,nonatomic) NSNumber *sex_;

@property (copy,nonatomic) NSString *email_;

@property (copy,nonatomic) NSString *phone_;

@property (retain,nonatomic) NSNumber *isV_;

@property (retain,nonatomic) NSNumber *restDay_;

@property (retain,nonatomic) NSNumber *startDay_;

@property (copy,nonatomic) NSString *subjectEng_;

@property (copy,nonatomic) NSString *subjectPolity_;

@property (copy,nonatomic) NSString *subjectMath_;

@property (copy,nonatomic) NSString *subjectMajor1_;

@property (copy,nonatomic) NSString *subjectMajor2_;

@property (retain,nonatomic) NSNumber* hasPassword_;
@property (copy,nonatomic) NSString *diaryDefault_;

@property (copy,nonatomic) NSString *contactUrl_;

@property (copy,nonatomic) NSString *aboutusUrl_;


@end
