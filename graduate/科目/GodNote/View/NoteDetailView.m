//
//  NoteDetailView.m
//  graduate
//
//  Created by yixiaoluo on 15/5/10.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "NoteDetailView.h"
#import "GodNoteViewCell.h"
#import "UIImageView+WebCache.h"
#import "GodNoteViewCell.h"
#import "NoteBookModel.h"
#import "ToolUtils.h"

static NSString * const kGodNoteDetailCellIdentifier = @"kGodNoteDetailCellIdentifier";
static CGFloat itemWidth = 94;

@interface NoteDetailView ()
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSArray *noteBookList;

@end

@implementation NoteDetailView

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

- (void)scrollToIndexVisiable:(NSInteger)startIndex animated:(BOOL)animated completion:(void (^)(UIImageView *imageView))completion
{
    NoteTitleCell *cell = (NoteTitleCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:startIndex inSection:0]];
    [self.collectionView scrollRectToVisible:cell.frame animated:animated];
    if (completion) {
        completion(cell.imageView);
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(noteDetailView:didSelectItemAtIndex:imageView:)]) {
        NoteTitleCell *cell = (NoteTitleCell *)[collectionView cellForItemAtIndexPath:indexPath];        
        [self.delegate noteDetailView:self didSelectItemAtIndex:indexPath.row imageView:cell.imageView];
    }
}

#pragma mark - UICollectionViewDatasource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NoteTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGodNoteDetailCellIdentifier forIndexPath:indexPath];
    cell.imageView.hidden = NO;
    cell.titleLabel.hidden = YES;
    
    NoteBookModel *model = self.noteBookList[indexPath.row];
    NSURL *url = [ToolUtils getImageUrlWtihString:model.imageURL width:cell.frame.size.width height:cell.frame.size.height];
    [cell.imageView sd_setImageWithURL:url];
        
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(itemWidth, 120);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.noteBookList.count;
}

#pragma mark - getter && setter
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat paddingX = (screenWidth - itemWidth*3)/4;

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = paddingX;
        layout.minimumLineSpacing = paddingX;
        layout.sectionInset = UIEdgeInsetsMake(12, paddingX, 12, paddingX);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        [_collectionView registerClass:[NoteTitleCell class] forCellWithReuseIdentifier:kGodNoteDetailCellIdentifier];
        _collectionView.backgroundColor = [UIColor purpleColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    
    return _collectionView;
}

@end
