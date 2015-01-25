//
//  ButtonGroup.h
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonGroup : UIView
{
    NSArray* buttonArray;
    NSInteger selectedIndex;
}
-(void)loadButton:(NSArray*)array;

@end
