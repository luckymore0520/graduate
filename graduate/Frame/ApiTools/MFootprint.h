//
//  MFootprint.h
//  graduate
//
//  Created by luck-mac on 15/2/6.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "ApiHelper.h"

@interface MFootprint : ApiHelper
- (ApiHelper *)load:(id<ApiDelegate>)delegate date:(NSString*)date type:(NSInteger)type days:(NSInteger)days;

@end
