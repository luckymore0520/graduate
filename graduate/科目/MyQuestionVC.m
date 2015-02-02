//
//  MyQuestionVC.m
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MyQuestionVC.h"
#import "QuestionBook.h"
#import "QuestionCell.h"
#import "QuestionHeaderView.h"
#import "UIImageView+WebCache.h"
#import "ReviewVC.h"
#import "RecordVC.h"
@interface MyQuestionVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *photoView;

@end

@implementation MyQuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)viewWillAppear:(BOOL)animated
{
    self.myQuestions =
    [NSMutableArray arrayWithArray:[[QuestionBook getInstance]getQuestionOfType:self.type]];
    [self.myQuestions sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString* a = [obj1 objectForKey:@"day"];
        NSString* b = [obj2 objectForKey:@"day"];
        return  [b compare:a];
    }];
    [self.photoView reloadData];
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)reviewModelAction:(id)sender {
    [self performSegueWithIdentifier:@"reviewMyQuestion" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray* arr = [[self.myQuestions objectAtIndex:section]objectForKey:@"array"];
    return arr.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.myQuestions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * CellIdentifier = @"picture";
    QuestionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    Question* question = (Question*)[[[self.myQuestions objectAtIndex:indexPath.section]objectForKey:@"array"]objectAtIndex:indexPath.row];
    if (question.is_recommand.integerValue==0) {
        [cell.imgView sd_setImageWithURL:[ToolUtils getImageUrlWtihString:question.img]];
    } else {
        [cell.imgView setImage:[UIImage imageWithData:[ToolUtils loadData:question.questionid]]];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(75, 75);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"showDetail" sender:nil];
 
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    QuestionHeaderView * reusableview = nil ;

    if ( kind == UICollectionElementKindSectionHeader ) {
       reusableview = [ collectionView dequeueReusableSupplementaryViewOfKind : UICollectionElementKindSectionHeader withReuseIdentifier : @ "HeaderView" forIndexPath : indexPath ] ;
        Question* question = [[[self.myQuestions objectAtIndex:indexPath.section]objectForKey:@"array"]objectAtIndex:0];
        [reusableview.dateLabel setText:[NSString stringWithFormat:@"%@ 第%@天",question.create_time,question.myDay]];
    }
    return reusableview;
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"reviewMyQuestion"]) {
        ReviewVC* reviewVC = [segue destinationViewController];
//        reviewVC.questionList = self.myQuestions;
        reviewVC.questionList = [[QuestionBook getInstance] getMQuestionsOfType:self.type];
    } else if ([segue.identifier isEqual:@"showDetail"])
    {
        RecordVC* recordVC = [segue destinationViewController];
        recordVC.questionList = [[QuestionBook getInstance] getMQuestionsOfType:self.type];
        

    }
}


@end
