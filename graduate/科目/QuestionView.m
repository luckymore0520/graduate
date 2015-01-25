//
//  QuestionView.m
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "QuestionView.h"

@implementation QuestionView
- (void)drawRect:(CGRect)rect
{
    UIImage* img = [UIImage imageNamed:@"1.jpg"];
    CGFloat width = self.frame.size.width;
    CGFloat height = img.size.height/img.size.width*width;
    CGRect newFrame = CGRectMake(0, 0, width, height);
    UIImageView* newImage = [[UIImageView alloc]initWithImage:img];
    newImage.frame = newFrame;
    [self addSubview:newImage];
    
    self.imageView = newImage;
    
    
    UILabel* noteLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, height+10, width, 10)];
    [noteLabel setText:@"备注"];
    [self addSubview:noteLabel];
    
    self.noteLabel = noteLabel;
    
    
    maskBt = [[UIButton alloc]initWithFrame:self.frame];
    [self addSubview:maskBt];
    [maskBt setHidden:YES];
    [maskBt addTarget:self action:@selector(resignAll) forControlEvents:UIControlEventTouchUpInside];

    
#warning 自适应高度
    UITextView* textView = [[UITextView alloc]initWithFrame:CGRectMake(5, height+30, width, 100)];
    textView.text = @"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
    [self addSubview:textView];
    
    self.noteView = textView;
    self.noteView.delegate = self;
    self.frame = CGRectMake(self.frame.origin.x, 0, width, [self getMyHeight]);
    
}



- (void)initLayout
{
    //自适应
   
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self.myDelegate handleKeyBoard];
    CGFloat height_off = 100 ;
    CGRect frame = textView.frame;
    if (
        [[UIScreen mainScreen] bounds].size.height >= 568.0f && [[UIScreen mainScreen] bounds].size.height < 1024.0f
        ){
        height_off = 200;
    }
    int offset = frame.origin.y + height_off - (self.frame.size.height - 240);//键盘高度216
    NSLog(@"offset is %d",offset);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        self.frame = rect;
    }
    [UIView commitAnimations];
    [maskBt setHidden:NO];
    return YES;
}

- (void)resignAll
{
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    CGRect rect = CGRectMake(0.0f,0,width,height);
    self.frame = rect;
    [self.noteView resignFirstResponder];
    [maskBt setHidden:YES];
}



- (CGFloat)getMyHeight
{
    return _imageView.frame.size.height+_noteView.frame.size.height+200;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
