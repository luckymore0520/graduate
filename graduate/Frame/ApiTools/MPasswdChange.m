//
//  MPasswdChange.m
//  graduate
//
//  Created by luck-mac on 15/1/29.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MPasswdChange.h"

@implementation MPasswdChange
- (ApiHelper *)load:(id<ApiDelegate>)delegate password:(NSString *)password nickname:(NSString*)nickname sex:(NSInteger)sex
{
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:password,@"password",nickname,@"nickname",[NSString stringWithFormat:@"%d",sex],@"sex", nil];
    return [self load:@"MPasswdChange" params:params delegate:delegate];
}
@end
