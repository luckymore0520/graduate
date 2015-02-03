//
//  MEssenceList.h
//  graduate
//
//  Created by Sylar on 30/1/15.
//  Copyright (c) 2015 nju.excalibur. All rights reserved.
//

#import "ApiHelper.h"

@interface MEssenceList : ApiHelper

- (ApiHelper *)load:(id<ApiDelegate>)delegate type:(NSInteger)type keyword:(NSString *)keyword;

@end
