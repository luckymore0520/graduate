//
//  NoteDetailBrowserView.m
//  graduate
//
//  Created by yixiaoluo on 15/5/10.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "NoteDetailBrowserView.h"
#import "UIImageView+WebCache.h"
#import "MJPhoto.h"

static NSString * const kNoteDetailBrowserViewCellIdentifier = @"kNoteDetailBrowserViewCellIdentifier";

@interface NoteDetailBrowserViewCell : UICollectionViewCell
<
MJPhotoViewDelegate
>
@property (weak, nonatomic) id<MJPhotoViewDelegate> delegate;
@property (nonatomic) MJPhotoView *photoView;

@end

@interface NoteDetailBrowserView ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
MJPhotoViewDelegate
>
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSArray *notes;

@property (readwrite, nonatomic) NSInteger currentPageIndex;

@end

@implementation NoteDetailBrowserView

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

- (void)reloadViewWithNotes:(NSArray *)notes completion:(dispatch_block_t)completion
{
    self.notes = notes;
    [self.collectionView reloadData];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateCurrentPage];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self updateCurrentPage];
    }
}

- (void)updateCurrentPage
{
    self.currentPageIndex = lround(self.collectionView.contentOffset.x/self.collectionView.frame.size.width);
}

#pragma mark - MJPhotoViewDelegate
- (void)photoViewImageFinishLoad:(MJPhotoView *)photoView
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)photoViewSingleTap:(MJPhotoView *)photoView
{
    if ([self.delegate respondsToSelector:@selector(photoViewSingleTap:)]) {
        [self.delegate photoViewSingleTap:photoView];
    }
}

- (void)photoViewDidEndZoom:(MJPhotoView *)photoView
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - UICollectionViewDatasource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NoteDetailBrowserViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kNoteDetailBrowserViewCellIdentifier forIndexPath:indexPath];
    
    NSString *url = @"http://pic.wenwen.soso.com/p/20090901/20090901103853-803999540.jpg";
    MJPhoto *photoModel = [[MJPhoto alloc] init];
    photoModel.url = [NSURL URLWithString:url];
    photoModel.index = indexPath.row;
    
    cell.photoView.photo = photoModel;
    cell.delegate = self;
    cell.contentView.backgroundColor = [UIColor redColor];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //SubjectNote *model = self.subjectModel.subjectBooks[section];
    return 10;//model.allBooks.count + 1;//1 is the title
}

#pragma mark - getter && setter
- (MJPhotoView *)currentPhotoView
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.currentPageIndex];
    NoteDetailBrowserViewCell *cell = (NoteDetailBrowserViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.photoView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        [_collectionView registerClass:[NoteDetailBrowserViewCell class] forCellWithReuseIdentifier:kNoteDetailBrowserViewCellIdentifier];
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor orangeColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    
    return _collectionView;
}

@end

@implementation NoteDetailBrowserViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self.contentView addSubview:self.photoView];
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.photoView.frame = self.contentView.bounds;
}

#pragma mark - MJPhotoViewDelegate
- (void)photoViewImageFinishLoad:(MJPhotoView *)photoView
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)photoViewSingleTap:(MJPhotoView *)photoView
{
    if ([self.delegate respondsToSelector:@selector(photoViewSingleTap:)]) {
        [self.delegate photoViewSingleTap:photoView];
    }
}

- (void)photoViewDidEndZoom:(MJPhotoView *)photoView
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}


#pragma mark - setter && getter
- (MJPhotoView *)photoView
{
    if (!_photoView) {
        _photoView = [[MJPhotoView alloc] initWithFrame:self.bounds];
        _photoView.photoViewDelegate = self;
        _photoView.imageView.backgroundColor = [UIColor yellowColor];
    }
    return _photoView;
}
@end
