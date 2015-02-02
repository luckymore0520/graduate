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
@protocol QuestionViewDelegate <NSObject>

@required
- (void)handleKeyBoard;
- (void)adaptToHeight:(CGFloat)height textView:(UITextView*)noteView;
@end
@interface QuestionView : UIView<UITextViewDelegate>
{
    UIButton* maskBt;
}
@property (nonatomic,strong)UIImage* img;
@property (nonatomic,strong) MQuestion* myQuestion;
@property (strong, nonatomic)  UIImageView *imageView;
@property (strong, nonatomic)  UITextView *noteView;
@property (strong, nonatomic)  UILabel *noteLabel;
@property (nonatomic)   id<QuestionViewDelegate> myDelegate;
@property (nonatomic,strong)NSString* editable;
- (CGFloat)getMyHeight;
- (void)initLayout;

@end

