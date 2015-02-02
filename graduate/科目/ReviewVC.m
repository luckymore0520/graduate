//
//  ReviewVC.m
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//



#define SC_DEVICE_SIZE      [[UIScreen mainScreen] bounds].size
#import "ReviewVC.h"
@interface ReviewVC ()

@end

@implementation ReviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.bottomHeight = 60.0;
    self.canEdit = YES;
    [self.scrollView setBackgroundColor:[UIColor blackColor]];
//    self.scrollView.pagingEnabled=YES;
    // Do any additional setup after loading the view.
}


- (void)viewDidAppear:(BOOL)animated
{
    [self loadQuestions];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadQuestions
{
    self.questionViews = [[NSMutableArray alloc]init];
    CGSize pageScrollViewSize = self.view.frame.size;
    self.scrollView.contentSize = CGSizeMake(pageScrollViewSize.width * self.questionList.count, 0);
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.questionViews = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < self.questionList.count; i++) {
        CGRect frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        frame.size = self.view.frame.size;
        QuestionView* view = [[QuestionView alloc]initWithFrame:frame];
        view.myQuestion = [self.questionList objectAtIndex:i];
        view.photoViewDelegate = self;
        MJPhoto *photo = [[MJPhoto alloc] init];
        MQuestion* question = [self.questionList objectAtIndex:i];
        if (question.isRecommend_.integerValue==1) {
            UIImage* image = [UIImage imageWithData:[ToolUtils loadData:question.id_]];
            photo.image = image;
            photo.firstShow = NO;
        } else if (question.isRecommend_.integerValue==0) {
            NSString *imageUrl = [ToolUtils getImageUrlWtihString:question.img_ width:640 height:0].absoluteString;
            NSString *url = [imageUrl stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
            NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)url, NULL, NULL,  kCFStringEncodingUTF8 ));
            photo.url = [NSURL URLWithString:encodedString]; // 图片路径
        }
        photo.desc = question.remark_;
        photo.index = i;
        view.photo = photo;
        [view setBackgroundColor:[UIColor blackColor]];
        [self.questionViews addObject:view];
    }
    [self.scrollView addSubview:self.questionViews.firstObject];
}





-(void)pageChange:(UIPageControl *)sender{
    self.currentPage ++;
    if (self.currentPage<self.questionList.count) {
        QuestionView* originView = [self.questionViews objectAtIndex:self.currentPage-1];
        QuestionView* view = [self.questionViews objectAtIndex:self.currentPage];
        [self.scrollView addSubview:view];
        view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width,0);
        [UIView animateWithDuration:0.3 animations:^{
            view.transform = CGAffineTransformMakeTranslation(0,0);
            originView.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width,0);
        }];
        [self addBottomView:view.myQuestion.remark_ showAll:NO];
    } else {
        self.currentPage--;
        [self performSegueWithIdentifier:@"complete" sender:nil];
    }
}



#pragma mark ButtonAction
//已掌握
- (IBAction)hasKnownAction:(id)sender {
    QuestionBook* book = [QuestionBook getInstance];
    Question* question = [book getQuestionByMQuestion:[self.questionList objectAtIndex:self.currentPage]];
    question.is_master =[NSNumber numberWithBool:YES];
    [book save];
    [self pageChange:nil];
#warning 此处需要调用已掌握的接口
}

//未掌握
- (IBAction)notKnowAction:(id)sender {
    QuestionBook* book = [QuestionBook getInstance];
    Question* question = [book getQuestionByMQuestion:[self.questionList objectAtIndex:self.currentPage]];
    question.is_master =[NSNumber numberWithBool:NO];
    [book save];
    [self pageChange:nil];
#warning 此处需要调用未掌握的接口

}



- (void)showAll
{
    MQuestion* question = [self.questionList objectAtIndex:self.currentPage];
    [self addBottomView:question.remark_ showAll:YES];
}


- (void)addBottomView:(NSString*)originRemark showAll:(BOOL)showAll 
{
    NSString* remark = [originRemark copy];
    if (!showAll&&remark.length>=40) {
        remark = [remark substringToIndex:40];
        remark = [NSString stringWithFormat:@"%@....",remark];
    }
    CGRect frame = [[UIScreen mainScreen]bounds];
    CGFloat width = frame.size.width;
    UIFont *font = [UIFont systemFontOfSize:13];
    CGSize size = CGSizeMake(width,2000);
    CGSize labelsize = [remark sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    NSLog(@"labelheight%lf",labelsize.height);

    _markLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5 , width, labelsize.height+20)];
    [_markLabel setFont:font];

    _markLabel.text = remark;
    [_markLabel setNumberOfLines:0];
    [_markLabel setBackgroundColor:[UIColor clearColor]];
    [_markLabel setTextColor:[UIColor whiteColor]];
    

    if (self.bottomContainerView) {
        [self.bottomContainerView removeFromSuperview];
    }
    
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    frame = CGRectMake(0, screenFrame.size.height - _markLabel.frame.size.height-50-self.bottomHeight, screenFrame.size.width, _markLabel.frame.size.height+50);
    
    self.bottomContainerView = [[UIView alloc]initWithFrame:frame];
    [self.bottomContainerView setBackgroundColor:[UIColor blackColor]];
    [self.bottomContainerView setAlpha:0.5];
   
    [self.bottomContainerView addSubview:_markLabel];
    
    if (!showAll&&originRemark.length>=40) {
        CGRect showAllBtFrame = CGRectMake(width-80, labelsize.height/2+10, 80, labelsize.height/2+10);
        UIButton* showAllBt = [[UIButton alloc]initWithFrame:showAllBtFrame];
        [showAllBt setTitle:@"查看更多" forState:UIControlStateNormal];
        [showAllBt.titleLabel setFont:font];
        [_bottomContainerView addSubview:showAllBt];
        [showAllBt addTarget:self action:@selector(showAll) forControlEvents:UIControlEventTouchUpInside];
    }

    
    [self.view addSubview:self.bottomContainerView];
  
    
    if (self.canEdit) {
        CGRect editFrame = CGRectMake(frame.size.width-50, frame.size.height-50, 50, 50);
        UIButton* editBt = [[UIButton alloc]initWithFrame:editFrame];
        [editBt setTitle:@"编辑" forState:UIControlStateNormal];
        [editBt.titleLabel setTextColor:[UIColor whiteColor]];
        [editBt addTarget:self action:@selector(editRemark) forControlEvents:UIControlEventTouchUpInside];
        
        [self.bottomContainerView addSubview:editBt];
        
        
        CGRect starFrame = CGRectMake(frame.size.width-100, frame.size.height-50, 50, 50);
        UIButton* starBt = [[UIButton alloc]initWithFrame:starFrame];
        [starBt setTitle:@"重点" forState:UIControlStateNormal];
        [starBt setTitle:@"取消" forState:UIControlStateSelected];
        [starBt.titleLabel setTextColor:[UIColor whiteColor]];
        
        MQuestion* question = [self.questionList objectAtIndex:self.currentPage];
        [starBt setSelected:question.isHighlight_.boolValue];
        [starBt addTarget:self action:@selector(addToImportant:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomContainerView addSubview:starBt];
    }
    
   
    
}



- (void)addToImportant:(id)sender
{
    UIButton* selectBt = (UIButton*)sender;
    [selectBt setSelected:!selectBt.isSelected];
    QuestionBook* book = [QuestionBook getInstance];
    Question* question = [book getQuestionByMQuestion:[self.questionList objectAtIndex:self.currentPage]];
    question.is_highlight = question.is_highlight.boolValue?[NSNumber numberWithBool:NO]:[NSNumber numberWithBool:YES];
    [book save];
}



- (void)editRemark
{
    if (!_editView) {
        CGRect frame = CGRectMake(0, SC_DEVICE_SIZE.height, SC_DEVICE_SIZE.width, 200);
        _editView = [[UIView alloc]initWithFrame:frame];
        [self.view addSubview:_editView];
        
        CGRect textFrame = CGRectMake(0, 50, SC_DEVICE_SIZE.width, 160);
        
        _editTextView = [[UITextView alloc]initWithFrame:textFrame];
        
        MQuestion* question = [self.questionList objectAtIndex:self.currentPage];
        
        _editTextView.text = question.remark_;
        
        
        [_editView addSubview:_editTextView];
        
        
        
        CGRect leftBtFrame = CGRectMake(5, 0, 50, 50);
        UIButton* cancelButton = [[UIButton alloc]initWithFrame:leftBtFrame];
        [cancelButton addTarget:self action:@selector(cancelEdit) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton.titleLabel setTextColor:[UIColor blueColor]];
        [_editView addSubview:cancelButton];
        
        CGRect rightBtFrame = CGRectMake(SC_DEVICE_SIZE.width-55, 5, 50, 50);
        UIButton* saveButton = [[UIButton alloc]initWithFrame:rightBtFrame];
        [saveButton addTarget:self action:@selector(saveRemark) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [saveButton.titleLabel setTextColor:[UIColor blueColor]];
        
        [_editView addSubview:saveButton];
    }
    
    [self.editTextView becomeFirstResponder];
    CGRect frame = _editView.frame;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        NSLog(@"%lf",-frame.size.height-(keyboardHeight==0?240:keyboardHeight));
        self.editView.transform = CGAffineTransformMakeTranslation(0, -frame.size.height-(keyboardHeight==0?240:keyboardHeight));
    } completion:^(BOOL finished) {
        //        [self.keyboardBt setHidden:NO];
    }];
    
}


-(void)cancelEdit
{
    [self.editTextView resignFirstResponder];
}

-(void)saveRemark
{
    [self.editTextView resignFirstResponder];
    QuestionBook* book = [QuestionBook getInstance];
    Question* question = [book getQuestionByMQuestion:[self.questionList objectAtIndex:self.currentPage]];
    question.remark = self.editTextView.text;
    [book save];
    
    
    [self addBottomView:self.editTextView.text showAll:NO];
}


- (void) keyboardWasHidden:(NSNotification *) notif
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.editView.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark -MJPhotoDelegate
- (void)photoViewImageFinishLoad:(MJPhotoView *)photoView
{
//    [self.scrollView addSubview:photoView];
    self.scrollView.contentSize = CGSizeMake(0, 0);
    if (photoView.photo.index==0) {
        MQuestion* question = ((QuestionView*)photoView).myQuestion;
        [self addBottomView:question.remark_ showAll:NO];
    }
}



- (void)photoViewSingleTap:(MJPhotoView *)photoView
{
    CGFloat alpha = self.bottomContainerView.alpha;
    [self.navigationController setNavigationBarHidden:!alpha==0 animated:YES];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]&&alpha!=0) {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.bottomContainerView setAlpha:alpha==0?0.5:0];
    }];

    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleDefault;
//    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
//    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
//}



- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
