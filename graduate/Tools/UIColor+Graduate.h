//
//  UIColor+Graduate.h
//  graduate
//
//  Created by luck-mac on 15/2/15.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Graduate)
+ (UIColor*) colorWithHex:(long)hexColor;
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;
+ (UIColor *)colorOfBorder;
+ (UIColor *)colorOfGrayText;
@end
