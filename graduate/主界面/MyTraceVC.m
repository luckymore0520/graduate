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
@property (strong, nonatomic)  CircularProgressView *progressBar;
@property (nonatomic,strong)NSMutableArray* myQuestions;
@property (nonatomic,assign)NSInteger phoneOfLine;
@property (nonatomic,strong)TraceHeaderView* header;
@end

@implementation MyTraceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadQuestion];
    _phoneOfLine = 5;
}




- (void)reLoadMusic
{
    if (self.trace.songUrl) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        if (self.progressBar) {
            [self loadMusic:[documentsDirectoryURL URLByAppendingPathComponent:self.trace.songUrl ] progressView:self.progressBar];
        } else {
            [self loadMusic:[documentsDirectoryURL URLByAppendingPathComponent:self.trace.songUrl]];
        }
        
    } else {
        if (self.progressBar) {
             [self loadMusic:nil progressView:self.progressBar] ;
        } else {
            [self loadMusic:nil] ;
        }
    }
}

- (void)downloadMusic
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"下载歌曲" message:@"您未下载该歌曲，点击确定下载后自动播放" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定"   , nil];
    [alert show];
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
    int total = 0 ;
    for (NSDictionary* dic in self.myQuestions) {
        total = total + [[dic objectForKey:@"array"] count];
    }
    if (self.shoudUpdate||total==0) {
        [[[MQuesList alloc]init]load:self type:0 date:self.trace.date];
    }
    if (total>=self.trace.addCount.integerValue) {
        self.trace.addCount = [NSNumber numberWithInteger:total];
    }
    NSArray* signList = [CoreDataHelper query:nil tableName:@"Sign"];
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
        
    } else if ([names isEqualToString:@"download"])
    {
        
        NSURL* url = [data objectForKey:@"path"];
        if (url) {
            [self saveMusic:[data objectForKey:@"fileid"] musicUrl:[data objectForKey:@"filename"]];
        }
    }
}

- (void)saveMusic:(NSString*)musicTitle musicUrl:(NSString*)musicUrl
{
    NSError* error;
    self.trace.songUrl = musicUrl;
    CoreDataHelper* helper = [CoreDataHelper getInstance];
    NSArray* array = [CoreDataHelper query:[NSPredicate predicateWithFormat:@"songName=%@",musicTitle] tableName:@"Trace"];
    for (Trace* trace in array) {
        trace.songUrl = musicUrl;
        BOOL isSaveSuccess=[helper.managedObjectContext save:&error];
        if (!isSaveSuccess) {
            NSLog(@"Error:%@",error);
        }else{
            NSLog(@"Save successful! Music:%@",musicTitle);
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            [self loadMusic:[documentsDirectoryURL URLByAppendingPathComponent:musicUrl]];
            self.isInView = YES;
        }
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
    int count = [[[self.myQuestions objectAtIndex:section-1] objectForKey:@"array"] count];
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
            [cell.titleLabel setText:subject];
        }
        return cell;
    } else {
        static NSString * CellIdentifier = @"picture";
        QuestionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        Question* question = (Question*)[[[self.myQuestions objectAtIndex:indexPath.section-1]objectForKey:@"array"]objectAtIndex:indexPath.row/_phoneOfLine*(_phoneOfLine-1)+indexPath.row%_phoneOfLine-1];
        if (question.is_recommand.integerValue==0) {
            [cell.imgView sd_setImageWithURL:[ToolUtils getImageUrlWtihString:question.img width:150 height:150]];
        } else {
            [cell.imgView setImage:[UIImage imageWithData:[ToolUtils loadData:question.questionid]]];
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
        if (self.header) {
            self.musicBt = self.header.musicBt;
            return self.header;
        }
        TraceHeaderView* header = [ collectionView dequeueReusableSupplementaryViewOfKind : UICollectionElementKindSectionHeader withReuseIdentifier : @ "myHeader" forIndexPath : indexPath ] ;
        [header initViewWithTrace:self.trace];
        self.musicBt = header.musicBt;
        self.progressBar = header.progressBar;
        self.progressBar.delegate = header;
        if (self.isInView) {
            [self reLoadMusic];
        }
        self.header = header;
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
