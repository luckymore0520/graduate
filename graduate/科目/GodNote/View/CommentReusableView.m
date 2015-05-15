//
//  CommentReusableView.m
//  graduate
//
//  Created by yixiaoluo on 15/5/14.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "CommentReusableView.h"

@implementation CommentReusableView

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
}

- (IBAction)expandButtonClicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(commentReusableView:didTappedExpandButton:)]) {
        [self.delegate commentReusableView:self didTappedExpandButton:sender];
    }
}

@end
