//
//  GodNoteView.h
//  graduate
//
//  Created by yixiaoluo on 15/4/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GodNoteView, SubjectModel, SubjectNote;
@protocol GodNoteViewDelete <NSObject>
@required
- (void)noteView:(GodNoteView *)noteView didSelectItem:(SubjectNote *)note;

@end

@interface GodNoteView : UIView

@property (weak, nonatomic) id<GodNoteViewDelete> delegate;

- (void)reloadViewWithSubjectModel:(SubjectModel *)subjectModel;

@end
