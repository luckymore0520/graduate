//
//  MEssence.h
//  graduate
//
//  Created by luck-mac on 15/2/6.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "BaseModel.h"
#import "MMedia.h"
@interface MEssence : BaseModel
@property (retain,nonatomic) NSNumber *bitField0_;

@property (copy,nonatomic) NSString *id_;

@property (copy,nonatomic) NSString *title_;

@property (copy,nonatomic) NSString *source_;

@property (copy,nonatomic) NSString *url_;

@property (copy,nonatomic) NSString *content_;

@property (retain,nonatomic) NSNumber *hasDownload_;

@property (copy,nonatomic) NSString *resid_;

@property (retain,nonatomic) NSNumber *isCollected_;

@property (retain,nonatomic) NSNumber *isDownloaded_;

@property (retain,nonatomic) NSNumber *needShare_;

@property (copy,nonatomic) NSString *time_;

@property (retain,nonatomic) NSNumber *type_;

@property (retain,nonatomic) NSNumber *resType_;

@property (copy,nonatomic) NSString *resSize_;

@property (retain,nonatomic) NSNumber *browseTimes_;

@property (retain,nonatomic) NSNumber *downloadTimes_;

@property (retain,nonatomic) NSNumber *subjectType_;

@property (copy,nonatomic) NSString *subjectName_;

@property (retain,nonatomic) NSMutableArray *media_;

@property (copy,nonatomic) NSString *shareUrl_;

@property (retain,nonatomic) NSNumber *memoizedIsInitialized;

@property (retain,nonatomic) NSNumber *memoizedSerializedSize;

@property (retain,nonatomic) NSMutableArray *unknownFields;

@property (retain,nonatomic) NSNumber *memoizedSize;
@end
