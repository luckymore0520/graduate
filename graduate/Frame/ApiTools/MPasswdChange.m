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
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    if (nickname) {
        [params setObject:nickname forKey:@"nickname"];
    }
    if (password) {
        [params setObject:password forKey:@"password"];
    }
    if (sex!=-1) {
        [params setObject:[NSString stringWithFormat:@"%ld",sex] forKey:@"sex"];
    }
    return [self load:@"MPasswdChange" params:params delegate:delegate];
}

- (ApiHelper *)load:(id<ApiDelegate>)delegate password:(NSString *)password nickname:(NSString*)nickname sex:(NSInteger)sex oldPassword:(NSString*)oldPassword
{
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:password,@"password",nickname,@"nickname",[NSString stringWithFormat:@"%d",sex],@"sex",oldPassword,@"passwordOld", nil];
    return [self load:@"MPasswdChange" params:params delegate:delegate];
}
@end
