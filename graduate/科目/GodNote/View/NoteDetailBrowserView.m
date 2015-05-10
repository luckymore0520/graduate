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
    
    cell.contentView.backgroundColor = [UIColor redColor];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //SubjectNote *model = self.subjectModel.subjectBooks[section];
    return 10;//model.allBooks.count + 1;//1 is the title
}

#pragma mark - getter && setter
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        [_collectionView registerClass:[NoteDetailBrowserViewCell class] forCellWithReuseIdentifier:kNoteDetailBrowserViewCellIdentifier];
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
    self.photoView.frame = self.bounds;
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
        _photoView = [[MJPhotoView alloc] init];
        _photoView.delegate = self;
    }
    return _photoView;
}
@end
