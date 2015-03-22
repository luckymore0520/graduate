//
//  ReviewVC.h
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFuncVC.h"
#import "Question.h"
#import "QuestionView.h"
#import "QuestionBook.h"
#import "UIImageView+LBBlurredImage.h"
#import "MJPhoto.h"

@interface ReviewVC : BaseFuncVC<UIScrollViewDelegate,MJPhotoViewDelegate>
@property (nonatomic,strong)NSString* reviewType;
@property (weak, nonatomic) IBOutlet UIView *backMaskView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *collectBt;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray* questionViews;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footMaskHeight;
@property (weak, nonatomic) IBOutlet UIImageView *footMask;
@property (nonatomic)NSInteger currentPage;
@property (nonatomic,strong)UIView* bottomContainerView;
@property (nonatomic,strong)UIView* editView;
@property (nonatomic,strong)UITextView* editTextView;
@property (nonatomic,strong)UITextView* markLabel;
@property (nonatomic,strong)NSMutableArray* questionList;
@property (nonatomic)CGFloat bottomHeight;
@property (nonatomic)BOOL hasTitle;
@property (nonatomic,strong)NSString* subject;
- (void)loadQuestions;
- (void)addBottomView:(MQuestion*)selectedQuestion showAll:(BOOL)showAll;
@property (nonatomic,strong) NSString* currentQuestionId;
@property (weak, nonatomic) IBOutlet UIImageView *loadingImageView;

@end
