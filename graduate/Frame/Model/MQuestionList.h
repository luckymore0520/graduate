//
//  MQuestionList.h
//  graduate
//
//  Created by luck-mac on 15/1/31.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "BaseModel.h"
#import "MQuestion.h"
@interface MQuestionList : BaseModel
@property (retain,nonatomic) NSNumber *bitField0_;


@property (retain,nonatomic) NSMutableArray *list_;

@property (assign,nonatomic) BOOL isClean;

@property (retain,nonatomic) NSMutableArray *unknownFields;

@end
