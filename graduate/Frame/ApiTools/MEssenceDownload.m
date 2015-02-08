//
//  MEssenceDownload.m
//  graduate
//
//  Created by luck-mac on 15/2/6.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MEssenceDownload.h"

@implementation MEssenceDownload
- (ApiHelper *)load:(id<ApiDelegate>)delegate id:(NSString*)essenceId resid:(NSString*)resid email:(NSString*)email isShared:(NSString*)isShared
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:essenceId forKey:@"id"];
    [params setObject:resid forKey:@"resid"];
    [params setObject:email forKey:@"email"];
    [params setObject:isShared forKey:@"isShared"];
    return [self load:@"MEssenceDownload" params:params delegate:delegate];
    
}
@end
