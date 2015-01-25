//
//  QuestionView.h
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol QuestionViewDelegate <NSObject>

@required
- (void)handleKeyBoard;

@end
@interface QuestionView : UIView<UITextViewDelegate>
{
    UIButton* maskBt;
}
@property (strong, nonatomic)  UIImageView *imageView;
@property (strong, nonatomic)  UITextView *noteView;
@property (strong, nonatomic)  UILabel *noteLabel;
@property (nonatomic)   id<QuestionViewDelegate> myDelegate;

- (CGFloat)getMyHeight;
- (void)initLayout;

@end

