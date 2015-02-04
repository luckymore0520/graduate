//
//  MEssenceDetail.h
//  graduate
//
//  Created by Sylar on 1/2/15.
//  Copyright (c) 2015 nju.excalibur. All rights reserved.
//

#import "ApiHelper.h"

@interface MEssenceDetail : ApiHelper

- (ApiHelper *)load:(id<ApiDelegate>)delegate id:(NSString *)id;

@end
