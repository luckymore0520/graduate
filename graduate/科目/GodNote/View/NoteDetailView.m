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

static NSString * const kGodNoteDetailCellIdentifier = @"kGodNoteDetailCellIdentifier";
static CGFloat itemWidth = 94;

@interface NoteDetailView ()
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSArray *notes;

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

- (void)reloadViewWithNotes:(NSArray *)notes completion:(dispatch_block_t)completion
{
    self.notes = notes;
    [self.collectionView reloadData];
}

- (void)scrollToIndexVisiable:(NSInteger)startIndex animated:(BOOL)animated completion:(void (^)(CGRect endFrame, UIView *view))completion
{
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:startIndex inSection:0]];
    [self.collectionView scrollRectToVisible:cell.frame animated:animated];
    if (completion) {
        completion([self convertRect:cell.frame fromView:cell.superview], self);
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(noteDetailView:didSelectItem:fromRect:)]) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        CGRect frame = [self convertRect:cell.frame fromView:cell];
        
        [self.delegate noteDetailView:self didSelectItem:self.notes[indexPath.row] fromRect:frame];
    }
}

#pragma mark - UICollectionViewDatasource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NoteTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGodNoteDetailCellIdentifier forIndexPath:indexPath];
    cell.imageView.hidden = NO;
    cell.titleLabel.hidden = YES;
    
    NSString *url = @"http://pic.wenwen.soso.com/p/20090901/20090901103853-803999540.jpg";
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    
    cell.contentView.backgroundColor = [UIColor redColor];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(itemWidth, 120);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //SubjectNote *model = self.subjectModel.subjectBooks[section];
    return 20;//model.allBooks.count + 1;//1 is the title
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
