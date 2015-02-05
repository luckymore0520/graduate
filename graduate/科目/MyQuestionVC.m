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
@interface MyQuestionVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *photoView;
@property (nonatomic,strong)NSMutableArray* selectedArray;
@property (nonatomic) NSInteger day;
@property (nonatomic)BOOL firstShow;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIView *reviewBtView;
@property (weak, nonatomic) IBOutlet ButtonGroup *transferView;

@property (weak, nonatomic) IBOutlet UIButton *subjectBt1;
@property (weak, nonatomic) IBOutlet UIButton *subjectBt2;
@property (weak, nonatomic) IBOutlet UIButton *subjectBt3;
@property (nonatomic,strong)NSMutableArray* subjects;
@property (nonatomic)BOOL selectModel;
@end

@implementation MyQuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    self.firstShow = YES;
    [self addRightButton];
    self.selectModel = NO;
    self.selectedArray  = [[NSMutableArray alloc]init];
    
}


- (void)initSubjects
{
    NSMutableArray* subjects = [NSMutableArray arrayWithArray:[[QuestionBook getInstance]getMySubjects]];
    self.subjectBt1.tag = -1;
    self.subjectBt2.tag = -1;
    self.subjectBt3.tag = -1;

    NSArray* buttons = [NSArray arrayWithObjects:self.subjectBt1,self.subjectBt2,self.subjectBt3,nil];
    
    [self.transferView loadButton:buttons];
    
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
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectPhotos:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *myAddButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = myAddButton;
}

- (void) selectPhotos:(id)sender
{
    [self.selectedArray removeAllObjects];
    for (int i = 0 ; i < self.myQuestions.count; i++) {
        for (int j = 0 ; j < [[[self.myQuestions objectAtIndex:i] objectForKey:@"array"] count]; j++) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            QuestionCell* cell = (QuestionCell*)[self.photoView cellForItemAtIndexPath:indexPath];
            [cell setSelect:NO];
        }
    }
    
    [self.reviewBtView setHidden:!self.reviewBtView.hidden];
    [self.selectView setHidden:!self.selectView.hidden];
    self.selectModel = !self.selectModel;
    UIButton* button = (UIButton*)sender;
    [button setSelected:!button.selected];
    
    
}
- (void)loadData
{
    self.myQuestions =
    [NSMutableArray arrayWithArray:[[QuestionBook getInstance]getQuestionOfType:self.type]];
    [self.myQuestions sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString* a = [obj1 objectForKey:@"day"];
        NSString* b = [obj2 objectForKey:@"day"];
        return  [b compare:a];
    }];
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
            self.shoudUpdate = NO;
            [self.photoView reloadData];
        }
        
        
    } else if ([names isEqualToString:@"MQuesDelete.h"])
    {
        MReturn* ret = [MReturn objectWithKeyValues:data];
        if (ret.code_.integerValue==1) {
            NSLog(@"删除成功");
        }
    }
}


- (IBAction)reviewModelAction:(id)sender {
    [self performSegueWithIdentifier:@"reviewMyQuestion" sender:nil];
}

- (IBAction)transfer:(id)sender {
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
    [UIView animateWithDuration:0.5 animations:^{
        self.transferView.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
    
    
    
    
    
    Subject* subject = [self.subjects objectAtIndex:[self.transferView selectedIndex]];

    QuestionBook* book = [QuestionBook getInstance];
    
    [[book.allQuestions objectAtIndex:self.type-1]removeObjectsInArray:self.selectedArray];
    [[book.allQuestions objectAtIndex:subject.type-1]addObjectsFromArray:self.selectedArray];
    
    
    
    
    
    
    for (Question* question in self.selectedArray) {
        question.subject = subject.name;
        question.type = [NSNumber numberWithInt:subject.type];
        question.isUpload = NO;
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
    
    
    UIActionSheet* actionsheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除笔记" otherButtonTitles:nil, nil];
    [actionsheet showInView:[UIApplication sharedApplication].keyWindow];
    
    
    
    

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
    
    if (!self.selectModel) {
        RecordVC* detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QuestionDetail"];
        detailVC.questionList = [[QuestionBook getInstance] getMQuestionsOfType:self.type];
        Question* question = [[[self.myQuestions objectAtIndex:indexPath.section]objectForKey:@"array"]objectAtIndex:indexPath.row];
        detailVC.currentQuestionId = question.questionid;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    } else {
        Question* question = (Question*)[[[self.myQuestions objectAtIndex:indexPath.section]objectForKey:@"array"]objectAtIndex:indexPath.row];
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
//    [self performSegueWithIdentifier:@"showDetail" sender:indexPath];
    
    
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
        reviewVC.subject = self.subject;
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
        }
        
        
        
        
        [[QuestionBook getInstance]save];
        
        MQuesDelete* delete = [[MQuesDelete alloc]init];
        [delete load:self id:questionIds];
        
        [self.selectedArray removeAllObjects];
        [self.photoView reloadData];

    }
}
@end
