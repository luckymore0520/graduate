//
//  MReturn.h
//  graduate
//
//  Created by luck-mac on 15/1/29.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "BaseModel.h"

@interface MReturn : BaseModel

@property (retain,nonatomic) NSNumber *bitField0_;

@property (retain,nonatomic) NSNumber *code_;

@property (copy,nonatomic) NSString *msg_;

@property (retain,nonatomic) NSMutableArray *img_;

@property (assign,nonatomic) BOOL isClean;

@property (retain,nonatomic) NSMutableArray *unknownFields;

@end
