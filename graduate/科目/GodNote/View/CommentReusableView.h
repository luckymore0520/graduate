//
//  CommentReusableView.h
//  graduate
//
//  Created by yixiaoluo on 15/5/14.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentReusableView;
@protocol CommentReusableViewDelegate <NSObject>

@required
- (void)commentReusableView:(CommentReusableView *)view didTappedExpandButton:(UIButton *)button;

@end

@interface CommentReusableView : UICollectionReusableView

@property (weak, nonatomic) id<CommentReusableViewDelegate> delegate;

@end
