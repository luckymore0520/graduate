//
//  ReviewVC.m
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//



#import "ReviewVC.h"
#import "SignVC.h"
#import "NSMutableArray+Shuffle.h"
#import "MyTraceList.h"
#import "UIImage+GIF.h"
@interface ReviewVC ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *footToolView;
@property (weak, nonatomic) IBOutlet UIButton *isImportantBt;
@property (weak, nonatomic) IBOutlet UIView *progressBar;
@property (nonatomic,strong)Trace* trace;
@end

@implementation ReviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bottomHeight = 150.0;
    self.hasTitle = NO;
    _trace = [[MyTraceList getInstance] getTodayTrace];
    [self.loadingImageView setImage:[UIImage sd_animatedGIFNamed:@"454545"]];
    [self.scrollView setPagingEnabled:YES];
    self.scrollView.delegate = self;
//    self.scrollView.pagingEnabled=YES;
    // Do any additional setup after loading the view.
}

- (void)setReviewType:(NSString *)reviewType
{
    _reviewType = reviewType;
    //先排序
    [_questionList sortUsingComparator:^NSComparisonResult(MQuestion* obj1, MQuestion* obj2) {
        return obj1.myDay_.integerValue < obj2.myDay_.integerValue;
    }];

    if ([_reviewType isEqualToString:@"艾氏复习"]) {
        //先排序
        if (_questionList.count>30) {
            NSUInteger middleIndex = _questionList.count/2;
            //前半部分
            NSMutableArray* formerArray = [NSMutableArray arrayWithArray:[_questionList subarrayWithRange: NSMakeRange(0, middleIndex)]];
            //后半部分
            [_questionList removeObjectsInArray:formerArray];
            
            //打乱顺序
            [formerArray shuffle];
            [_questionList shuffle];
            //数量，
            NSUInteger formerCount = MIN(formerArray.count/3, 11);
            NSUInteger latterCount = MIN(_questionList.count/3*2, 19);
            //直接取前面那部分（因为已经打乱了)
            formerArray = [NSMutableArray arrayWithArray:[formerArray subarrayWithRange:NSMakeRange(0, formerCount)]];
            _questionList = [NSMutableArray arrayWithArray:[_questionList subarrayWithRange:NSMakeRange(0, latterCount)]];
            [_questionList addObjectsFromArray:formerArray];
        }
        [_questionList sortUsingComparator:^NSComparisonResult(MQuestion* obj1, MQuestion* obj2) {
            return obj1.myDay_.integerValue > obj2.myDay_.integerValue;
        }];
    } else if([_reviewType isEqualToString:@"按序复习"]){
        //取最前面的两天
        MQuestion* question = [_questionList firstObject];
        NSString* firstDay = question.myDay_;
        NSString* secondDay = nil;
        BOOL hasFoundSecondDay = NO;
        NSUInteger index = 0;
        for (int i = 0 ; i < _questionList.count; i++) {
            MQuestion* question = _questionList[i];
            if (!hasFoundSecondDay && ![firstDay isEqualToString:question.myDay_]) {
                hasFoundSecondDay = YES;
                secondDay = question.myDay_;
            } else if (hasFoundSecondDay) {
                if (![question.myDay_ isEqualToString:secondDay]) {
                    break;
                }
            }
            index++;
        }
        _questionList = [NSMutableArray arrayWithArray:[_questionList subarrayWithRange:NSMakeRange(0, index)]];
    }else{
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];

}

- (void)initViews
{
    
}


-(void)closeSelf{
    if(!self.isBrowse){
        [[[UIAlertView alloc]initWithTitle:@"退出复习" message:@"再坚持一下吧" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [self loadQuestions];
    [self updateProgressBarAndTitle];
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
        frame.origin.x = self.view.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.view.frame.size;
        QuestionView* view = [[QuestionView alloc]initWithFrame:frame];
        view.myQuestion = [self.questionList objectAtIndex:i];
        view.photoViewDelegate = self;
        view.orientation = view.myQuestion.orientation;
        view.backgroundColor = [UIColor clearColor];
        if (!self.footMask) {
            view.parentHeight = self.scrollView.frame.size.height;
        }
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
        [self.scrollView addSubview:view];
    }
    //如果有当前id的话就需要跳几步
    if([self.currentQuestionId length]){
        for (int i = 0  ; i < self.questionList.count ; i ++) {
            MQuestion* question = [self.questionList objectAtIndex:i];
            if ([question.id_ isEqualToString:self.currentQuestionId]) {
                self.scrollView.contentOffset= CGPointMake(i*self.scrollView.frame.size.width, 0);
                self.currentPage = i;
                [self addBottomView:question showAll:NO];
                break;
            }
        }

    }
    
    
}





-(void)pageChange:(UIPageControl *)sender{
    self.currentPage ++;
    [self updateProgressBarAndTitle];
    if (self.currentPage<self.questionList.count) {
        QuestionView* view = [self.questionViews objectAtIndex:self.currentPage];
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x + self.view.frame.size.width, 0.0);
        }];
        //NSLog(@"the location is %f  %f",self.scrollView.contentOffset.x,self.scrollView.contentOffset.y);
        [self addBottomView:view.myQuestion showAll:NO];
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
    _trace.reviewCount = @(_trace.reviewCount.integerValue+1);
}

//未掌握
- (IBAction)notKnowAction:(id)sender {
    QuestionBook* book = [QuestionBook getInstance];
    [book review:[self.questionList objectAtIndex:self.currentPage] isMaster:NO];
    [self pageChange:nil];
    _trace.reviewCount = @(_trace.reviewCount.integerValue+1);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    CoreDataHelper *helper = [CoreDataHelper getInstance];
    NSError *error;
    BOOL isSaveSuccess=[helper.managedObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error:%@",error);
    }else{
        NSLog(@"Save successful!");
    }
}



- (void)showAll
{
    MQuestion* question = [self.questionList objectAtIndex:self.currentPage];
    [self addBottomView:question showAll:YES];
}


- (void)addBottomView:(MQuestion*)selectQuestion showAll:(BOOL)showAll
{
    NSString* originRemark = selectQuestion.remark_;
    originRemark = [originRemark stringByReplacingOccurrencesOfString:@" " withString:@""];
    originRemark = [originRemark stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    originRemark = [originRemark stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString* remark = [originRemark copy];
    if (!showAll&&remark.length>=40) {
        remark = [remark substringToIndex:40];
        remark = [NSString stringWithFormat:@"%@....",remark];
    } else {
    }
    CGRect frame = [[UIScreen mainScreen]bounds];
    CGFloat width = frame.size.width;
    
    UILabel* titleLabel;
//    UILabel* titlePageLabel;
    if (self.hasTitle) {
        UIFont* titleFont = [UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:18];
        CGRect titleFrame = CGRectMake(15, 23, width-100, 45);
        titleLabel = [[UILabel alloc]initWithFrame:titleFrame];
        [titleLabel setFont:titleFont];
        [titleLabel setTextColor:[UIColor blackColor]];
        if (selectQuestion.title_) {
            [titleLabel setText:selectQuestion.title_];
        }
//        UIFont* pageTitleFont = [UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:18];
//        NSString* totalPage =[NSString stringWithFormat:@"/%ld", self.questionList.count];
//        NSString* currentPage = [NSString stringWithFormat:@"%ld",self.currentPage+1];
//        CGRect pageTitleFrame = CGRectMake(width-totalPage.length*10-currentPage.length*15-15, 26, totalPage.length*10+currentPage.length*15, 45);
//        
//        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",currentPage,totalPage]];
//        NSRange currentRange = {0,[currentPage length]};
//        [content addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:19] range:currentRange];
//        [content addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:currentRange];
//        NSRange totalRange = {[currentPage length],[totalPage length]};
//        [content addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:16] range:totalRange];
//        [content addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1] range:totalRange];
//        titlePageLabel = [[UILabel alloc]initWithFrame:pageTitleFrame];
//        [titlePageLabel setAttributedText:content];

    }
    
    
    
    
    
    

    
    UIFont *font = [UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:12];
    CGSize size = CGSizeMake(width,2000);
    CGSize labelsize = [remark sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    NSLog(@"labelheight%lf",labelsize.height);

    CGFloat titleHeight = self.hasTitle?50:0;
    
    UIView* textBackView;
    
    if (labelsize.height>60) {
        textBackView = [[UIView alloc]initWithFrame:CGRectMake(10, 5+titleHeight , width-20, 60)];
        _markLabel = [[UITextView alloc]initWithFrame:CGRectMake(0, 0 , width-20, 60)];
    } else {
        textBackView = [[UIView alloc]initWithFrame:CGRectMake(10, 5+titleHeight , width-20, labelsize.height+30)];

        _markLabel = [[UITextView alloc]initWithFrame:CGRectMake(0, 0 , width-20, labelsize.height+30)];

    }
    
    [textBackView addSubview:_markLabel];
    [textBackView setClipsToBounds:YES];

    [_markLabel setShowsVerticalScrollIndicator:YES];
    [_markLabel setFont:font];
    _markLabel.text = [remark stringByReplacingOccurrencesOfString:@" " withString:@""];
    _markLabel.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    [_markLabel setBackgroundColor:[UIColor clearColor]];
    if (self.footMask) {
        [_markLabel setTextColor:[UIColor blackColor]];

    } else {
    [_markLabel setTextColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]];

    }
    

    if (self.bottomContainerView) {
        [self.bottomContainerView removeFromSuperview];
    }
    
    
    
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    frame = CGRectMake(0, screenFrame.size.height - _markLabel.frame.size.height-self.bottomHeight-15-titleHeight-20, screenFrame.size.width, _markLabel.frame.size.height+15+titleHeight+20);
    
    
    
    self.bottomContainerView = [[UIView alloc]initWithFrame:frame];
    if (!self.footMask) {
        [self.bottomContainerView setBackgroundColor:[UIColor whiteColor]];
    } else {
        [self.bottomContainerView setBackgroundColor:[UIColor clearColor]];

    }
    [self.bottomContainerView addSubview:titleLabel];
    [self.bottomContainerView addSubview:textBackView];
    if (!showAll&&originRemark.length>=40) {
        CGRect showAllBtFrame = CGRectMake(width-90, labelsize.height/2+10+titleHeight, 80, labelsize.height/2+10);
        UIButton* showAllBt = [[UIButton alloc]initWithFrame:showAllBtFrame];
        [showAllBt setImage:[UIImage imageNamed:@"查看全部"] forState:UIControlStateNormal];
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
    
    
    [self.isImportantBt setSelected:question.isHighlight_.integerValue==1];

    
    [self.bottomContainerView setHidden:self.headerView.hidden];
    if (self.footToolView) {
        [self.view bringSubviewToFront:self.footToolView];
    }
    [self.isImportantBt setSelected:question.isHighlight_.boolValue];
    if (question.remark_.length>0) {
        [self.footMask setImage:[UIImage imageNamed:@"底部渐变蒙版有文字"]];
        self.footMaskHeight.constant = 128;
    } else {
        [self.footMask setImage:[UIImage imageNamed:@"文字渐变蒙版"]];
        self.footMaskHeight.constant = 64;
    }
    [self.view layoutIfNeeded];
}



- (IBAction)addToImportant:(id)sender
{
    UIButton* selectBt = (UIButton*)sender;
    [selectBt setSelected:!selectBt.isSelected];
    QuestionBook* book = [QuestionBook getInstance];
    MQuestion* mQuestion = [self.questionList objectAtIndex:self.currentPage];
    Question* question = [book getQuestionByMQuestion:mQuestion];
    question.is_highlight = question.is_highlight.boolValue?[NSNumber numberWithBool:NO]:[NSNumber numberWithBool:YES];
    mQuestion.isHighlight_ = question.is_highlight;
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
    
}


- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    keyboardHeight = keyboardSize.height>=240?keyboardSize.height:240;
    [ToolUtils setKeyboardHeight:[NSNumber numberWithDouble:keyboardHeight]];
    CGRect frame = self.editView.frame;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.editView.transform = CGAffineTransformMakeTranslation(0, -frame.size.height-(keyboardHeight==0?240:keyboardHeight));
    } completion:^(BOOL finished) {
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
    [self addBottomView:((MQuestion*)[self.questionList objectAtIndex:self.currentPage]) showAll:NO];
}


- (void) keyboardWasHidden:(NSNotification *) notif
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.editView.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark -scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==self.scrollView) {
        NSLog(@"the is %f  %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
        int index= round(scrollView.contentOffset.x/scrollView.frame.size.width);
        
        if (self.currentPage!=index) {
            self.currentPage = index;
            [self updateProgressBarAndTitle];
            if (self.currentPage<self.questionList.count) {
                QuestionView* view = [self.questionViews objectAtIndex:self.currentPage];
                [self addBottomView:view.myQuestion showAll:NO];
            } else {
                self.currentPage--;
                [self performSegueWithIdentifier:@"complete" sender:nil];
            }
        }
    }
}

-(void)updateProgressBarAndTitle
{
    CGFloat width = self.progressBar.frame.size.width;
    self.progressBar.transform = CGAffineTransformMakeTranslation(width*((self.currentPage+1)/(self.questionList.count+0.0)), 0);
    [self setTitle:[NSString stringWithFormat:@"%@(%d/%d)",self.reviewType,self.currentPage+1,self.questionList.count]];
}


- (void)photoViewImageFinishLoad:(MJPhotoView *)photoView
{
    self.scrollView.contentSize = CGSizeMake(self.questionList.count*self.view.frame.size.width, 0);
    if (photoView.photo.index==0) {
        MQuestion* question = ((QuestionView*)photoView).myQuestion;
        [self addBottomView:question showAll:NO];
        if (photoView.imageView.frame.origin.y<0) {
            photoView.imageView.frame = photoView.bounds;
        }
    }
}

#pragma mark -MJPhotoDelegate
- (void)photoViewSingleTap:(MJPhotoView *)photoView
{
    if (self.footMask) {
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
        [[UIApplication sharedApplication] setStatusBarHidden:alpha!=0];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"complete"]) {
        SignVC* nextVC = (SignVC*)segue.destinationViewController;
        nextVC.subject = self.subject;
        nextVC.reviewCount = self.questionList.count;
    }
}


@end
