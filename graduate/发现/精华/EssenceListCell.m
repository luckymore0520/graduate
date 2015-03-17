//
//  EssenceListCell.m
//  graduate
//
//  Created by luck-mac on 15/2/6.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "EssenceListCell.h"

@implementation EssenceListCell

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)select:(id)sender {
    [_selectButton setSelected:!_selectButton.selected];
    [_delegate selectCollection:_essenceId isSelected:_selectButton.selected];
}
- (void) setSelect:(BOOL)isSelected
{
    [_selectButton setSelected:isSelected];
    [_delegate selectCollection:_essenceId isSelected:isSelected];
}

- (void)setSelectedMode:(BOOL)selectedMode
{
    _selectedMode = selectedMode;
    if (_selectedMode) {
        [UIView animateWithDuration:0.3 animations:^{
            _leadingSpace.constant = 50;
            [self layoutIfNeeded];
        }];
    } else
    {
        [UIView animateWithDuration:0.3 animations:^{
            _leadingSpace.constant = 7;
            [self layoutIfNeeded];
        }];
    }
}

@end
