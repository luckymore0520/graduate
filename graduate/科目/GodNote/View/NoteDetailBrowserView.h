//
//  NoteDetailBrowserView.h
//  graduate
//
//  Created by yixiaoluo on 15/5/10.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJPhotoView.h"

@interface NoteDetailBrowserView : UIView
<
MJPhotoViewDelegate
>

@property (weak, nonatomic) id<MJPhotoViewDelegate> delegate;

- (void)startBrowsingFromPage:(NSInteger)page;

@end