//
//  MLogin.m
//  graduate
//
//  Created by luck-mac on 15/1/29.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MLogin.h"

@implementation MLogin
- (ApiHelper *)load:(id<ApiDelegate>)delegate phone:(NSString *)phone account:(NSString *)account password:(NSString *)password qqAcount:(NSString *)qqAccount wxAccount:(NSString *)wxAccount wbAccount:(NSString *)wbAccount
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    if (phone) {
        [dic setObject:phone forKey:@"phone"];
    }
    if (account) {
        [dic setObject:account forKey:@"account"];
    }
    if (password) {
        [dic setObject:password forKey:@"password"];
    }
    if (qqAccount) {
        [dic setObject:qqAccount forKey:@"qqAccount"];
    }
    if (wxAccount) {
        [dic setObject:wxAccount forKey:@"wxAccount"];
    }
    if (wbAccount) {
        [dic setObject:wbAccount forKey:@"wbAccount"];
    }
    [dic setObject:@"iOS" forKey:@"device"];
    return [self load:@"MLogin" params:dic delegate:delegate];
    
}
@end
