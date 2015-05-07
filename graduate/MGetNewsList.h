//
//  MGetNewsList.h
//  graduate
//
//  Created by TracyLin on 15/4/26.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "ApiHelper.h"

@interface MGetNewsList : ApiHelper
- (ApiHelper *)load:(id<ApiDelegate>)delegate type:(NSInteger)type;
@end
