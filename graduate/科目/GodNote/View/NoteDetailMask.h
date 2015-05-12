//
//  NoteToolBar.h
//  graduate
//
//  Created by yixiaoluo on 15/5/10.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BottomBarHeight 55

typedef NS_ENUM(NSUInteger, NoteDetailViewStyle) {
    NoteDetailViewThumbStyle = 0,
    NoteDetailViewSingleStyle
};

@class NoteDetailMask;
@protocol NoteDetailMaskDelegate <NSObject>

@required
- (void)noteDetailMaskDidSelectAttention:(NoteDetailMask *)bar;//爱心
- (void)noteDetailMaskDidSelectComment:(NoteDetailMask *)bar;//评论
- (void)noteDetailMaskDidSelectRemark:(NoteDetailMask *)bar;//添加备注
- (void)noteDetailMaskDidSelectNotice:(NoteDetailMask *)bar;//只看重点
- (void)noteDetailMaskDidSelectShare:(NoteDetailMask *)bar;//分享

@end

@interface NoteDetailMask : UIView

@property (nonatomic) id<NoteDetailMaskDelegate> delegate;
@property (nonatomic) NoteDetailViewStyle viewStyle;

+ (instancetype)mask;

@end
