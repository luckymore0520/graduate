//
//  MCommentList.m
//  graduate
//
//  Created by luck-mac on 15/2/5.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MCommentList.h"

@implementation MCommentList
- (NSDictionary *)objectClassInArray
{
    return @{@"comments_" : [MComment class]};
}
@end
