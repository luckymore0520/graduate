//
//  ButtonGroup.h
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ButtonGroupDelegate <NSObject>

@optional
- (void)selectIndex:(NSInteger)index name:(NSString*)buttonName;
@end

@interface ButtonGroup : UIView
{
    NSArray* buttonArray;
    NSInteger selectedIndex;
}
@property (nonatomic,strong)NSString* name;
@property (nonatomic,assign) id<ButtonGroupDelegate> delegate;
@property (nonatomic)BOOL canbeNull;
-(void)loadButton:(NSArray*)array;
-(NSString*)selectedSubject;
- (void)setSelectedIndex:(NSInteger)index;
-(NSInteger)selectedIndex;

@end

