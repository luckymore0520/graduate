//
//  EssenceMediaCell.m
//  graduate
//
//  Created by luck-mac on 15/3/17.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "EssenceMediaCell.h"
#import "UIImage+Graduate.h"
#import "UIColor+Graduate.h"
@implementation EssenceMediaCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    [_numberButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0x429dd7]] forState:UIControlStateSelected];
    _numberButton.layer.cornerRadius = 5;
    [_numberButton setClipsToBounds:YES];
    _numberButton.layer.borderColor = [UIColor colorWithHex:0x429dd7].CGColor;
    _numberButton.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [_numberButton setSelected:selected];
}



@end
