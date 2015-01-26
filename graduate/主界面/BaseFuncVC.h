//
//  BaseFuncVC.h
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaPlayController.h"
@interface BaseFuncVC : UIViewController
{
    CGFloat keyboardHeight;
}
@property (weak, nonatomic) IBOutlet UIButton *musicBt;

- (void)loadMusic;

@end
