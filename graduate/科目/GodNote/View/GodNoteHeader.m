//
//  GodNoteHeader.m
//  graduate
//
//  Created by yixiaoluo on 15/5/7.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "GodNoteHeader.h"
#import "SubjectModel.h"
#import "UIImageView+WebCache.h"
#import "AdModel.h"

#define RGBa(r, g, b, a)  [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:a]

static NSString * const kGodNoteHeaderCellIdentifier = @"kGodNoteViewCellIdentifier";

@interface GodNoteHeader ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
AdViewDelegate
>

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) AdView *adView;

@property (nonatomic) NSArray *allSubjectModels;
@property (nonatomic) AdModel *adModel;
@property (readwrite, nonatomic) NSInteger currentSelectIndex;

@end

@implementation GodNoteHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //init view
        [self addSubview:self.collectionView];
        [self addSubview:self.adView];
    }
    return self;
}

#pragma mark - actions
- (void)reloadViewWithAllSubjectModels:(NSArray *)subjectModels
                             andAdmdel:(AdModel *)model;
{
    self.allSubjectModels = subjectModels;
    self.adModel = model;
    
    [self.collectionView reloadData];
}

#pragma mark - AdViewDelegate
- (void)adViewDidCloseAd:(AdView *)adView
{
    if ([self.delegate respondsToSelector:@selector(noteHeader:didSelectAdvertisementWithURL:)]) {
        [self.delegate noteHeader:self didSelectAdvertisementWithURL:self.adModel.adImageURL];
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentSelectIndex = indexPath.row;
    
    if ([self.delegate respondsToSelector:@selector(noteHeader:didSelectItem:)]) {
        [self.delegate noteHeader:self didSelectItem:self.allSubjectModels[indexPath.row]];
    }
    
    //hilite the cell
    [collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SubjectTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGodNoteHeaderCellIdentifier forIndexPath:indexPath];
    
    SubjectModel *model = self.allSubjectModels[indexPath.row];
    cell.titleLabel.text = model.subjectTitle;
    cell.titleLabel.highlighted = indexPath.row == self.currentSelectIndex;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(self.frame)/self.allSubjectModels.count, 34);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.allSubjectModels.count;
}

#pragma mark - setter && getter
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        [_collectionView registerClass:[SubjectTitleCell class] forCellWithReuseIdentifier:kGodNoteHeaderCellIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    
    return _collectionView;
}

- (AdView *)adView
{
    if (!_adView) {
        _adView = [[AdView alloc] init];
        _adView.delegate = self;
    }
    return _adView;
}

@end

@implementation SubjectTitleCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self addSubview:self.titleLabel];
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
}

#pragma mark - setter && getter
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.highlightedTextColor = RGBa(73, 156, 214, 1);
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

@end

@interface AdView ()

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIButton *deleteButton;

@end
@implementation AdView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [self addSubview:self.imageView];
    [self addSubview:self.deleteButton];
    self.backgroundColor = [UIColor redColor];
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    self.deleteButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - CGRectGetHeight(self.bounds), 0, CGRectGetHeight(self.bounds), CGRectGetHeight(self.bounds));
}

#pragma mark - response
- (void)setImageURL:(NSString *)url
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url]];
}

#pragma mark - response
- (void)closeButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(adViewDidCloseAd:)]) {
        [self.delegate adViewDidCloseAd:self];
    }
}

#pragma mark - setter && getter
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

@end
