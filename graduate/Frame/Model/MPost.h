//
//  MPost.h
//  graduate
//
//  Created by luck-mac on 15/1/30.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "BaseModel.h"

@interface MPost : BaseModel

@property (retain,nonatomic) NSNumber *bitField0_;

@property (copy,nonatomic) NSString *id_;

@property (copy,nonatomic) NSString *userid_;

@property (copy,nonatomic) NSString *title_;

@property (copy,nonatomic) NSString *content_;

@property (copy,nonatomic) NSString *lastTime_;

@property (retain,nonatomic) NSNumber *commentCount_;

@property (retain,nonatomic) NSNumber *praiseCount_;

@property (copy,nonatomic) NSString *nickname_;

@property (copy,nonatomic) NSString *headimg_;

@property (copy,nonatomic) NSString *time_;

@property (copy,nonatomic) NSString *isUnRead_;

@property (retain,nonatomic) NSNumber *memoizedIsInitialized;

@property (retain,nonatomic) NSNumber *memoizedSerializedSize;

@property (retain,nonatomic) NSMutableArray *unknownFields;

@property (retain,nonatomic) NSNumber *memoizedSize;

@property (retain,nonatomic) NSNumber *sex_;

@property (copy,nonatomic) NSString *sharedUrl_;
@end
