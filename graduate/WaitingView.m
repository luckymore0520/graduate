//
//  WaitingView.m
//  MobileNJU
//
//  Created by luck-mac on 14-8-3.
//  Copyright (c) 2014年 Stephen Zhuang. All rights reserved.
//

#import "WaitingView.h"
#import "UIImage+GIF.h"
@implementation WaitingView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.loadingImg setImage:[UIImage sd_animatedGIFNamed:@"loading"]];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
