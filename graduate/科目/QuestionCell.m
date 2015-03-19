//
//  QuestionCell.m
//  graduate
//
//  Created by luck-mac on 15/1/31.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "QuestionCell.h"

@implementation QuestionCell
- (void)setSelect:(BOOL) select;
{
    [self.selectedButton setSelected:select];
}

-(void)setSelectMode:(BOOL)selectMode
{
    [self.selectView setHidden:!selectMode];
    if (!selectMode) {
        [self.selectedButton setSelected:NO];
    }
}
@end
