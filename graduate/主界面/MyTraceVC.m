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
@interface MyTraceVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)NSMutableArray* myQuestions;
@end

@implementation MyTraceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadQuestion];
    
}

- (void)loadQuestion
{
    
    self.myQuestions =
    [NSMutableArray arrayWithArray:[[QuestionBook getInstance]getQuestionByDay:self.trace.myDay]];
    if (self.shoudUpdate) {
        
        
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
    return  [[[self.myQuestions objectAtIndex:section-1] objectForKey:@"array"] count];
;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.myQuestions.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"picture";
    QuestionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    Question* question = (Question*)[[[self.myQuestions objectAtIndex:indexPath.section-1]objectForKey:@"array"]objectAtIndex:indexPath.row];
    if (question.is_recommand.integerValue==0) {
        [cell.imgView sd_setImageWithURL:[ToolUtils getImageUrlWtihString:question.img width:150 height:150]];
    } else {
        [cell.imgView setImage:[UIImage imageWithData:[ToolUtils loadData:question.questionid]]];
    }
    return cell;
}


- (IBAction)backToMain:(id)sender {
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(75, 75);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section!=0) {
        return CGSizeMake(0, 0);
    }
    return CGSizeMake(self.view.frame.size.width, 472);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section==self.myQuestions.count) {
        return CGSizeMake(0, 0);
    }
    return CGSizeMake(self.view.frame.size.width, 50);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showMyQuestion" sender:nil];
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if ( kind == UICollectionElementKindSectionHeader && indexPath.section==0 ) {
           TraceHeaderView* header = [ collectionView dequeueReusableSupplementaryViewOfKind : UICollectionElementKindSectionHeader withReuseIdentifier : @ "myHeader" forIndexPath : indexPath ] ;
           header.dateLabel.text = [NSString stringWithFormat:@"第%@天",self.trace.myDay];
        header.songNameLabel.text = self.trace.songName;
        [header.traceImg sd_setImageWithURL:[ToolUtils getImageUrlWtihString:self.trace.pictureUrlForTrace width:self.view.frame.size.width height:240] ];
        [header.markLabel setText:self.trace.note];
        self.musicBt = header.musicBt;
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        [self loadMusic:[documentsDirectoryURL URLByAppendingPathComponent:self.trace.songUrl]];
        return header;

    } else if ( kind == UICollectionElementKindSectionFooter ) {
         QuestionHeaderView*  reusableview= [ collectionView dequeueReusableSupplementaryViewOfKind : UICollectionElementKindSectionFooter withReuseIdentifier : @ "myFooter" forIndexPath : indexPath ] ;
        if (indexPath.section>0) {
           
            NSString* subject = [[self.myQuestions objectAtIndex:indexPath.section-1]objectForKey:@"subject"];
            //        reusableview.dateLabel setText:
            [reusableview.dateLabel setText:subject];
        }
        return reusableview;

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
