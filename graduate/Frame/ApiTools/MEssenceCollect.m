//
//  MEssenceCollect.m
//  graduate
//
//  Created by luck-mac on 15/2/6.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MEssenceCollect.h"

@implementation MEssenceCollect
- (ApiHelper *)load:(id<ApiDelegate>)delegate id:(NSString *)essenceId type:(NSInteger)type
{
    return [self load:@"MEssenceCollect" params:[NSDictionary dictionaryWithObjectsAndKeys:essenceId,@"id",[NSString stringWithFormat:@"%ld",(long)type],@"type", nil] delegate:delegate];
}
@end
