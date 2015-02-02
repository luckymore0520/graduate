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
#import "MJPhoto.h"

@interface ReviewVC : BaseFuncVC<UIScrollViewDelegate,MJPhotoViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray* questionViews;
@property (nonatomic)NSInteger currentPage;
@property (nonatomic,strong)UIView* bottomContainerView;
@property (nonatomic,strong)UIView* editView;
@property (nonatomic,strong)UITextView* editTextView;
@property (nonatomic,strong)UILabel* markLabel;
@property (nonatomic,strong)NSMutableArray* questionList;
@property (nonatomic)CGFloat bottomHeight;
@property (nonatomic)BOOL canEdit;
- (void)loadQuestions;
- (void)addBottomView:(NSString*)remark showAll:(BOOL)showAll;
@end
