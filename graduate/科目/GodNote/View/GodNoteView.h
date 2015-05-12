//
//  GodNoteView.h
//  graduate
//
//  Created by yixiaoluo on 15/4/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GodNoteViewCell.h"
#import "GodNoteMacro.h"

@class GodNoteView, SubjectModel, SubjectNote;
@interface GodNoteView : UIView

@property (weak, nonatomic) id<GodNoteViewDelete> delegate;

- (void)reloadViewWithSubjectModel:(SubjectModel *)subjectModel
                        completion:(dispatch_block_t)completion;

@end
