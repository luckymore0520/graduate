//
//  MyTraceVC.h
//  graduate
//
//  Created by luck-mac on 15/1/26.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFuncVC.h"
#import "Trace.h"
@interface MyTraceVC : BaseFuncVC
@property (nonatomic,strong)Trace* trace;
@property (nonatomic)BOOL shoudUpdate;
@end
