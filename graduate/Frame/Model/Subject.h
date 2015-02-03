//
//  Subject.h
//  graduate
//
//  Created by luck-mac on 15/1/31.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Subject : NSObject
@property (nonatomic,strong)NSString* name;
@property (nonatomic)NSInteger total;
@property (nonatomic)NSInteger newAdd;
@property (nonatomic)NSString* img;
@property (nonatomic)NSInteger type;
@property (nonatomic)BOOL shoudUpdate;
@end
