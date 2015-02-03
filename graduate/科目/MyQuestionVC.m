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
#import "MQuesList.h"
@interface MyQuestionVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *photoView;
@property (nonatomic) NSInteger day;
@end

@implementation MyQuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myQuestions =
    [NSMutableArray arrayWithArray:[[QuestionBook getInstance]getQuestionOfType:self.type]];
    [self.myQuestions sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString* a = [obj1 objectForKey:@"day"];
        NSString* b = [obj2 objectForKey:@"day"];
        return  [b compare:a];
    }];
//    [self.photoView reloadData];

    
    if (self.shoudUpdate) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSInteger currentDay = [ToolUtils getCurrentDay].integerValue;
        NSTimeInterval secondsPerDay1 = 24*60*60;
        NSDate* now = [NSDate date];
        self.day = currentDay;
        NSDate* currentDate = [now addTimeInterval:(self.day-currentDay)*secondsPerDay1];
        [[[MQuesList alloc]init]load:self type:self.type date:[dateFormatter stringFromDate:currentDate]];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    
    if ([names isEqualToString:@"MQuesList"]) {
        BOOL hasInsert = NO;
        QuestionBook* book = [QuestionBook getInstance];
        MQuestionList* list = [MQuestionList objectWithKeyValues:data];
        for (MQuestion* question in list.list_) {
            BOOL has = NO;
            for (Question* localQuestion in [book.allQuestions objectAtIndex:self.type-1]) {
                if ([localQuestion.questionid isEqualToString:question.id_]) {
                    has = YES;
                    break;
                }
            }
            if (!has) {
//                [book insertQuestionFromRecommand:question];
                [book insertQuestionFromServer:question day:self.day];
                hasInsert=YES;
            }
        }
        if ((hasInsert||list.list_.count==0)&&self.day>0) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSInteger currentDay = [ToolUtils getCurrentDay].integerValue;
            NSTimeInterval secondsPerDay1 = 24*60*60;
            NSDate* now = [NSDate date];
            self.day--;
            NSDate* currentDate = [now addTimeInterval:(self.day-currentDay)*secondsPerDay1];
            [[[MQuesList alloc]init]load:self type:self.type date:[dateFormatter stringFromDate:currentDate]];
        } else {
            
            self.myQuestions =
            [NSMutableArray arrayWithArray:[[QuestionBook getInstance]getQuestionOfType:self.type]];
            [self.photoView reloadData];
        }
        
        
    }
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
        [cell.imgView sd_setImageWithURL:[ToolUtils getImageUrlWtihString:question.img width:150 height:150]];
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
