//
//  NoteToolBar.m
//  graduate
//
//  Created by yixiaoluo on 15/5/10.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "NoteDetailMask.h"

@interface NoteToolButton : UIButton
@end

@interface BottomBar : UIView

@end

@interface NoteDetailMask ()

@property (nonatomic) UIButton *attentionButton;
@property (nonatomic) UIButton *commentButton;
@property (nonatomic) UIButton *remarkButton;

@end

@implementation NoteDetailMask
+ (instancetype)mask
{
    UINib *nib = [UINib nibWithNibName:@"NoteDetailMask" bundle:nil];
    return [nib instantiateWithOwner:self options:nil][0];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return NO;
}

#pragma mark - response
- (void)didSelectAttentionButton:(id)sender
{

}

- (void)didSelectCommentButton:(id)sender
{
    
}

- (void)didSelectRemarkButton:(id)sender
{
    
}

#pragma mark - setter && getter
- (void)setViewStyle:(NoteDetailViewStyle)viewStyle
{
    switch (viewStyle) {
        case NoteDetailViewThumbStyle:
            
            break;
        case NoteDetailViewSingleStyle:
            
            break;
            
        default:
            break;
    }
}

- (UIButton *)attentionButton
{
    if (!_attentionButton) {
        _attentionButton = [self buttonWithImage:[UIImage imageNamed:@"关于我们"] andTitle:@"" selector:@selector(didSelectAttentionButton:)];
    }
    return _attentionButton;
}

- (UIButton *)buttonWithImage:(UIImage *)image andTitle:(NSString *)title selector:(SEL)selector
{
    UIButton *button = [NoteToolButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}
@end

@implementation NoteToolButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.imageView.bounds)/2);
    self.titleLabel.center = CGPointMake(CGRectGetWidth(self.bounds)/2, (CGRectGetHeight(self.bounds) - CGRectGetHeight(self.imageView.bounds))/2);
}

@end
