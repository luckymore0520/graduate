//
//  BaseFuncVC.h
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//
#import "WKNavigationViewController.h"
#import "MediaPlayController.h"
#import "ToolUtils.h"
#import "ApiHelper.h"
#import "WaitingView.h"
#import "CircularProgressView.h"
#import "UIColor+Graduate.h"
#import "FlipPresentAnimation.h"
@interface BaseFuncVC : UIViewController<UITextFieldDelegate,ApiDelegate,UIViewControllerTransitioningDelegate>
{
    CGFloat keyboardHeight;
}
@property (nonatomic)CGFloat scale;
@property (nonatomic,strong)UIButton* maskBt;
@property (nonatomic,strong)NSArray* textFields;
@property (nonatomic,strong)NSArray* keyButtons;
@property (nonatomic,strong)UIView* maskView;
@property (strong, nonatomic) NSArray *backIcons;
@property (nonatomic,strong)WaitingView* waitingView;


- (void)animationReturn;
- (void)addRightButton:(NSString*)title action:(SEL)action img:(NSString*)img;
- (void)addLeftButton:(NSString*)title action:(SEL)action img:(NSString*)img;
-(void)closeSelf;
- (void)addMask;
- (void)removeMask;
- (void)downloadMusic;
- (void) waiting:(NSString*)msg;
- (void) waitingEnd;

- (void)initViews;
- (void)resignAll;
- (void)addMaskBt;
@end
