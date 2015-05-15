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
#import "NoteBookModel.h"
#import "ToolUtils.h"

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
@property (nonatomic) NSArray *noteBookList;

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

- (void)reloadViewWithNoteBooks:(NSArray *)notes
{
    self.noteBookList = notes;
    [self.collectionView reloadData];
}

- (void)startBrowsingFromPage:(NSInteger)page
{
    self.currentPageIndex = page;

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentPageIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath
                                atScrollPosition:UICollectionViewScrollPositionLeft
                                        animated:NO];
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
    NSInteger page = lround(self.collectionView.contentOffset.x/self.collectionView.frame.size.width);
    NSLog(@"image browser to page: %@", @(page));
    self.currentPageIndex = page;
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
    
    NoteBookModel *model = self.noteBookList[indexPath.row];

    MJPhoto *photoModel = [[MJPhoto alloc] init];
    photoModel.url = [ToolUtils getImageUrlWtihString:model.imageURL width:cell.frame.size.width height:cell.frame.size.height];
    cell.photoView.orientation = @(model.orientation);
    cell.photoView.photo = photoModel;
    cell.delegate = self;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.noteBookList.count;
}

#pragma mark - getter && setter
- (MJPhotoView *)currentPhotoView
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentPageIndex inSection:0];
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
    }
    return _photoView;
}
@end
