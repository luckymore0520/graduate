//
//  PostList.m
//  graduate
//
//  Created by luck-mac on 15/2/5.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MPostList.h"

@implementation MPostList
- (NSDictionary *)objectClassInArray
{
    return @{@"list_" : [MPost class]};
}
@end
