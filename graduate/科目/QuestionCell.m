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
    if (!self.selectView) {
        self.selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        [self addSubview:self.selectView];
        [self.selectView setBackgroundColor:[UIColor blueColor]];
        [self.selectView setAlpha:0.5];
    }
    [self.selectView setHidden:!select];
}
@end
