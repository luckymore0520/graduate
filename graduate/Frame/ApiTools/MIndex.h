//
//  MIndex.h
//  graduate
//
//  Created by luck-mac on 15/1/29.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "ApiHelper.h"

@interface MIndex : ApiHelper
- (ApiHelper *)load:(id<ApiDelegate>)delegate date:(NSString *)date type:(NSInteger)type days:(NSInteger)days;
@end
