//
//  RecommandVC.m
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "RecommandVC.h"
#import "QuestionView.h"
#import "MQuestion.h"
#import "Question.h"
#import "CoreDataHelper.h"
#import "QuestionBook.h"
#import "MReturn.h"
#import "MUploadQues.h"
@interface RecommandVC ()<QuestionViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong)NSMutableArray* questionViews;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic)NSInteger currentIndex;
@property (nonatomic,strong)Question* recommandQuestion;
@property (nonatomic,strong)UIView* bottomContainerView;

@end

@implementation RecommandVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initQuestions];
    self.scrollView.delegate = self;
    [self.scrollView setPagingEnabled:YES];
    
    
    // Do any additional setup after loading the view.
}



#pragma mark -ButtonAction
- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)save:(id)sender {
    MQuestion* currentQuestion = [self.questionList objectAtIndex:self.currentIndex];
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
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initQuestions
{
    self.questionViews = [[NSMutableArray alloc]init];

    
    CGSize pageScrollViewSize = self.view.frame.size;
    self.scrollView.contentSize = CGSizeMake(pageScrollViewSize.width * self.questionList.count, 0);
    self.questionViews = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < self.questionList.count; i++) {
        CGRect frame;
        frame.origin.x = self.view.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.view.frame.size;
        QuestionView* view = [[QuestionView alloc]initWithFrame:frame];
        view.myQuestion = [self.questionList objectAtIndex:i];
        view.myDelegate = self;
        view.editable = @"NO";
        [view setBackgroundColor:[UIColor whiteColor]];
        [self.scrollView addSubview:view];
        [self.questionViews addObject:view];
    }
}


#pragma mark -scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==self.scrollView) {
        int index=scrollView.contentOffset.x/scrollView.frame.size.width;
        self.currentIndex = index;
    }
}



#pragma mark -QuestionView Delegate
- (void)handleKeyBoard
{
    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, 0);
}

- (void)adaptToHeight:(CGFloat)height textView:(UITextView *)noteView
{
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width*self.questionList.count, height);
    
    
    if (self.bottomContainerView) {
        [self.bottomContainerView removeFromSuperview];
    }
    
    CGRect screenFrame = [[UIScreen mainScreen] bounds];

    CGRect frame = CGRectMake(0, screenFrame.size.height - noteView.frame.size.height-50, screenFrame.size.width, noteView.frame.size.height+50);
    
    
    
    self.bottomContainerView = [[UIView alloc]initWithFrame:frame];
    [self.bottomContainerView setBackgroundColor:[UIColor blackColor]];
    [self.bottomContainerView setAlpha:0.5];
    [noteView setBackgroundColor:[UIColor clearColor]];
    [noteView setEditable:NO];
    [noteView setTextColor:[UIColor whiteColor]];
    [self.bottomContainerView addSubview:noteView];

    [self.view addSubview:self.bottomContainerView];
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
