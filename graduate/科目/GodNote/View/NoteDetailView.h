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
- (void)noteDetailView:(NoteDetailView *)noteDetailView didSelectItemAtIndex:(NSInteger)itemIndex imageView:(UIImageView *)imageView;

@end

@interface NoteDetailView : UIView
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic) id<NoteDetailViewDelegate> delegate;

- (void)reloadViewWithNoteBooks:(NSArray *)notes;
- (void)scrollToIndexVisiable:(NSInteger)startIndex animated:(BOOL)animated completion:(void (^)(UIImageView *imageView))completion;

@end
