//
//  MEssenceCollect.h
//  graduate
//
//  Created by luck-mac on 15/2/6.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "ApiHelper.h"

@interface MEssenceCollect : ApiHelper
- (ApiHelper *)load:(id<ApiDelegate>)delegate id:(NSString*)essenceId type:(NSInteger)type;

@end
