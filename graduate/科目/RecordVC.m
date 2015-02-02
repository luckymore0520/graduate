//
//  RecordVC.m
//  graduate
//
//  Created by luck-mac on 15/1/26.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "RecordVC.h"

@interface RecordVC ()<UIScrollViewDelegate>

@end

@implementation RecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.canEdit = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self initQuestions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)returnToMain:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (IBAction)delete:(id)sender {
    
    MQuestion* currentQuestion = [self.questionList objectAtIndex:self.currentPage];
    QuestionBook* book = [QuestionBook getInstance];
    Question* question = [book getQuestionByMQuestion:currentQuestion];
    if (question.is_recommand.integerValue==1) {
        [ToolUtils deleteFile:question.questionid];
    }
    
    
    question.img = @"";
    [book save];

    NSInteger nextPage = (self.currentPage+1==self.questionList.count)?self.currentPage-1:self.currentPage;
    
    [self.questionList removeObject:currentQuestion];
    
    [[book.allQuestions objectAtIndex:currentQuestion.type_.integerValue-1]removeObject:question];
    
    
    
    [self loadQuestions];
    if (nextPage>=0) {
        [self.scrollView setContentOffset:CGPointMake(nextPage*self.view.frame.size.width, 0) animated:YES];
    }
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
