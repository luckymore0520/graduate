//
//  UIImage+Graduate.m
//  graduate
//
//  Created by luck-mac on 15/3/15.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "UIImage+Graduate.h"

@implementation UIImage (Graduate)
+ (UIImage *)imageWithColor:(UIColor *)color
{
    return [self imageWithColor:color size:CGSizeMake(1.0f, 1.0f)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    NSAssert(size.width && size.height, @"Width or height can't be zero.");
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
