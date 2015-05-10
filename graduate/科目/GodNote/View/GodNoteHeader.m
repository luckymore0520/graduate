//
//  GodNoteHeader.m
//  graduate
//
//  Created by yixiaoluo on 15/5/7.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "GodNoteHeader.h"
#import "SubjectModel.h"
#import "UIButton+WebCache.h"
#import "AdModel.h"
#import "GodNoteMacro.h"

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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 35);
    self.adView.frame = CGRectMake(0, CGRectGetHeight(self.collectionView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.bounds) - CGRectGetHeight(self.collectionView.frame));
}

#pragma mark - actions
- (void)reloadViewWithAllSubjectModels:(NSArray *)subjectModels
                             andAdmdel:(AdModel *)model;
{
    self.allSubjectModels = subjectModels;
    [self.collectionView reloadData];
    
    //load once. because only one advertisement
//    if (!self.adModel && model) {
        self.adModel = model;
        [self.adView setImageURL:model.adImageURL];
//    }
}

#pragma mark - AdViewDelegate
- (void)adViewDidCloseAd:(AdView *)adView
{
    if ([self.delegate respondsToSelector:@selector(noteHeaderDidCloseAdvertisement:)]) {
        [self.delegate noteHeaderDidCloseAdvertisement:self];
    }
}

- (void)adViewDidTapped:(AdView *)adView
{
    if ([self.delegate respondsToSelector:@selector(noteHeader:didSelectAdvertisementWithURL:)]) {
        [self.delegate noteHeader:self didSelectAdvertisementWithURL:self.adModel.adImageURL];
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentSelectIndex = indexPath.row;
    
    if ([self.delegate respondsToSelector:@selector(noteHeader:didSelectItem:atIndex:)]) {
        [self.delegate noteHeader:self didSelectItem:self.allSubjectModels[indexPath.row] atIndex:indexPath.row];
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
    if (self.allSubjectModels.count == 0) {
        return CGSizeZero;
    }

    return CGSizeMake(CGRectGetWidth(self.frame)/self.allSubjectModels.count - 1, 34);
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
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        [_collectionView registerClass:[SubjectTitleCell class] forCellWithReuseIdentifier:kGodNoteHeaderCellIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
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
    [self.contentView addSubview:self.titleLabel];
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
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.highlightedTextColor = RGBa(73, 156, 214, 1);
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

@end

@interface AdView ()

@property (nonatomic) UIButton *imageViewButton;
@property (nonatomic) UIButton *deleteButton;

@end
@implementation AdView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [self addSubview:self.imageViewButton];
    [self addSubview:self.deleteButton];
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageViewButton.frame = self.bounds;
    self.deleteButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - CGRectGetHeight(self.bounds) - 8, 0, CGRectGetHeight(self.bounds)+8, CGRectGetHeight(self.bounds));
}

#pragma mark - response
- (void)setImageURL:(NSString *)url
{
    url = @"http://pic.wenwen.soso.com/p/20090901/20090901103853-803999540.jpg";
    [self.imageViewButton sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
}

#pragma mark - response
- (void)closeButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(adViewDidCloseAd:)]) {
        [self.delegate adViewDidCloseAd:self];
    }
}

- (void)imageViewButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(adViewDidTapped:)]) {
        [self.delegate adViewDidTapped:self];
    }
}

#pragma mark - setter && getter
- (UIButton *)imageViewButton
{
    if (!_imageViewButton) {
        _imageViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageViewButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_imageViewButton addTarget:self action:@selector(imageViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imageViewButton;
}

- (UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_deleteButton setImage:[UIImage imageNamed:@"关于我们"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

@end
