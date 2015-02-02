//
//  ReviewVC.m
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "ReviewVC.h"
#import "Question.h"
#import "QuestionView.h"
#import "QuestionBook.h"
@interface ReviewVC ()<UIScrollViewDelegate,QuestionViewDelegate>
@property (weak, nonatomic) IBOutlet UIPageControl *pageControll;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray* questionViews;
@end

@implementation ReviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.pagingEnabled=YES;
    [self loadQuestions];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#warning 该方法用于加载需要复习的问题，问题来源于dataArray，由前一个Controller给出
- (void)loadQuestions
{
    self.questionViews = [[NSMutableArray alloc]init];
    
    self.pageControll.numberOfPages = self.questionList.count;
    CGSize pageScrollViewSize = self.view.frame.size;
    self.scrollView.contentSize = CGSizeMake(pageScrollViewSize.width, 0);
    self.questionViews = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < self.questionList.count; i++) {
        CGRect frame;
        frame.origin.x = self.view.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.view.frame.size;
        QuestionView* view = [[QuestionView alloc]initWithFrame:frame];
        
        
        MQuestion* question = [self.questionList objectAtIndex:i];
        if (question.isRecommend_.integerValue!=0) {
            view.img =  [UIImage imageWithData:[ToolUtils loadData:question.id_]];
        }
        
        view.myQuestion = question;
//        view.myQuestion = [QuestionBook ];
        view.myDelegate = self;
        [view setBackgroundColor:[UIColor whiteColor]];
        [self.scrollView addSubview:view];
        [self.questionViews addObject:view];
    }


}





-(void)pageChange:(UIPageControl *)sender{
    NSInteger currentPage = self.pageControll.currentPage;
    currentPage++;
    if (currentPage<self.pageControll.numberOfPages) {
        self.pageControll.currentPage = currentPage;
        CGFloat offset= self.pageControll.currentPage*self.view.frame.size.width;
        [self.scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    } else {
        [self performSegueWithIdentifier:@"complete" sender:nil];
    }
   
}



#pragma mark ButtonAction
//已掌握
- (IBAction)hasKnownAction:(id)sender {
    [self pageChange:nil];
#warning 此处需要调用已掌握的接口
}

//未掌握
- (IBAction)notKnowAction:(id)sender {
    [self pageChange:nil];
#warning 此处需要调用未掌握的接口

}


#pragma mark QuestionViewDelegate
- (void)handleKeyBoard
{
    CGPoint point = self.scrollView.contentOffset;
    point.y = 0 ;
    self.scrollView.contentOffset = point;
}


- (void)adaptToHeight:(CGFloat)height
{
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, height);
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
