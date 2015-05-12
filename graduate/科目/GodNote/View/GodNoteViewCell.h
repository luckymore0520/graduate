//
//  GodNoteViewCell.h
//  graduate
//
//  Created by yixiaoluo on 15/5/10.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GodNoteMacro.h"
#import "SubjectModel.h"

@interface GodNoteViewCell : UICollectionViewCell

@property (weak, nonatomic) id<GodNoteViewDelete> delegate;

- (void)configCellWithSubjectModel:(SubjectModel *)model;

@end

@interface NoteTitleCell : UICollectionViewCell

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIImageView *imageView;

@end
