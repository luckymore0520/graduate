//
//  GodNoteView.h
//  graduate
//
//  Created by yixiaoluo on 15/4/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GodNoteView, SubjectModel;
@protocol GodNoteViewDataSource <NSObject>
@required
- (void)noteView:(GodNoteView *)noteView didSelectItemAtIndex:(NSInteger)itemIndex;

@end

@interface GodNoteView : UIView

@property (weak, nonatomic) id<GodNoteViewDataSource> dataSource;
@property (weak, nonatomic) id<GodNoteViewDataSource> delegate;

- (void)reloadViewWithSubjectModel:(SubjectModel *)subjectModel;

@end
