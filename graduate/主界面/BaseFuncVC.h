//
//  BaseFuncVC.h
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaPlayController.h"
#import "ToolUtils.h"

@interface BaseFuncVC : UIViewController<UITextFieldDelegate>
{
    CGFloat keyboardHeight;
}
@property (weak, nonatomic) IBOutlet UIButton *musicBt;
@property (nonatomic,strong)UIButton* maskBt;
@property (nonatomic,strong)NSArray* textFields;
@property (nonatomic,strong)NSArray* keyButtons;
- (void)loadMusic;
- (void)animationReturn;
@end
