//
//  MDetail.h
//  graduate
//
//  Created by Sylar on 1/2/15.
//  Copyright (c) 2015 nju.excalibur. All rights reserved.
//

#import "BaseModel.h"

@interface MDetailEssence : BaseModel
@property (copy, nonatomic) NSString *id_;
@property (copy, nonatomic) NSString *title_;
@property (copy, nonatomic) NSString *source_;
@property (copy, nonatomic) NSString *url_;
@property (copy, nonatomic) NSString *content_;
@property (retain,nonatomic) NSNumber *hasDownload_;
@property (copy, nonatomic) NSString *resid_;
@property (retain,nonatomic) NSNumber *isCollected_;
@property (retain,nonatomic) NSNumber *isDownloaded_;
@property (retain,nonatomic) NSNumber *needShare_;
@property (copy, nonatomic) NSString *time_;
@end
