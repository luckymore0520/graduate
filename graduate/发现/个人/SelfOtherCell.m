//
//  SelfOtherCell.m
//  graduate
//
//  Created by luck-mac on 15/2/5.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "SelfOtherCell.h"

@implementation SelfOtherCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
}

- (void)selectIndex:(NSInteger)index name:(NSString *)buttonName
{
    if (index==0) {
        [_cellSexImg setImage:[UIImage imageNamed:@"性别选择"]];
    } else {
        [_cellSexImg setImage:[UIImage imageNamed:@"性别选择-女"]];
    }
}

@end
