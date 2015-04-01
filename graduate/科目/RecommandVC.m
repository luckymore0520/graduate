//
//  RecommandVC.m
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "RecommandVC.h"
#import "MQuesDelete.h"
@interface RecommandVC ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic,strong)NSString* currentDay;
@property (nonatomic)NSUInteger currentContent;
@end


@implementation RecommandVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scrollView setPagingEnabled:YES];
    self.scrollView.delegate = self;
    self.bottomHeight = 40;
    [self setTitle:@"大神笔记"];
    self.hasTitle = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.currentDay = [ToolUtils getCurrentDate];
    self.currentContent = 0;
    if (self.currentDay) {
        [self updateDateLabel:self.currentDay];
    }
 
}

-(void) updateDateLabel:(NSString*)day
{
    if (day==nil) {
        return;
    }
    day = [day stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    NSArray* seperators = [day componentsSeparatedByString:@"-"];
    [self.dateLabel setText:[NSString stringWithFormat:@"%@月%@日",seperators[1],seperators[2]]];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.questionList) {
        [self initQuestions];
    } else {
        [[[MQuestionRecommand alloc]init]load:self date:self.currentDay];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}


#pragma mark -ButtonAction
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO];

}


- (IBAction)save:(id)sender {
    if (!self.questionList||self.questionList.count==0) {
        [ToolUtils showError:@"今日推荐为空" toView:self.view];
        return;
    }
    UIButton* button = (UIButton*)sender;
    [button setSelected:!button.isSelected];
    MQuestion* currentQuestion = [self.questionList objectAtIndex:self.currentPage];
    Question* question =[[QuestionBook getInstance]getQuestionByMQuestion:currentQuestion];
    if (question) {
        [[QuestionBook getInstance]deleteQuestion:question];
        [ToolUtils showToast:@"已取消收藏"  toView:self.view];
        [[[MQuesDelete alloc]init]load:self id:currentQuestion.id_ ];
    } else {
        currentQuestion.createTime_ = [ToolUtils getCurrentDate];
        self.recommandQuestion = [[QuestionBook getInstance] insertQuestionFromRecommand:currentQuestion];
        if (self.recommandQuestion) {
            [ToolUtils showToast:[NSString stringWithFormat:@"已收藏至%@笔记本",            currentQuestion.subject_
]  toView:self.view];
            if (!self.recommandQuestion.isUpload.boolValue) {
                self.recommandQuestion.isUpload = [NSNumber numberWithBool:YES];
                [[[MUploadQues alloc]init]load:self question:self.recommandQuestion];
            }
        }
    }
}


- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MUploadQues"]) {
        MReturn* ret  = [MReturn objectWithKeyValues:data];
        if (ret.code_.integerValue==1) {
            CoreDataHelper* helper = [CoreDataHelper getInstance];
            NSError* error;
            BOOL isSaveSuccess=[helper.managedObjectContext save:&error];
            if (!isSaveSuccess) {
                self.recommandQuestion.isUpload = [NSNumber numberWithBool:NO];
                NSLog(@"Error:%@",error);
            }else{
                NSLog(@"Save successful! Upload the question");
            }
        }
        NSLog(@"%@",ret.msg_);
    } else if ([names isEqualToString:@"MQuesRecommend"])
    {
        
        MQuestionList* questionList = [MQuestionList objectWithKeyValues:data];
        if (self.questionList) {
            self.currentContent = self.questionList.count;
            [self.questionList addObjectsFromArray:questionList.list_];
        } else {
            self.questionList = questionList.list_;
        }
        [self initQuestions];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



-(void)initQuestions
{
    self.questionViews = [[NSMutableArray alloc]init];
    CGSize pageScrollViewSize = self.view.frame.size;
    self.scrollView.contentSize = CGSizeMake(pageScrollViewSize.width * self.questionList.count, 0);
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.questionViews = [[NSMutableArray alloc]init];
    for (NSUInteger i = self.currentContent ; i < self.questionList.count; i++) {
        CGRect frame;
        frame.origin.x = self.view.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.view.frame.size;
        QuestionView* view = [[QuestionView alloc]initWithFrame:frame];
        view.myQuestion = [self.questionList objectAtIndex:i];
        view.photoViewDelegate = self;
        view.orientation = view.myQuestion.orientation==nil?[NSNumber numberWithInt:1]:view.myQuestion.orientation;
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
    if (self.currentQuestionId) {
        for (int i = 0  ; i < self.questionList.count ; i ++) {
            MQuestion* question = [self.questionList objectAtIndex:i];
            if ([question.id_ isEqualToString:self.currentQuestionId]) {
                self.scrollView.contentOffset= CGPointMake(i*self.scrollView.frame.size.width, 0);
                self.currentPage = i;
                [self addBottomView:question showAll:NO];
                return;
            }
        }
    }
}


#pragma mark -scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==self.scrollView) {
        int index= round(scrollView.contentOffset.x/scrollView.frame.size.width);
        
        if (self.currentPage!=index) {
            self.currentPage = index;
            
            MQuestion* question = [self.questionList objectAtIndex:index];
            if (question.isAd_.integerValue==1) {
                [self.collectBt setHidden:YES];
            } else {
                [self.collectBt setHidden:NO];
            }
            [self updateDateLabel:question.createTime_];
            [self addBottomView:question showAll:NO];
        }
        if (index == self.questionList.count-1) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *currentDay = [dateFormatter dateFromString:_currentDay];
            NSTimeInterval secondsPerDay1 = 24*60*60;
            NSDate *nextDay = [currentDay addTimeInterval:-secondsPerDay1];
            _currentDay = [dateFormatter stringFromDate:nextDay];
            [[[MQuestionRecommand alloc]init]load:self date:self.currentDay];
        }
    }
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



@end
