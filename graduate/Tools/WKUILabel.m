//
//  WKUILabel.m
//  graduate
//
//  Created by luck-mac on 15/3/2.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "WKUILabel.h"

@implementation WKUILabel

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {2, 5, 2, 5};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}


@end
