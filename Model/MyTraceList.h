//
//  MyTraceList.h
//  graduate
//
//  Created by luck-mac on 15/2/6.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataHelper.h"
#import "Trace.h"
#import "ToolUtils.h"
#import "MFootprint.h"
#import "MMainList.h"
@interface MyTraceList : NSObject<ApiDelegate>
- (void)updateTraces;
+(MyTraceList *)getInstance;
-(Trace*)getTodayTrace;
- (NSMutableArray*)getMyTraces;
@end

