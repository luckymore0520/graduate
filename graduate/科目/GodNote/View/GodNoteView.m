//
//  GodNoteView.m
//  graduate
//
//  Created by yixiaoluo on 15/4/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "GodNoteView.h"
#import "SubjectModel.h"
#import "GodNoteRequestManger.h"

static NSString * const kGodNoteViewCellIdentifier = @"kGodNoteViewCellIdentifier";

@interface GodNoteView ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) SubjectModel *subjectModel;

@end

@implementation GodNoteView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //init collection view
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kGodNoteViewCellIdentifier];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self addSubview:self.collectionView];
    }
    return self;
}

#pragma mark - getter &&  setter

#pragma mark - actions
- (void)reloadViewWithSubjectModel:(SubjectModel *)subjectModel;
{
    if (subjectModel == self.subjectModel) {
        return;
    }
    
    self.subjectModel = subjectModel;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGodNoteViewCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor purpleColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return CGSizeMake(32, 50);
    }
    return CGSizeMake(50, 50);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    SubjectNote *model = self.subjectModel.subjectNotes[section];
    return model.allChapters.count + 1;//1 is the title
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.subjectModel.subjectNotes.count;
}

@end
