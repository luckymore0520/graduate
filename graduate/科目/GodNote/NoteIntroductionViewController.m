//
//  NoteIntroductionViewController.m
//  graduate
//
//  Created by yixiaoluo on 15/5/14.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "NoteIntroductionViewController.h"
#import "IntroductionModel.h"
#import "AuthorReusableView.h"
#import "NoteDetailViewController.h"

static NSString *const kAuthorReusableViewIdentifier = @"kAuthorReusableViewIdentifier";
static NSString *const kMediaReusableViewIdentifier = @"kMediaReusableViewIdentifier";
static NSString *const kUserSayReusableViewIdentifier = @"kUserSayReusableViewIdentifier";

@interface NoteIntroductionViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic) NSNumber *noteID;

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic, getter=getIntroductionModel) IntroductionModel *introductionModel;

@end

@implementation NoteIntroductionViewController

- (instancetype)initWithNoteID:(NSNumber *)noteID
{
    self = [super init];
    self.noteID = noteID;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"笔记详情";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看笔记" style:UIBarButtonItemStylePlain target:self action:@selector(seeNoteDetail)];
    
    [self getIntroductionModel];
    [self.view addSubview:self.collectionView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.collectionView.frame = self.view.bounds;
}

#pragma mark - action
- (void)seeNoteDetail
{
    NoteDetailViewController *note = [[NoteDetailViewController alloc] initWithNoteID:self.noteID];
    [self.navigationController pushViewController:note animated:YES];
}

#pragma mark - UICollectionViewDatasource
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //author info
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kAuthorReusableViewIdentifier forIndexPath:indexPath];
    }else if (indexPath.section == 1){
        //video or image
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kAuthorReusableViewIdentifier forIndexPath:indexPath];
    }else if (indexPath.section == 2){
        //user say
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kAuthorReusableViewIdentifier forIndexPath:indexPath];
    }else{
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kAuthorReusableViewIdentifier forIndexPath:indexPath];
    }
    
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [[UICollectionViewCell alloc] init];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 100);
    }
    return CGSizeZero;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
    
    if (section == 0 || section == 1) {
        return 0;
    }else if (section == 2){
        return self.introductionModel.userSayInfo.userSayArray.count;
    }else if (section == 4){
        return self.introductionModel.commentInfo.commentList.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(CGRectGetWidth(self.view.bounds), 100);
    }else if (section == 1){
        return CGSizeMake(CGRectGetWidth(self.view.bounds), 100);
    }else if (section == 2){
        return CGSizeZero;
    }else{
        return CGSizeMake(CGRectGetWidth(self.view.bounds), 30);
    }
}

#pragma mark - getter && setter
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 20, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"AuthorReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kAuthorReusableViewIdentifier];
        [_collectionView registerNib:[UINib nibWithNibName:@"AuthorReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMediaReusableViewIdentifier];
        [_collectionView registerNib:[UINib nibWithNibName:@"AuthorReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kUserSayReusableViewIdentifier];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor orangeColor];
    }
    
    return _collectionView;
}

- (IntroductionModel *)getIntroductionModel
{
    if (!_introductionModel) {
        
        //prepare demo text
        //you should get it from server
        NSString *filepath = [[NSBundle mainBundle] pathForResource:@"text" ofType:@"txt"];
        NSString *textString = [[NSString alloc] initWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
        NSData *textData = [textString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *demoDictionary = [NSJSONSerialization JSONObjectWithData:textData options:NSJSONReadingAllowFragments error:nil];
        
        _introductionModel = [IntroductionModel fromDictionary:demoDictionary];
    }
    return _introductionModel;
}

@end
