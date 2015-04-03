//
//  MyCollectionRootView.h
//  graduate
//
//  Created by luck-mac on 15/3/17.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "BaseFuncVC.h"
#import "EssenceListCell.h"
@interface MyCollectionRootView : BaseFuncVC<EssenceListCellDelegate>
- (void)setSelectedMode:(BOOL)selectedMode;
- (void)selectCollection:(NSString *)essenceId isSelected:(BOOL)isSelected;
-(NSMutableArray *)removeArray;
@end
