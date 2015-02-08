//
//  MEssenceDetail.m
//  graduate
//
//  Created by luck-mac on 15/2/6.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MEssenceDetail.h"

@implementation MEssenceDetail
- (ApiHelper *)load:(id<ApiDelegate>)delegate id:(NSString *)id
{
    return  [self load:@"MEssenceDetail" params:[NSDictionary dictionaryWithObjectsAndKeys:id,@"id", nil] delegate:delegate];
}
@end
