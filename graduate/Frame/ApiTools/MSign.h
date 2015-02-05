//
//  MSign.h
//  graduate
//
//  Created by luck-mac on 15/2/4.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "ApiHelper.h"

@interface MSign : ApiHelper
- (ApiHelper *)load:(id<ApiDelegate>)delegate type:(NSInteger)type subject:(NSString*)subject date:(NSString*)date;
@end
