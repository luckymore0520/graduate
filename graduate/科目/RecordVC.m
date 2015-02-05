//
//  RecordVC.m
//  graduate
//
//  Created by luck-mac on 15/1/26.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "RecordVC.h"
#import "MQuesDelete.h"
#import "MReturn.h"

@interface RecordVC ()<UIScrollViewDelegate>

@end

@implementation RecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.canEdit = YES;
    self.title = @"我的错题";
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
    MQuesDelete* delete = [[MQuesDelete alloc]init];
    [delete load:self id:currentQuestion.id_];
    
    QuestionBook* book = [QuestionBook getInstance];
    Question* question = [book getQuestionByMQuestion:currentQuestion];
    if (question.is_recommand.integerValue==1) {
        [ToolUtils deleteFile:question.questionid];
    }
    
    
    
    question.img = @"";
    [book save];

    [[book.allQuestions objectAtIndex:currentQuestion.type_.integerValue-1]removeObject:question];

    
    
    if (self.questionList.count==1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        
        
        QuestionView* removeView = [self.questionViews objectAtIndex:self.currentPage];
        
        if (self.currentPage+1==self.questionViews.count) {
            self.currentPage--;
            [self.questionList removeObject:currentQuestion];
            self.scrollView.contentSize=CGSizeMake(self.scrollView.frame.size.width*self.questionList.count, 0);
            self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width*self.currentPage, 0);
            [removeView removeFromSuperview];
            
            
            
        } else {
            for (int i = self.currentPage+1 ;i < self.questionViews.count;i++)
            {
                QuestionView* questionView = [self.questionViews objectAtIndex:i];
                CGRect frame = questionView.frame;
                frame.origin.x = frame.origin.x-self.scrollView.frame.size.width;
                questionView.frame = frame;
                [self.questionList removeObject:currentQuestion];
                [self.questionViews removeObject:removeView];
                [removeView removeFromSuperview];
                self.scrollView.contentSize = CGSizeMake(self.questionViews.count*self.scrollView.frame.size.width, 0);

            }
        }

    }
    
    
     
}


- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MQuesDelete"]) {
        MReturn* ret = [MReturn objectWithKeyValues:data];
        if (ret.code_.integerValue==1) {
            NSLog(@"删除成功");
        }
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
