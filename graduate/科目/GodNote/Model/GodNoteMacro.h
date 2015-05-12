//
//  GodNoteMacro.h
//  graduate
//
//  Created by yixiaoluo on 15/5/9.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#define RGBa(r, g, b, a)  [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:a]

@class GodNoteView, BookModel;
@protocol GodNoteViewDelete <NSObject>
@required
- (void)noteView:(GodNoteView *)noteView didSelectItem:(BookModel *)note;

@end
