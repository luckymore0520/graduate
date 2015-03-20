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

@interface RecordVC ()<UIScrollViewDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *isImportantBt;

@end

@implementation RecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hasTitle = NO;
    self.title = @"我的错题";
    self.bottomHeight = 45;
}


- (void)viewDidAppear:(BOOL)animated
{
    [self initQuestions];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (IBAction)delete:(id)sender {
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除照片" otherButtonTitles:nil, nil] ;
    [actionSheet showInView:self.view];     
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
        [self.bottomView setAlpha:alpha==0?1:0];
    }];
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

#pragma mark -ActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [ToolUtils showToast:@"删除成功" toView:self.view];
        MQuestion* currentQuestion = [self.questionList objectAtIndex:self.currentPage];
        MQuesDelete* delete = [[MQuesDelete alloc]init];
        [delete load:self id:currentQuestion.id_];
        
        QuestionBook* book = [QuestionBook getInstance];
        Question* question = [book getQuestionByMQuestion:currentQuestion];
        if (question.is_recommand.integerValue==1) {
            [ToolUtils deleteFile:question.questionid];
        }
        [[QuestionBook getInstance]deleteQuestion:question];
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
}

- (void)addBottomView:(NSString *)remark showAll:(BOOL)showAll
{
    [super addBottomView:remark showAll:showAll];
    
    MQuestion* question = [self.questionList objectAtIndex:self.currentPage];

    [self.isImportantBt setSelected:question.isHighlight_.integerValue==1];
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



@end
