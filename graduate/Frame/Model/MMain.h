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

@property (retain,nonatomic) NSMutableArray *music_;
@property (copy,nonatomic) NSString *content_;
@property (copy,nonatomic) NSString *img_;
@property (retain,nonatomic) NSNumber *days_;
@property (retain,nonatomic) NSNumber *daysLeft_;
@end
