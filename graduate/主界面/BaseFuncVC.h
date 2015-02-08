//
//  BaseFuncVC.h
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MediaPlayController.h"
#import "ToolUtils.h"
#import "ApiHelper.h"
#import "WaitingView.h"
#import "CircularProgressView.h"

@interface BaseFuncVC : UIViewController<UITextFieldDelegate,ApiDelegate>
{
    CGFloat keyboardHeight;
}
@property (nonatomic)CGFloat scale;
@property (weak, nonatomic) IBOutlet UIButton *musicBt;
@property (nonatomic,strong)UIButton* maskBt;
@property (nonatomic,strong)NSArray* textFields;
@property (nonatomic,strong)NSArray* keyButtons;
@property (nonatomic,strong)UIView* maskView;
@property (strong, nonatomic) NSArray *backIcons;
@property (nonatomic,strong)WaitingView* waitingView;

- (void)loadMusic:(NSURL*)path;
- (void)animationReturn;

@property (nonatomic,strong)MediaPlayController* controller;

@property (nonatomic,strong)NSURL* musicUrl;


- (void)addRightButton:(NSString*)title action:(SEL)action img:(NSString*)img;
- (void)addMask;
- (void)removeMask;
- (void)downloadMusic;
- (void) waiting:(NSString*)msg;
- (void) waitingEnd;

- (void)loadMusic:(NSURL*)path progressView:(CircularProgressView*)progress;
- (void)initViews;
- (void)resignAll;
- (void)addMaskBt;
@end
