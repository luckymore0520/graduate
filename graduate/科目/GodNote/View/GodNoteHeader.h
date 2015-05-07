//
//  GodNoteHeader.h
//  graduate
//
//  Created by yixiaoluo on 15/5/7.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GodNoteHeader;
@protocol GodNoteHeaderDelegate <NSObject>

@required
- (void)noteHeader:(GodNoteHeader *)header didSelectItemAtIndex:(NSInteger)itemIndex;
- (void)noteHeader:(GodNoteHeader *)header didSelectAdvertisementWithURL:(NSString *)adURL;

@end

@interface GodNoteHeader : UIView

- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<GodNoteHeaderDelegate>)delegate
         withAllSubjectModels:(NSArray *)array andAdmdel:();

@end
