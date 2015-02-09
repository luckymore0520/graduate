//
//  ReviewVC.m
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//



#import "ReviewVC.h"
#import "SignVC.h"
@interface ReviewVC ()

@end

@implementation ReviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bottomHeight = 60.0;
    self.hasTitle = NO;
    [self setTitle:@"复习"];
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
    
    for (UIView* view in self.questionViews) {
        [view removeFromSuperview];
    }

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
        view.orientation = view.myQuestion.orientation;
        view.backgroundColor = [UIColor clearColor];
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
        [view setBackgroundColor:[UIColor clearColor]];
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
    [book review:[self.questionList objectAtIndex:self.currentPage] isMaster:YES];
    [self pageChange:nil];
#warning 此处需要调用已掌握的接口
}

//未掌握
- (IBAction)notKnowAction:(id)sender {
    QuestionBook* book = [QuestionBook getInstance];
    [book review:[self.questionList objectAtIndex:self.currentPage] isMaster:NO];
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
    } else {
        
    }
    
    
    
    
    
    
    CGRect frame = [[UIScreen mainScreen]bounds];
    CGFloat width = frame.size.width;
    
    UILabel* titleLabel;
    UILabel* titlePageLabel;
    if (self.hasTitle) {
        UIFont* titleFont = [UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:18];
        CGRect titleFrame = CGRectMake(15, 23, width-100, 45);
        titleLabel = [[UILabel alloc]initWithFrame:titleFrame];
        [titleLabel setFont:titleFont];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setText:@"南大学霸推荐英语笔记"];
        
        
        
        UIFont* pageTitleFont = [UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:18];
        NSString* totalPage =[NSString stringWithFormat:@"/%d", self.questionList.count];
        NSString* currentPage = [NSString stringWithFormat:@"%d",self.currentPage+1];
        NSLog(@"length~~~%lf",width-totalPage.length*10+currentPage.length*15);
        CGRect pageTitleFrame = CGRectMake(width-totalPage.length*10-currentPage.length*15-15, 26, totalPage.length*10+currentPage.length*15, 45);
        
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",currentPage,totalPage]];
        NSRange currentRange = {0,[currentPage length]};
        [content addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:19] range:currentRange];
        [content addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:currentRange];
        NSRange totalRange = {[currentPage length],[totalPage length]};
        [content addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:16] range:totalRange];
        [content addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1] range:totalRange];
        titlePageLabel = [[UILabel alloc]initWithFrame:pageTitleFrame];
        [titlePageLabel setAttributedText:content];

    }
    
    
    
    
    
    

    
    UIFont *font = [UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:12];
    CGSize size = CGSizeMake(width,2000);
    CGSize labelsize = [remark sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    NSLog(@"labelheight%lf",labelsize.height);

    CGFloat titleHeight = self.hasTitle?50:0;
    
    if (labelsize.height>60) {
        _markLabel = [[UITextView alloc]initWithFrame:CGRectMake(10, 15+titleHeight , width-20, 80)];
    } else {
        _markLabel = [[UITextView alloc]initWithFrame:CGRectMake(10, 15+titleHeight , width-20, labelsize.height+30)];

    }
    
    
    
    
    
    
    [_markLabel setFont:font];
    
    _markLabel.text = remark;
//    [UITextView setNumberOfLines:0];
    [_markLabel setBackgroundColor:[UIColor clearColor]];
    [_markLabel setTextColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]];
    

    if (self.bottomContainerView) {
        [self.bottomContainerView removeFromSuperview];
    }
    
    
    
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    frame = CGRectMake(0, screenFrame.size.height - _markLabel.frame.size.height-50-self.bottomHeight-15-titleHeight, screenFrame.size.width, _markLabel.frame.size.height+50+15+titleHeight);
    
    
    
    self.bottomContainerView = [[UIView alloc]initWithFrame:frame];
    [self.bottomContainerView setBackgroundColor:[UIColor clearColor]];
    
    [self.bottomContainerView addSubview:titleLabel];
    [self.bottomContainerView addSubview:_markLabel];
    [self.bottomContainerView addSubview:titlePageLabel];
    if (!showAll&&originRemark.length>=40) {
        CGRect showAllBtFrame = CGRectMake(width-80, labelsize.height/2+10+60, 80, labelsize.height/2+10);
        UIButton* showAllBt = [[UIButton alloc]initWithFrame:showAllBtFrame];
        [showAllBt setTitle:@"查看更多" forState:UIControlStateNormal];
        [showAllBt.titleLabel setFont:font];
        [_bottomContainerView addSubview:showAllBt];
        [showAllBt addTarget:self action:@selector(showAll) forControlEvents:UIControlEventTouchUpInside];
    }

    
    [self.view addSubview:self.bottomContainerView];
  
    
    [self.markLabel setEditable:NO];
    [self.view bringSubviewToFront:self.collectBt];
    MQuestion* question = [self.questionList objectAtIndex:self.currentPage];
    if ([[QuestionBook getInstance]getQuestionByMQuestion:question]) {
        [self.collectBt setSelected:YES];
    } else {
        [self.collectBt setSelected:NO];

    }
    if (self.questionViews.count>self.currentPage) {
        QuestionView* view = [self.questionViews objectAtIndex:self.currentPage];
        UIImage* img ;
        if (view.img) {
            img = view.img;
        } else {
            img = view.imageView.image;
        }
        if (img) {
            [view setBackgroundColor:[UIColor clearColor]];
            [self.backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
            [self.backgroundImageView setImageToBlur:img blurRadius:40 completionBlock:nil];
            [self.backgroundImageView setClipsToBounds:YES];
            
        }

    }
    
    [self.bottomContainerView setHidden:self.headerView.hidden];
}



- (IBAction)addToImportant:(id)sender
{
    UIButton* selectBt = (UIButton*)sender;
    [selectBt setSelected:!selectBt.isSelected];
    QuestionBook* book = [QuestionBook getInstance];
    Question* question = [book getQuestionByMQuestion:[self.questionList objectAtIndex:self.currentPage]];
    question.is_highlight = question.is_highlight.boolValue?[NSNumber numberWithBool:NO]:[NSNumber numberWithBool:YES];
    [book save];

}

- (IBAction)rotate:(id)sender {
    
    QuestionView* view = [self.questionViews objectAtIndex:self.currentPage];
    [view rotate];
}



- (IBAction)editRemark:(id)sender
{
    [self addMask];
    if (!_editView) {
        CGRect frame = CGRectMake(0, SC_DEVICE_SIZE.height, SC_DEVICE_SIZE.width, 160);
        _editView = [[UIView alloc]initWithFrame:frame];
        _editView.backgroundColor = [UIColor whiteColor];
        [self.navigationController.view addSubview:_editView];
        CGRect textFrame = CGRectMake(0, 50, SC_DEVICE_SIZE.width, 110);
        
        _editTextView = [[UITextView alloc]initWithFrame:textFrame];
        _editTextView.layer.borderWidth = 1;
        _editTextView.layer.borderColor = [UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:0.5].CGColor;
        _editTextView.font = [UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:16];
        _editTextView.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        [_editView addSubview:_editTextView];
        CGRect leftBtFrame = CGRectMake(15, 5, 40, 40);
        UIButton* cancelButton = [[UIButton alloc]initWithFrame:leftBtFrame];
        [cancelButton addTarget:self action:@selector(cancelEdit) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor: [UIColor colorWithRed:31/255.0 green:118/255.0 blue:220/255.0 alpha:1] forState:UIControlStateNormal];
        [_editView addSubview:cancelButton];
        
        CGRect rightBtFrame = CGRectMake(SC_DEVICE_SIZE.width-55, 5, 40, 40);
        UIButton* saveButton = [[UIButton alloc]initWithFrame:rightBtFrame];
        [saveButton addTarget:self action:@selector(saveRemark) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [saveButton setTitleColor: [UIColor colorWithRed:31/255.0 green:118/255.0 blue:220/255.0 alpha:1] forState:UIControlStateNormal];
        [_editView addSubview:saveButton];
    }
    
    MQuestion* question = [self.questionList objectAtIndex:self.currentPage];
    _editTextView.text = question.remark_;
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
    [self removeMask];
    [self.editTextView resignFirstResponder];
}

-(void)saveRemark
{
    [self cancelEdit];
    QuestionBook* book = [QuestionBook getInstance];
    Question* question = [book getQuestionByMQuestion:[self.questionList objectAtIndex:self.currentPage]];
    question.remark = self.editTextView.text;
    ((MQuestion*)[self.questionList objectAtIndex:self.currentPage]).remark_=self.editTextView.text;
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
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]&&alpha!=0) {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.bottomContainerView setAlpha:alpha==0?1:0];
        [self.headerView setAlpha:alpha==0?1:0];
        [self.footMask setAlpha:alpha==0?1:0];
        [self.collectBt setAlpha:alpha==0?1:0];
        [self.backMaskView setAlpha:alpha==0?0.5:1];
    }];
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"complete"]) {
        SignVC* nextVC = (SignVC*)segue.destinationViewController;
        nextVC.subject = self.subject;
    }
}


@end
