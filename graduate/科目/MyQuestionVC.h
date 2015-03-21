//
//  MyQuestionVC.h
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFuncVC.h"
@interface MyQuestionVC : BaseFuncVC
@property (nonatomic,strong)NSMutableArray* myQuestions;
@property (nonatomic,weak)BaseFuncVC* parentVC;
@property (nonatomic)NSInteger type;
@property (nonatomic)BOOL shoudUpdate;
@property (nonatomic)NSString* subject;
- (void)updateQuestions;
- (void) selectPhotos:(id)sender;
@end