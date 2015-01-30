//
//  ButtonGroup.m
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "ButtonGroup.h"

@implementation ButtonGroup

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)loadButton:(NSArray *)array
{
    buttonArray = array;
    for (int i = 0 ; i < array.count; i++) {
        UIButton* button = [array objectAtIndex:i];
        button.tag = i;
        [button addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    [[array objectAtIndex:0]setSelected:YES];
    selectedIndex = 0;
    self.canbeNull = NO;
    
}

- (void)setSelectedIndex:(NSInteger)index
{
    [self touchButton:[buttonArray objectAtIndex:index]];
}

- (void)touchButton:(UIButton*)selectedButton
{
    if (selectedButton.tag!= selectedIndex) {
        if (selectedIndex!=-1) {
            [[buttonArray objectAtIndex:selectedIndex]setSelected:NO];
        }
        [selectedButton setSelected:YES];
        selectedIndex = selectedButton.tag;
    } else if (self.canbeNull){
        [selectedButton setSelected:NO];
        selectedIndex = -1;
    }
    [_delegate selectIndex:selectedIndex name:_name];
}

-(NSInteger)selectedIndex
{
    return selectedIndex;
}
-(NSString*)selectedSubject
{
    if (selectedIndex==-1)
        return @"未选择";
    else {
        UIButton* button = [buttonArray objectAtIndex:selectedIndex];
        return button.titleLabel.text;
    }
}

@end
