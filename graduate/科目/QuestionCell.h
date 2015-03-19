//
//  QuestionCell.h
//  graduate
//
//  Created by luck-mac on 15/1/31.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *stateImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property (nonatomic,assign)BOOL isStar;
- (void)setSelect:(BOOL) select;
-(void)setSelectMode:(BOOL)selectMode;
@end
