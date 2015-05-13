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

@property (nonatomic) BOOL isPoppedView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBarToBottomMargin;
@property (weak, nonatomic) IBOutlet UIView *popView;
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;

@end

@implementation NoteDetailMask
+ (instancetype)mask
{
    UINib *nib = [UINib nibWithNibName:@"NoteDetailMask" bundle:nil];
    return [nib instantiateWithOwner:self options:nil][0];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return CGRectContainsPoint(self.popView.frame, point)
            || CGRectContainsPoint(self.bottomBarView.frame, point);
}

#pragma mark - response
- (IBAction)didSelectAttentionButton:(id)sender
{

}

- (IBAction)didSelectCommentButton:(id)sender
{
    
}

- (IBAction)didSelectMoreButton:(id)sender
{
    self.popView.hidden = !self.popView.hidden;
    self.isPoppedView = !self.popView.hidden;
}


- (IBAction)didSelectRemarkButton:(id)sender
{
    
}

#pragma mark - view animtation
- (void)dismissPoppedView
{
    self.popView.hidden = YES;
    self.isPoppedView = NO;
}

- (void)showPopView
{
    self.popView.hidden = NO;
    self.isPoppedView = YES;
}

- (void)setBottomBarHidden:(BOOL)hidden
{
    self.bottomBarToBottomMargin.constant = hidden ? -BottomBarHeight : 0;
    [UIView animateWithDuration:.25 animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark - setter && getter
- (void)setViewStyle:(NoteDetailViewStyle)viewStyle
{
    _viewStyle = viewStyle;
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
    
    self.imageView.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2 - 8);
    self.titleLabel.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds) - CGRectGetHeight(self.titleLabel.bounds)/2 - 3);
}

@end
