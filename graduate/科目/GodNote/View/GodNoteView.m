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
#import "GodNoteMacro.h"

static NSString * const kGodNoteViewCellIdentifier = @"kGodNoteViewCellIdentifier";

@interface GodNoteView ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
GodNoteViewDelete
>

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) SubjectModel *subjectModel;

@end

@implementation GodNoteView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
}

#pragma mark - actions
- (void)reloadViewWithSubjectModel:(SubjectModel *)subjectModel completion:(dispatch_block_t)completion
{
    if (!self.subjectModel.adModel) {
        [[GodNoteRequestManger sharedManager] getAllNotesIn:subjectModel completion:completion failure:^(NSString *errorString) {
            self.subjectModel = subjectModel;
            [self.collectionView reloadData];
        }];
    }
}

#pragma mark - GodNoteViewDelegate
- (void)noteView:(GodNoteView *)noteView didSelectItem:(BookModel *)note
{
    if ([self.delegate respondsToSelector:@selector(noteView:didSelectItem:)]) {
        [self.delegate noteView:self didSelectItem:note];
    }
}

#pragma mark - UICollectionViewDatasource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GodNoteViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGodNoteViewCellIdentifier forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor purpleColor];
    cell.delegate = self;
    [cell configCellWithSubjectModel:self.subjectModel];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 100);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;//self.subjectModel.subjectBooks.count;
}

#pragma mark - getter && setter
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5;
        layout.sectionInset = UIEdgeInsetsMake(5, 0, 0, 5);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        [_collectionView registerClass:[GodNoteViewCell class] forCellWithReuseIdentifier:kGodNoteViewCellIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    
    return _collectionView;
}
@end