//
//  MNews.h
//  graduate
//
//  Created by TracyLin on 15/4/26.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface MNews : BaseModel
@property (copy,nonatomic) NSString *id_;

@property (copy,nonatomic) NSString *img_;

@property (retain,nonatomic) NSNumber *type_;

@property (copy,nonatomic) NSString *noteId_;

@property (copy,nonatomic) NSString *title_;

@property (copy,nonatomic) NSString *desc_;

@property (copy,nonatomic) NSString *time_;

@property (copy,nonatomic) NSString *url_;

@property (copy,nonatomic) NSString *source_;

@end
