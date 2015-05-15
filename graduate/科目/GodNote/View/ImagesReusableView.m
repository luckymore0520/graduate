//
//  ImagesReusableView.m
//  graduate
//
//  Created by yixiaoluo on 15/5/14.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "ImagesReusableView.h"
#import "IntroductionModel.h"
#import "GodNoteViewCell.h"
#import "UIImageView+WebCache.h"
#import "ToolUtils.h"

@interface ImagesReusableView ()

@property (readwrite, nonatomic) UICollectionView *collectionView;
@property (readwrite, nonatomic) NSArray *imageList;

@end

@implementation ImagesReusableView

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

- (void)reloadViewWithArray:(NSArray *)array
{
    self.imageList = array;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDatasource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NoteTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kImageCellIdentifier forIndexPath:indexPath];
    cell.imageView.hidden = NO;
    cell.titleLabel.hidden = YES;
    
    MediaImageModel *model = self.imageList[indexPath.row];
    NSURL *url = [ToolUtils getImageUrlWtihString:model.imageURl width:cell.imageView.frame.size.width height:cell.imageView.frame.size.height];
    [cell.imageView sd_setImageWithURL:url];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = (CGRectGetHeight(self.frame) - 3*kPadding)/2;
    return CGSizeMake(height, height);
}

#pragma mark - getter && setter
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = kPadding;
        layout.minimumInteritemSpacing = kPadding;
        layout.sectionInset = UIEdgeInsetsMake(kPadding, kPadding, kPadding, kPadding);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        [_collectionView registerClass:[NoteTitleCell class] forCellWithReuseIdentifier:kImageCellIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    
    return _collectionView;
}

@end
