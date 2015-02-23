//
//  MMain.h
//  graduate
//
//  Created by luck-mac on 15/1/29.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "BaseModel.h"
#import "MMusic.h"

@interface MMain : BaseModel

@property (strong,nonatomic) NSMutableArray *music_;
@property (copy,nonatomic) NSString *content_;
@property (copy,nonatomic) NSString *img_;
@property (copy,nonatomic) NSString *imgZj_;
@property (copy,nonatomic) NSString *imgGn_;
@property (copy,nonatomic) NSString *diary_;
@property (copy,nonatomic) NSString *date_;

@property (retain,nonatomic) NSNumber *days_;
@property (retain,nonatomic) NSNumber *daysLeft_;

@property (retain,nonatomic) NSNumber *reviewCount_;

@property (retain,nonatomic) NSNumber *addCount_;
@property (nonatomic,retain)NSNumber *signCount_;


@end
