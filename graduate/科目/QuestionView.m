//
//  QuestionView.m
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "QuestionView.h"
#import "ToolUtils.h"
@implementation QuestionView

- (void)drawRect:(CGRect)rect
{
    if (self.img) {
        [self initLayout];
    } else {
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
        UIImageView* newImage = [[UIImageView alloc]initWithFrame:frame];
        [newImage sd_setImageWithURL:[ToolUtils getImageUrlWtihString:self.myQuestion.img_ width:self.frame.size.width height:0]
                    placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        self.img = image;
                        [self initLayout];
        }];
    }
}



- (void)initLayout
{
    CGFloat width = self.frame.size.width;
    CGFloat height = width/self.img.size.width*self.img.size.height;
 
    CGRect frame;
    CGRect appFrame = [[UIScreen mainScreen]applicationFrame];
    if (height>self.frame.size.height) {
        frame = CGRectMake(0, 0, width, height);
    } else {
        frame = CGRectMake(0, (appFrame.size.height-height)/2, width, height);
    }
    
    
    
    self.imageView = [[UIImageView alloc]initWithFrame:frame];
    [self.imageView setImage:self.img];
    [self addSubview:self.imageView];
    
    
//    UILabel* noteLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, height+10, width, 10)];
//    [noteLabel setText:@"备注"];
//    [self addSubview:noteLabel];
//    self.noteLabel = noteLabel;
    
    
    maskBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:maskBt];
    [maskBt setHidden:YES];
    [maskBt addTarget:self action:@selector(resignAll) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = CGSizeMake(width,2000);
    CGSize labelsize = [self.myQuestion.remark_ sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    NSLog(@"labelheight%lf",labelsize.height);
    UITextView* textView = [[UITextView alloc]initWithFrame:CGRectMake(5, 5 , width, labelsize.height+20)];
    textView.text = self.myQuestion.remark_;
//    [self addSubview:textView];
    self.noteView = textView;
    self.noteView.delegate = self;
    self.frame = CGRectMake(self.frame.origin.x, 0, width,[self getMyHeight]);
    if (self.editable) {
        [self.noteView setEditable:NO];
    }
    
    [self.myDelegate adaptToHeight:[self getMyHeight] textView:textView];
    
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView==self.noteView) {
//        [self.myDelegate handleKeyBoard];
        UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
        CGRect frame=[textView convertRect: textView.bounds toView:window];
        int offset = frame.origin.y - ([UIScreen mainScreen].bounds.size.height - 300);//键盘高度216
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
    }
    return YES;
}



- (void)resignAll
{
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    CGRect rect = CGRectMake(self.frame.origin.x,0,width,height);
    self.frame = rect;
    [self.noteView resignFirstResponder];
    [maskBt setHidden:YES];
}



- (CGFloat)getMyHeight
{
    return _imageView.frame.size.height>self.frame.size.height?_imageView.frame.size.height+100:self.frame.size.height+100;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
