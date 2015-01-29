//
//  MRegister.m
//  graduate
//
//  Created by luck-mac on 15/1/29.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MRegister.h"

@implementation MRegister
- (ApiHelper *)load:(id<ApiDelegate>)delegate phone:(NSString *)phone code:(NSString*)code
{
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone",code,@"code",@"iOS",@"device", nil];
    return [self load:@"MRegister" params:params delegate:delegate];
}
@end
