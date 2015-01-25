//
//  ReviewVC.m
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "ReviewVC.h"
#import "QuestionView.h"
@interface ReviewVC ()<UIScrollViewDelegate,QuestionViewDelegate>
@property (weak, nonatomic) IBOutlet UIPageControl *pageControll;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray* questionViews;
@end

@implementation ReviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled=YES;
    [self loadQuestions];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadQuestions
{
    self.dataArray = [NSArray arrayWithObjects:@"1",@"2",@"3", nil];
    NSInteger pageCount = [self.dataArray count];
    [self.scrollView setPagingEnabled:YES];
    self.pageControll.currentPage = 0;
    self.pageControll.numberOfPages = pageCount;
    CGSize pageScrollViewSize = self.view.frame.size;
    self.scrollView.contentSize = CGSizeMake(pageScrollViewSize.width * self.dataArray.count, 0);
    self.questionViews = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < self.dataArray.count; i++) {
        CGRect frame;
        frame.origin.x = self.view.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.view.frame.size;
        QuestionView* view = [[QuestionView alloc]initWithFrame:frame];
        view.myDelegate = self;
        [view setBackgroundColor:[UIColor whiteColor]];
        [view initLayout];
        [self.scrollView addSubview:view];
        [self.questionViews addObject:view];
    }


}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==self.scrollView) {
        int index=scrollView.contentOffset.x/scrollView.frame.size.width;
        self.pageControll.currentPage=index;
    }
}




-(void)pageChange:(UIPageControl *)sender{
    if (self.pageControll.currentPage<self.pageControll.numberOfPages) {
        self.pageControll.currentPage = self.pageControll.currentPage+1;
        CGFloat offset= self.pageControll.currentPage*self.view.frame.size.width;
        [self.scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    }
   
}

- (IBAction)hasKnownAction:(id)sender {
    [self pageChange:nil];
}
- (IBAction)notKnowAction:(id)sender {
    [self pageChange:nil];
}



- (void)handleKeyBoard
{
    CGPoint point = self.scrollView.contentOffset;
    point.y = 0 ;
    self.scrollView.contentOffset = point;
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
