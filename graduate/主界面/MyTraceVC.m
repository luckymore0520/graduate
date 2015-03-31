//
//  MyTraceVC.m
//  graduate
//
//  Created by luck-mac on 15/1/26.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MyTraceVC.h"
#import "QuestionBook.h"
#import "QuestionCell.h"
#import "TraceHeaderView.h"
#import "QuestionHeaderView.h"
#import "RecordVC.h"
#import "MQuesList.h"
#import "Sign.h"
@interface MyTraceVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *questionView;
@property (nonatomic,strong)NSMutableArray* myQuestions;
@property (nonatomic,assign)NSInteger phoneOfLine;
@property (nonatomic,strong)TraceHeaderView* header;
@end

@implementation MyTraceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _phoneOfLine = 5;
    [self loadQuestion];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        ApiHelper* api = [[ApiHelper alloc]init];
        api.fileId = self.trace.songName;
        [api download:self url:[ToolUtils getImageUrlWtihString:self.trace.musicFile].absoluteString];
    }
}



- (void)loadQuestion
{
    self.myQuestions =
    [NSMutableArray arrayWithArray:[[QuestionBook getInstance]getQuestionByDay:self.trace.myDay]];
    NSUInteger total = 0 ;
    for (NSDictionary* dic in self.myQuestions) {
        total = total + [[dic objectForKey:@"array"] count];
    }
    if (self.shoudUpdate||total<self.trace.addCount.integerValue) {
        [[[MQuesList alloc]init]load:self type:0 date:self.trace.date];
    }
    if (total>=self.trace.addCount.integerValue) {
        self.trace.addCount = [NSNumber numberWithInteger:total];
    }
    NSArray* signList = [CoreDataHelper query:[NSPredicate predicateWithFormat:@"userid=%@",[ToolUtils getUserid]] tableName:@"Sign"];
    int signCount = 0;
    for (Sign* sign in signList) {
        if (sign.myDay.integerValue<=self.trace.myDay.integerValue) {
            signCount = signCount+1;
            if (sign.myDay.integerValue == self.trace.myDay.integerValue) {
                self.trace.reviewCount = sign.reviewCount;
            }
        }
    }
    self.trace.signCount = MAX(self.trace.signCount,[NSNumber numberWithInteger:signCount]);
    [self.questionView reloadData];
}

- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MQuesList"]) {
        QuestionBook* book = [QuestionBook getInstance];
        MQuestionList* list = [MQuestionList objectWithKeyValues:data];
        for (MQuestion* question in list.list_) {
            BOOL has = NO;
            for (Question* localQuestion in [book getQuestionListByDay:self.trace.myDay]) {
                if ([localQuestion.questionid isEqualToString:question.id_]) {
                    has = YES;
                    break;
                }
            }
            if (!has) {
                [book insertQuestionFromServer:question day:self.trace.myDay.integerValue];
            }
        }
        self.shoudUpdate = NO;
        
        self.myQuestions =
        [NSMutableArray arrayWithArray:[[QuestionBook getInstance]getQuestionByDay:self.trace.myDay]];
        [self.questionView reloadData];
    } 
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    NSUInteger count = [[[self.myQuestions objectAtIndex:section-1] objectForKey:@"array"] count];
    if (count%(_phoneOfLine-1)==0) {
        return count/(_phoneOfLine-1)*_phoneOfLine;
    } else {
        return count/(_phoneOfLine-1)*_phoneOfLine+count%(_phoneOfLine-1)+1;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.myQuestions.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%_phoneOfLine==0) {
        static NSString * CellIdentifier = @"subject";
        QuestionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        if (indexPath.row==0) {
            NSString* subject = [[self.myQuestions objectAtIndex:indexPath.section-1]objectForKey:@"subject"];
            if (subject.length>3) {
                subject = [subject substringToIndex:2];
            }
            [cell.titleLabel setText:subject];
        }
        return cell;
    } else {
        static NSString * CellIdentifier = @"picture";
        QuestionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        Question* question = (Question*)[[[self.myQuestions objectAtIndex:indexPath.section-1]objectForKey:@"array"]objectAtIndex:indexPath.row/_phoneOfLine*(_phoneOfLine-1)+indexPath.row%_phoneOfLine-1];
        if (question.is_recommand.integerValue==0) {
            [cell.imgView sd_setImageWithURL:[ToolUtils getImageUrlWtihString:question.img width:150 height:150] placeholderImage:[UIImage imageNamed:@"placeholder"]] ;
        } else {
            if (question.thumb_img) {
                [cell.imgView setImage:[UIImage imageWithData:[ToolUtils loadData:question.thumb_img]]];
            } else {
                [cell.imgView setImage:[UIImage imageWithData:[ToolUtils loadData:question.questionid]]];
            }
        }
        if (question.is_highlight.integerValue==1) {
            [cell setIsStar:YES];
            [cell.stateImg setHidden:NO];
        } else {
            [cell.stateImg setHidden:YES];
        }
        switch (question.orientation.integerValue) {
            case 1:
                cell.imgView.transform = CGAffineTransformMakeRotation(0);
                break;
            case 2:
                cell.imgView.transform = CGAffineTransformMakeRotation(-M_PI_2);
                break;
            case 3:
                cell.imgView.transform = CGAffineTransformMakeRotation(M_PI);
                break;
            case 4:
                cell.imgView.transform = CGAffineTransformMakeRotation(M_PI_2);
                break;
            default:
                break;
        }
        return cell;
    }
}


- (IBAction)backToMain:(id)sender {
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  
    return CGSizeMake(60, 60);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section!=0) {
        return CGSizeMake(0, 0);
    }
    return CGSizeMake(self.view.frame.size.width, 372);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%_phoneOfLine==0) {
        return;
    }
    RecordVC* record = [self.storyboard instantiateViewControllerWithIdentifier:@"QuestionDetail"];
    NSMutableArray* mQuestionList = [[NSMutableArray alloc]initWithCapacity:self.myQuestions.count];
    for (NSDictionary* questionDic in self.myQuestions) {
        for (Question* question in [questionDic objectForKey:@"array"]) {
            [ mQuestionList addObject:[[QuestionBook getInstance]changeFromMQuestion:question]];
        }
    }
    record.questionList = mQuestionList;
    Question* question = (Question*)[[[self.myQuestions objectAtIndex:indexPath.section-1]objectForKey:@"array"]objectAtIndex:indexPath.row/_phoneOfLine*(_phoneOfLine-1)+indexPath.row%(_phoneOfLine)-1];
    record.currentQuestionId = question.questionid;
    [self.myDelegate pushDetailVC:record];
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if ( kind == UICollectionElementKindSectionHeader && indexPath.section==0 ) {
        TraceHeaderView* header = [ collectionView dequeueReusableSupplementaryViewOfKind : UICollectionElementKindSectionHeader withReuseIdentifier : @ "myHeader" forIndexPath : indexPath ] ;
        [header initViewWithTrace:self.trace];
        return header;
    }
    return nil;
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
