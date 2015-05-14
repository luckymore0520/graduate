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
#import "UserSayCell.h"
#import "CommentCell.h"

typedef NS_ENUM(NSUInteger, IntrodutionHeaderStye) {
    IntrodutionHeaderStyleUserInfo = 0,
    IntrodutionHeaderStyleMediaInfo,
    IntrodutionHeaderStyleUserSay,
    IntrodutionHeaderStyleCommmentList,
};

static NSString *const kAuthorReusableViewIdentifier = @"kAuthorReusableViewIdentifier";
static NSString *const kMediaReusableViewIdentifier = @"kMediaReusableViewIdentifier";
static NSString *const kUserSayReusableViewIdentifier = @"kUserSayReusableViewIdentifier";

static NSString *const kUserSayCellIdentifier = @"kUserSayCellIdentifier";
static NSString *const kCommentCellIdentifier = @"kCommentCellIdentifier";

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
    if (indexPath.section == IntrodutionHeaderStyleUserInfo) {
        //author info
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kAuthorReusableViewIdentifier forIndexPath:indexPath];
    }else if (indexPath.section == IntrodutionHeaderStyleMediaInfo){
        //video or image
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kAuthorReusableViewIdentifier forIndexPath:indexPath];
    }else if (indexPath.section == IntrodutionHeaderStyleUserSay){
        //user say
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kAuthorReusableViewIdentifier forIndexPath:indexPath];
    }else{
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kAuthorReusableViewIdentifier forIndexPath:indexPath];
    }
    
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == IntrodutionHeaderStyleUserSay) {
        UserSayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kUserSayCellIdentifier forIndexPath:indexPath];
        return cell;
    }else if(indexPath.section == IntrodutionHeaderStyleCommmentList){
        CommentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCommentCellIdentifier forIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == IntrodutionHeaderStyleUserSay) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 40);
    }else if (indexPath.section == IntrodutionHeaderStyleCommmentList){
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 40);
    }
    
    return CGSizeZero;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == IntrodutionHeaderStyleUserSay){
        return self.introductionModel.userSayInfo.userSayArray.count;
    }else if (section == IntrodutionHeaderStyleCommmentList){
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
    if (section == IntrodutionHeaderStyleUserInfo) {
        return CGSizeMake(CGRectGetWidth(self.view.bounds), 100);
    }else if (section == IntrodutionHeaderStyleMediaInfo){
        return CGSizeMake(CGRectGetWidth(self.view.bounds), 100);
    }else if (section == IntrodutionHeaderStyleUserSay){
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
        
        [_collectionView registerNib:[UINib nibWithNibName:@"UserSayCell" bundle:nil] forCellWithReuseIdentifier:kUserSayCellIdentifier];
        [_collectionView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellWithReuseIdentifier:kCommentCellIdentifier];

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
