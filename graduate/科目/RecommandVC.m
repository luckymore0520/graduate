//
//  RecommandVC.m
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "RecommandVC.h"

@interface RecommandVC ()


@end

@implementation RecommandVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scrollView setPagingEnabled:YES];
    self.scrollView.delegate = self;
    self.bottomHeight = 0;
    self.canEdit = NO;
    // Do any additional setup after loading the view.
}


- (void) viewWillAppear:(BOOL)animated
{
    
}
- (void)viewDidAppear:(BOOL)animated
{
    if (self.questionList) {
        [self initQuestions];
    } else {
        [[[MQuestionRecommand alloc]init]load:self];
    }
}

#pragma mark -ButtonAction
- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)save:(id)sender {
    MQuestion* currentQuestion = [self.questionList objectAtIndex:self.currentPage];
    self.recommandQuestion = [[QuestionBook getInstance] insertQuestionFromRecommand:currentQuestion];
    if (self.recommandQuestion) {
        [ToolUtils showMessage:@"收藏成功"];
        if (!self.recommandQuestion.isUpload.boolValue) {
            self.recommandQuestion.isUpload = [NSNumber numberWithBool:YES];
            [[[MUploadQues alloc]init]load:self question:self.recommandQuestion];
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
        self.questionList = questionList.list_;
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
    for (int i = 0 ; i < self.questionList.count; i++) {
        CGRect frame;
        frame.origin.x = self.view.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.view.frame.size;
        QuestionView* view = [[QuestionView alloc]initWithFrame:frame];
        view.myQuestion = [self.questionList objectAtIndex:i];
        view.photoViewDelegate = self;
        MJPhoto *photo = [[MJPhoto alloc] init];
        MQuestion* question = [self.questionList objectAtIndex:i];
        NSString *imageUrl = [ToolUtils getImageUrlWtihString:question.img_ width:640 height:0].absoluteString;
        NSString *url = [imageUrl stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
                NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)url, NULL, NULL,  kCFStringEncodingUTF8 ));
        photo.url = [NSURL URLWithString:encodedString]; // 图片路径
        photo.desc = question.remark_;
        photo.index = i;
        view.photo = photo;
        [view setBackgroundColor:[UIColor blackColor]];
        [self.questionViews addObject:view];
    }
}


#pragma mark -scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==self.scrollView) {
        int index= round(scrollView.contentOffset.x/scrollView.frame.size.width);
        if (self.currentPage!=index) {
            self.currentPage = index;
            MQuestion* question = [self.questionList objectAtIndex:index];
            [self addBottomView:question.remark_ showAll:NO];
        }
    }
}


- (void)photoViewImageFinishLoad:(MJPhotoView *)photoView
{
    [self.scrollView addSubview:photoView];
    self.scrollView.contentSize = CGSizeMake(self.questionList.count*self.view.frame.size.width, 0);
    if (photoView.photo.index==0) {
        MQuestion* question = ((QuestionView*)photoView).myQuestion;
        [self addBottomView:question.remark_ showAll:NO];
    }
    
}



@end
