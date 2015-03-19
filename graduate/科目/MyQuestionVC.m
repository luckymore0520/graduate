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
#import "MQuesDelete.h"
#import "Subject.h"
#import "ButtonGroup.h"
#import "UIImage+Resize.h"
@interface MyQuestionVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *photoView;
@property (nonatomic,strong)NSMutableArray* selectedArray;
@property (nonatomic) NSInteger day;
@property (nonatomic)BOOL firstShow;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIView *reviewBtView;
@property (weak, nonatomic) IBOutlet ButtonGroup *transferView;
@property (strong,nonatomic) NSMutableArray* questionsToShow;
@property (weak, nonatomic) IBOutlet UIButton *subjectBt1;
@property (weak, nonatomic) IBOutlet UIButton *subjectBt2;
@property (weak, nonatomic) IBOutlet UIButton *subjectBt3;
@property (nonatomic,strong)NSMutableArray* subjects;
@property (nonatomic)BOOL selectModel;
@property (weak, nonatomic) IBOutlet UIButton *selectAllButton;
@property (weak, nonatomic) IBOutlet UIButton *selectUnReviewButton;
@property (weak, nonatomic) IBOutlet UIButton *selectImportantButton;
@property (weak, nonatomic) IBOutlet UIButton *selectReviewdButton;
@end

@implementation MyQuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    self.firstShow = YES;
    [self addRightButton];
    self.selectModel = NO;
    self.selectedArray  = [[NSMutableArray alloc]init];
    [self.navigationController setNavigationBarHidden:NO];
}


- (void)viewDidAppear:(BOOL)animated
{
    
    if (self.firstShow) {
        self.firstShow = NO;
    } else {
        [self loadData];
        [self.photoView reloadData];
    }
    [self initSubjects];
    CGRect frame = self.view.frame;
    NSLog(@"%lf",frame.origin.y);
}



- (void)initSubjects
{
    NSMutableArray* subjects = [NSMutableArray arrayWithArray:[[QuestionBook getInstance]getMySubjects]];
    self.subjectBt1.tag = -1;
    self.subjectBt2.tag = -1;
    self.subjectBt3.tag = -1;

    NSArray* buttons = [NSArray arrayWithObjects:self.subjectBt1,self.subjectBt2,self.subjectBt3,nil];
    
    [self.transferView loadButton:buttons];
    self.transferView.canbeNull = YES;
    [self.transferView setSelectedIndex:0];
    for (UIButton* button in buttons) {
        [button setTag:-1];
    }
    Subject* currentSubject = nil;
    for (Subject* subject in subjects) {
        if ([subject.name isEqualToString:self.subject]) {
            currentSubject = subject;
        }
    }
    [subjects removeObject:currentSubject];
    self.subjects = subjects;
    for (Subject* subject in self.subjects) {
        for (int i = 0 ; i < buttons.count; i++) {
            UIButton* button = [buttons objectAtIndex:i];
            if (button.tag==-1) {
                [button setTitle:subject.name forState:UIControlStateNormal];
                button.tag = i;
                break;
            }
        }
    }
}

- (void)addRightButton
{
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitle:@"选择" forState:UIControlStateNormal];
    [button setTitle:@"取消" forState:UIControlStateSelected];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectPhotos:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *myAddButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = myAddButton;
}
- (IBAction)showSelectedType:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    [_selectAllButton setSelected:NO];
    [_selectImportantButton setSelected:NO];
    [_selectReviewdButton setSelected:NO];
    [_selectUnReviewButton setSelected:NO];
    [sender setSelected:!sender.selected];
    [self loadData];
    [self.photoView reloadData];
}

- (void)selectPhotos:(id)sender
{
    [self.selectedArray removeAllObjects];
    for (int i = 0 ; i < self.questionsToShow.count; i++) {
        for (int j = 0 ; j < [[[self.questionsToShow objectAtIndex:i] objectForKey:@"array"] count]; j++) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            QuestionCell* cell = (QuestionCell*)[self.photoView cellForItemAtIndexPath:indexPath];
            [cell setSelect:NO];
        }
    }
    [self.reviewBtView setHidden:!self.reviewBtView.hidden];
    [self.selectView setHidden:!self.selectView.hidden];
    [self cancelTransfer:nil];
    self.selectModel = !self.selectModel;
    [self.photoView reloadData];
}
- (void)loadData
{
    self.myQuestions =
    [NSMutableArray arrayWithArray:[[QuestionBook getInstance]getQuestionOfType:self.type]];
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
    self.questionsToShow = [[NSMutableArray alloc]init];
    for (NSDictionary* dic in self.myQuestions) {
        for (Question* question in dic[@"array"]) {
            BOOL shoudShow = NO;
            if (_selectAllButton.selected) {
                shoudShow = YES;
            } else if (_selectReviewdButton.selected) {
                if (question.review_time.integerValue>0) {
                    shoudShow = YES;
                }
            } else if (_selectUnReviewButton.selected) {
                if (question.review_time.integerValue==0) {
                    shoudShow = YES;
                }
            } else if (_selectImportantButton.selected) {
                if (question.is_highlight.integerValue==1) {
                    shoudShow = YES;
                }
            }
            if (shoudShow) {
                BOOL hadDay = NO;
                for (NSDictionary* dicToShow in self.questionsToShow) {
                    if ([dicToShow[@"day"] isEqualToString:dic[@"day"]]) {
                        [dicToShow[@"array"] addObject:question];
                        hadDay = YES;
                        break;
                    }
                }
                if (!hadDay) {
                    NSDictionary* day = @{@"day":question.myDay,@"array":[[NSMutableArray alloc]initWithObjects:question, nil]};
                    [self.questionsToShow addObject:day];
                }
            }
        }
    }
    [self.questionsToShow sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString* a = [obj1 objectForKey:@"day"];
        NSString* b = [obj2 objectForKey:@"day"];
        return  b.integerValue > a.integerValue;
    }];
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
            self.shoudUpdate = NO;
            [self loadData];
            [self.photoView reloadData];
        }
        
        
    } else if ([names isEqualToString:@"MQuesDelete"])
    {
        MReturn* ret = [MReturn objectWithKeyValues:data];
        if (ret.code_.integerValue==1) {
            NSLog(@"删除成功");
        }
    }
}


- (IBAction)reviewModelAction:(id)sender {
    if (self.myQuestions.count==0) {
        [ToolUtils showToast:@"题目为空，无法复习" toView:self.view];
        return;
    }
    [self performSegueWithIdentifier:@"reviewMyQuestion" sender:sender];
}

- (IBAction)transfer:(id)sender {
    if (_selectedArray.count==0) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.transferView.transform = CGAffineTransformMakeTranslation(0, -self.transferView.frame.size.height);
    }];
}


- (IBAction)cancelTransfer:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.transferView.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}
- (IBAction)ensureTransfer:(id)sender {
    [ToolUtils showToast:@"转移成功" toView:self.view];
    if ([self.transferView selectedIndex]==-1) {
        return;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.transferView.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
    Subject* subject = [self.subjects objectAtIndex:[self.transferView selectedIndex]];
    QuestionBook* book = [QuestionBook getInstance];
    [[book.allQuestions objectAtIndex:self.type-1]removeObjectsInArray:self.selectedArray];
    [[book.allQuestions objectAtIndex:subject.type-1]addObjectsFromArray:self.selectedArray];
    
    for (Question* question in self.selectedArray) {
        question.subject = subject.name;
        question.type = [NSNumber numberWithInteger:subject.type];
        question.isUpload = @NO;
    }
    NSMutableArray* shoudRemoveDic = [[NSMutableArray alloc]init];
    for (NSDictionary* dic in self.myQuestions) {
        NSMutableArray* array =  [dic objectForKey:@"array"];
        [array removeObjectsInArray:self.selectedArray];
        if (array.count==0) {
            [shoudRemoveDic addObject:dic];
        }
    }
    [self.myQuestions removeObjectsInArray:shoudRemoveDic];
    [self.photoView reloadData];
    [book save];
    [book updateQuestions];
}


- (IBAction)delete:(id)sender {
    if (_selectedArray.count==0) {
        return;
    }
    UIActionSheet* actionsheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除笔记" otherButtonTitles:nil, nil];
    [actionsheet showInView:[UIApplication sharedApplication].keyWindow];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section<self.questionsToShow.count) {
        NSMutableArray* arr = [[self.questionsToShow objectAtIndex:section]objectForKey:@"array"];
        return arr.count;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.questionsToShow.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * CellIdentifier = @"picture";
    QuestionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell.selectView setHidden:YES];
    Question* question = (Question*)[[[self.questionsToShow objectAtIndex:indexPath.section]objectForKey:@"array"]objectAtIndex:indexPath.row];
    if (question.is_recommand.integerValue==0) {
        [cell.imgView sd_setImageWithURL:[ToolUtils getImageUrlWtihString:question.img width:130 height:130] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    } else {
        UIImage* image;
        if (question.thumb_img) {
            image = [UIImage imageWithData:[ToolUtils loadData:question.thumb_img]];
        } else {
            image = [UIImage imageWithData:[ToolUtils loadData:question.questionid]];
        }
        [cell.imgView setImage:image];
    }
    if (question.is_highlight.integerValue==1) {
        [cell setIsStar:YES];
        [cell.stateImg setHidden:NO];
    } else {
        [cell.stateImg setHidden:YES];
    }
    [cell setSelect:NO];
    for (Question* selectedQuestion in self.selectedArray) {
        if ([selectedQuestion.questionid isEqualToString:question.questionid]) {
            [cell setSelect:YES];
        }
    }
    [cell setSelectMode:_selectModel];
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(65, 65);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.selectModel) {
        RecordVC* detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QuestionDetail"];
        detailVC.questionList = [[QuestionBook getInstance] getMQuestionsOfType:self.type];
        [detailVC.questionList sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            MQuestion* a = (MQuestion*)obj1;
            MQuestion* b = (MQuestion*)obj2;
            return a.myDay_.integerValue < b.myDay_.integerValue;
        }];
        Question* question = [[[self.questionsToShow objectAtIndex:indexPath.section]objectForKey:@"array"]objectAtIndex:indexPath.row];
        detailVC.currentQuestionId = question.questionid;
        [self.navigationController pushViewController:detailVC animated:YES];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
    } else {
        Question* question = (Question*)[[[self.questionsToShow objectAtIndex:indexPath.section]objectForKey:@"array"]objectAtIndex:indexPath.row];
        QuestionCell* cell = (QuestionCell*)[self.photoView cellForItemAtIndexPath:indexPath];
        if ([self.selectedArray indexOfObject:question]== NSNotFound) {
            [self.selectedArray addObject:question];
            NSLog(@"不在里面");
            [cell setSelect:YES];
        } else {
            [self.selectedArray removeObject:question];
            NSLog(@"在里面");
            [cell setSelect:NO];
        }
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    QuestionHeaderView * reusableview = nil ;

    if ( kind == UICollectionElementKindSectionHeader ) {
        reusableview = [ collectionView dequeueReusableSupplementaryViewOfKind : UICollectionElementKindSectionHeader withReuseIdentifier : @ "HeaderView" forIndexPath : indexPath ] ;
        if (indexPath.section<self.myQuestions.count) {
        
            Question* question = [[[self.questionsToShow objectAtIndex:indexPath.section]objectForKey:@"array"]objectAtIndex:0];
            if (question.myDay.integerValue == [[ToolUtils getCurrentDay] integerValue]) {
                [reusableview.dateLabel setText:[NSString stringWithFormat:@"今日 第%@天",question.myDay]];
                [reusableview.dateLabel setTextColor:[UIColor redColor]];
            } else {
                [reusableview.dateLabel setText:[NSString stringWithFormat:@"%@ 第%@天",  [question.create_time stringByReplacingOccurrencesOfString:@"-" withString:@"."],question.myDay]];
                [reusableview.dateLabel setTextColor:[UIColor colorWithHex:0x333333]];
            }
            return reusableview;
        }
    }
    return reusableview;
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"reviewMyQuestion"]) {
        ReviewVC* reviewVC = [segue destinationViewController];
        reviewVC.questionList = [[QuestionBook getInstance] getMQuestionsOfType:self.type];
        reviewVC.subject = self.subject;
        UIButton* button = (UIButton*)sender;
        reviewVC.reviewType = button.titleLabel.text;
    }
}


#pragma mark -ActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        NSMutableArray* shoudRemoveDic = [[NSMutableArray alloc]init];
        for (NSDictionary* dic in self.myQuestions) {
            NSMutableArray* array =  [dic objectForKey:@"array"];
            [array removeObjectsInArray:self.selectedArray];
            if (array.count==0) {
                [shoudRemoveDic addObject:dic];
            }
        }
        [self.myQuestions removeObjectsInArray:shoudRemoveDic];
        NSMutableString* questionIds = [[NSMutableString alloc]init];
        for (Question* question in self.selectedArray) {
            question.img = @"";
            if (question.is_recommand.integerValue==1) {
                [ToolUtils deleteFile:question.questionid];
            }
            [questionIds appendFormat:@"%@,",question.questionid];
            if (question.myDay.integerValue ==[[ToolUtils getCurrentDay] integerValue]) {
                [[QuestionBook getInstance]deleteQuestion:question];
            } else {
                [[[QuestionBook getInstance].allQuestions objectAtIndex:question.type.integerValue-1] removeObject:question];
            }
        }
        [[QuestionBook getInstance]save];
        
        MQuesDelete* delete = [[MQuesDelete alloc]init];
        [delete load:self id:questionIds];
        
        [self.selectedArray removeAllObjects];
        [self loadData];
        [self.photoView reloadData];
        [ToolUtils showToast:@"删除成功" toView:self.view];

    }
}
@end
