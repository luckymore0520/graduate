//
//  MQuestionRecommand.h
//  graduate
//
//  Created by luck-mac on 15/1/31.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "ApiHelper.h"

@interface MQuestionRecommand : ApiHelper
- (ApiHelper *)load:(id<ApiDelegate>)delegate date:(NSString*)date;
@end
