//
//  MGetMobileVerify.m
//  graduate
//
//  Created by luck-mac on 15/1/29.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MGetMobileVerify.h"

@implementation MGetMobileVerify
- (ApiHelper *)load:(id<ApiDelegate>)delegate phone:(NSString *)phone
{
    return [self load:@"MGetMobileVerify" params:[NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone", nil] delegate:delegate];
}
@end
