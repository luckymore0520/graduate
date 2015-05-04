//
//  MNewsList.m
//  graduate
//
//  Created by TracyLin on 15/4/26.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MNewsList.h"
#import "MNews.h"

@implementation MNewsList
- (NSDictionary *)objectClassInArray
{
    return @{@"news_" : [MNews class]};
}
@end
