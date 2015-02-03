//
//  MQuesDelete.h
//  graduate
//
//  Created by luck-mac on 15/2/3.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "ApiHelper.h"

@interface MQuesDelete : ApiHelper
- (ApiHelper *)load:(id<ApiDelegate>)delegate id:(NSString*)questionId;
@end
