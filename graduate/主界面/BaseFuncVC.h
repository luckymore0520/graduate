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
@interface BaseFuncVC : UIViewController<UITextFieldDelegate,ApiDelegate>
{
    CGFloat keyboardHeight;
}
@property (weak, nonatomic) IBOutlet UIButton *musicBt;
@property (nonatomic,strong)UIButton* maskBt;
@property (nonatomic,strong)NSArray* textFields;
@property (nonatomic,strong)NSArray* keyButtons;
@property (nonatomic,strong)UIView* maskView;
- (void)loadMusic:(NSURL*)path;
- (void)animationReturn;

@property (nonatomic,strong)MediaPlayController* controller;

@property (nonatomic,strong)NSURL* musicUrl;


- (void)addRightButton:(NSString*)title action:(SEL)action img:(NSString*)img;

- (void)addMask;
- (void)removeMask;
@end
