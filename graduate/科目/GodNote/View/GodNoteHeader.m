//
//  GodNoteHeader.m
//  graduate
//
//  Created by yixiaoluo on 15/5/7.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "GodNoteHeader.h"

@interface GodNoteHeader ()
@property (weak, nonatomic) id<GodNoteHeaderDelegate> delegate;
@property (nonatomic) NSArray *allSubjectModels;

@end

@implementation GodNoteHeader

- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<GodNoteHeaderDelegate>)delegate
         withAllSubjectModels:(NSArray *)array
{
    self = [super initWithFrame:frame];
    self.delegate = delegate;
    self.allSubjectModels = array;
    return self;
}

- (void)setupSubViews
{
    UICollectionViewLayout *layout = [[UICollectionViewLayout alloc] init];
    layout.
}

@end
