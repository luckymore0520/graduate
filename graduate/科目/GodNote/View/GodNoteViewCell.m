//
//  GodNoteViewCell.m
//  graduate
//
//  Created by yixiaoluo on 15/5/10.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "GodNoteViewCell.h"
#import "GodNoteMacro.h"
#import "SubjectModel.h"
#import "UIImageView+WebCache.h"

static NSString * const kGodNoteViewCellCellIdentifier = @"kGodNoteViewCellCellIdentifier";

@interface GodNoteViewCell ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) SubjectModel *subjectModel;

@end

@implementation GodNoteViewCell

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

- (void)configCellWithSubjectModel:(SubjectModel *)model
{
    self.subjectModel = model;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    SubjectNote *model = self.subjectModel.subjectBooks[indexPath.section];
//    BookModel *chapter = model.allBooks[indexPath.row - 1];
    if ([self.delegate respondsToSelector:@selector(noteView:didSelectItem:)]) {
        [self.delegate noteView:nil didSelectItem:nil];
    }
}

#pragma mark - UICollectionViewDatasource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NoteTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGodNoteViewCellCellIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.imageView.hidden = YES;
        cell.titleLabel.hidden = NO;
        cell.titleLabel.text = @"你喜欢这";
        cell.contentView.backgroundColor = [UIColor purpleColor];
    }else{
        cell.imageView.hidden = NO;
        cell.titleLabel.hidden = YES;
        
        NSString *url = @"http://pic.wenwen.soso.com/p/20090901/20090901103853-803999540.jpg";
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:url]];
        
        cell.contentView.backgroundColor = [UIColor redColor];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return CGSizeMake(32, CGRectGetHeight(self.frame));
    }
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
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        [_collectionView registerClass:[NoteTitleCell class] forCellWithReuseIdentifier:kGodNoteViewCellCellIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    
    return _collectionView;
}

@end

@implementation NoteTitleCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.imageView];
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = self.bounds;
    self.imageView.frame = self.bounds;
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
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.numberOfLines = 0;
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}
@end
