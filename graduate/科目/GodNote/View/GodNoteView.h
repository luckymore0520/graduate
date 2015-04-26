//
//  GodNoteView.h
//  graduate
//
//  Created by yixiaoluo on 15/4/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GodNoteView;
@protocol GodNoteViewDelegate <NSObject>

@required
@property (readonly) NSString *godNoteViewRequestAPI;

@end

@interface GodNoteView : UIView

@property (weak, nonatomic) id<GodNoteViewDelegate> delegate;

- (void)loadDataCompletion:(dispatch_block_t)completion;

@end
