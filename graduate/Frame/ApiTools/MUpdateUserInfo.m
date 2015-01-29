//
//  MUpdateUserInfo.m
//  graduate
//
//  Created by luck-mac on 15/1/29.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MUpdateUserInfo.h"

@implementation MUpdateUserInfo
- (ApiHelper *)load:(id<ApiDelegate>)delegate nickname:(NSString *)nickname headImg:(NSString *)headImg sex:(NSInteger)sex email:(NSString *)email
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[NSString stringWithFormat:@"%d",sex] forKey:@"sex"];
    if (nickname) {
        [dic setObject:nickname forKey:@"nickname"];
    }
    if (headImg) {
        [dic setObject:headImg forKey:@"headimg"];
    }
    if (email) {
        [dic setObject:email forKey:@"email"];
    }
    return [self load:@"MUpdateUserInfo" params:dic delegate:delegate];
    
}
@end
