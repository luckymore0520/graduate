//
//  MQuestion.h
//  graduate
//
//  Created by luck-mac on 15/1/31.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "BaseModel.h"

@interface MQuestion : BaseModel

@property (retain,nonatomic) NSNumber *bitField0_;

@property (copy,nonatomic) NSString *id_;

@property (copy,nonatomic) NSString *userid_;

@property (copy,nonatomic) NSString *img_;

@property (copy,nonatomic) NSString *remark_;

@property (retain,nonatomic) NSNumber *type_;

@property (copy,nonatomic) NSString *displayName_;

@property (copy,nonatomic) NSString *subject_;

@property (retain,nonatomic) NSNumber *isAd_;

@property (retain,nonatomic) NSNumber *isHighlight_;

@property (retain,nonatomic) NSNumber *isRecommend_;

@property (copy,nonatomic) NSString *lastTime_;

@property (copy,nonatomic) NSString *createTime_;

@property (copy,nonatomic) NSString *url_;

@property (retain,nonatomic) NSNumber *memoizedIsInitialized;

@property (retain,nonatomic) NSNumber *memoizedSerializedSize;

@property (retain,nonatomic) NSMutableArray *unknownFields;

@property (retain,nonatomic) NSNumber *memoizedSize;

@property (retain,nonatomic)NSNumber* orientation;

@property (retain,nonatomic)NSNumber* hasLearned_;

@property (retain,nonatomic)NSNumber* reviewCount_;

@property (retain,nonatomic)NSString* myDay_;

@property (retain,nonatomic)NSString* title_;
@end
