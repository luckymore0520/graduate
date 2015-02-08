//
//  MPostDetail.h
//  graduate
//
//  Created by luck-mac on 15/2/6.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "ApiHelper.h"

@interface MPostDetail : ApiHelper
- (ApiHelper *)load:(id<ApiDelegate>)delegate postid:(NSString*)postid;

@end
