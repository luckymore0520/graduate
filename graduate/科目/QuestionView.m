//
//  QuestionView.m
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "QuestionView.h"
#import "QuestionBook.h"
#import "ToolUtils.h"
@implementation QuestionView
- (void)rotate
{
    switch (self.orientation.integerValue) {
        case 1:
            self.img = [UIImage imageWithCGImage:self.imageView.image.CGImage scale:1 orientation:UIImageOrientationLeft];
            self.myQuestion.orientation = [NSNumber numberWithInt:2];
            break;
        case 2:
            self.img = [UIImage imageWithCGImage:self.imageView.image.CGImage scale:1 orientation:UIImageOrientationDown];
            self.myQuestion.orientation = [NSNumber numberWithInt:3];
            break;
        case 3:
            self.img = [UIImage imageWithCGImage:self.imageView.image.CGImage scale:1 orientation:UIImageOrientationRight];
            self.myQuestion.orientation = [NSNumber numberWithInt:4];
            break;
        case 4:
            self.img = [UIImage imageWithCGImage:self.imageView.image.CGImage scale:1 orientation:UIImageOrientationUp];
            self.myQuestion.orientation = [NSNumber numberWithInt:1];
            break;
        
        default:
            break;
    }
    self.orientation =[NSNumber numberWithInteger: self.orientation.integerValue+1];
    if (self.orientation.integerValue>4) {
        self.orientation = [NSNumber numberWithInteger:self.orientation.integerValue-4];
    }
    self.myQuestion.orientation = self.orientation;
    [[QuestionBook getInstance]insertQuestionFromRecommand:self.myQuestion];
    [self.imageView setImage:self.img];
    [self photoDidFinishLoadWithImage:self.img];
    

    
}

@end
