//
//  QuestionView.h
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQuestion.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoView.h"

@interface QuestionView : MJPhotoView

@property (nonatomic,strong) MQuestion* myQuestion;
- (void)rotate;
@end

