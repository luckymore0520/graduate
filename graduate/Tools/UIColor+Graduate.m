//
//  UIColor+Graduate.m
//  graduate
//
//  Created by luck-mac on 15/2/15.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "UIColor+Graduate.h"

@implementation UIColor (Graduate)
+ (UIColor*) colorWithHex:(long)hexColor;
{
    return [UIColor colorWithHex:hexColor alpha:1.];
}

+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}

+ (UIColor *)colorOfBorder
{
    return [UIColor colorWithHex:0xe5e5e5];
}

+ (UIColor *)colorOfGrayText{
    return [UIColor colorWithHex:0xd0d0d0];
}
@end
