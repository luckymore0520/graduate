//
//  NoteDetailView.h
//  graduate
//
//  Created by yixiaoluo on 15/5/10.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NoteDetailView;
@protocol NoteDetailViewDelegate <NSObject>
@required
- (void)noteDetailView:(NoteDetailView *)noteDetailView didSelectItem:(id)item fromRect:(CGRect)frame;

@end

@interface NoteDetailView : UIView
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic) id<NoteDetailViewDelegate> delegate;

- (void)reloadViewWithNotes:(NSArray *)notes completion:(dispatch_block_t)completion;
- (void)scrollToIndexVisiable:(NSInteger)startIndex animated:(BOOL)animated completion:(void (^)(CGRect endFrame, UIView *view))completion;

@end
