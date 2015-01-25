//
//  RecommandVC.m
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "RecommandVC.h"
#import "QuestionView.h"
@interface RecommandVC ()<QuestionViewDelegate>
@property (nonatomic,strong)NSMutableArray* questionViews;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic)NSInteger currentIndex;
@end

@implementation RecommandVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.questionList = [NSArray arrayWithObjects:@"1",@"2", @"3",nil];
    
    [self initQuestions];
    // Do any additional setup after loading the view.
}
- (IBAction)showNext:(id)sender {
    QuestionView* currentView = [self.questionViews objectAtIndex:self.currentIndex];
    if (self.currentIndex<self.questionViews.count-1) {
        [currentView removeFromSuperview];
        self.currentIndex++;
        QuestionView* newView =[self.questionViews objectAtIndex:self.currentIndex];
        newView.frame = currentView.frame;
        [self.scrollView addSubview:newView];
        self.scrollView.contentSize = CGSizeMake(0, newView.frame.size.height);
        NSLog(@"%lf",newView.frame.size.height);
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
  
}

-(void)initQuestions
{
    self.questionViews = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < self.questionList.count; i++) {
        QuestionView* view = [[QuestionView alloc]initWithFrame:self.view.frame];
        view.myDelegate = self;
        [view setBackgroundColor:[UIColor whiteColor]];
        [view initLayout];
        [self.questionViews addObject:view];
        
    }
    QuestionView* firstView = [self.questionViews firstObject];
    [self.scrollView addSubview:firstView];
    self.scrollView.contentSize = CGSizeMake(0, firstView.frame.size.height);
    self.currentIndex = 0;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)handleKeyBoard
{
    self.scrollView.contentOffset = CGPointMake(0, 0);
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
