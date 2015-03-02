//
//  MComment.h
//  graduate
//
//  Created by luck-mac on 15/2/5.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "BaseModel.h"

@interface MComment : BaseModel
@property (retain,nonatomic) NSNumber *bitField0_;

@property (copy,nonatomic) NSString *id_;

@property (copy,nonatomic) NSString *pid_;

@property (copy,nonatomic) NSString *replyid_;

@property (copy,nonatomic) NSString *replyNickname_;

@property (copy,nonatomic) NSString *content_;

@property (copy,nonatomic) NSString *userid_;

@property (copy,nonatomic) NSString *nickname_;

@property (copy,nonatomic) NSString *headimg_;

@property (copy,nonatomic) NSString *time_;

@property (retain,nonatomic) NSNumber *isNew_;

@property (copy,nonatomic) NSString *title_;

@property (retain,nonatomic) NSNumber *memoizedIsInitialized;

@property (retain,nonatomic) NSNumber *memoizedSerializedSize;

@property (retain,nonatomic) NSMutableArray *unknownFields;

@property (retain,nonatomic) NSNumber *memoizedSize;

@property (retain,nonatomic) NSNumber *sex_;

@end
