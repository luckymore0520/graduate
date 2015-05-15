//
//  AuthorReusableView.m
//  graduate
//
//  Created by yixiaoluo on 15/5/14.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "AuthorReusableView.h"
#import "IntroductionModel.h"
#import "ToolUtils.h"
#import "GodNoteViewCell.h"

static CGFloat const kPraiseHeaderViewDefaultHeight = 42;
static NSInteger const kPraiseHeaderCountPerRow = 4;

@interface AuthorReusableView ()

@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;

@property (weak, nonatomic) IBOutlet PraiseHeadersView *praiseHeaderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *praiseHeaderViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;

@property (weak, nonatomic) IBOutlet UIButton *praiseButton;

@end

@implementation AuthorReusableView

- (void)reloadViewWith:(AuthorInfo *)author
{
    NSURL *url = [ToolUtils getImageUrlWtihString:author.authorImageUrl width:self.headerIcon.frame.size.width height:self.headerIcon.frame.size.height];
    [self.headerIcon sd_setImageWithURL:url];
    self.sexImageView.image = [UIImage imageNamed:author.authorSex.boolValue ? @"": @"" ];

    if (author.praiseImgs.count > kPraiseHeaderCountPerRow) {
        self.praiseHeaderViewHeight.constant = kPraiseHeaderViewDefaultHeight;//default height
    }else{
        self.praiseHeaderViewHeight.constant = kPraiseHeaderViewDefaultHeight/2;
    }
    [self.praiseHeaderView reloadViewWithArray:author.praiseImgs];

    self.nameLabel.text = author.authorName;
    self.descLabel.text = author.authorDesc;
    self.subjectLabel.text = [NSString stringWithFormat:@"%@-%@", author.subName, author.subDetailName];
    
    [self.praiseButton setImage:[UIImage imageNamed:@"关于我们"] forState:UIControlStateNormal];
    [self.praiseButton setTitle:author.praiseCount.stringValue forState:UIControlStateNormal];
}

@end

@implementation PraiseHeadersView

- (void)awakeFromNib
{
    [self addSubview:self.collectionView];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (CGRectGetWidth(self.frame) - (kPraiseHeaderCountPerRow + 1)*kPadding)/kPraiseHeaderCountPerRow;
    return CGSizeMake(width, width);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NoteTitleCell *cell = (NoteTitleCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kImageCellIdentifier forIndexPath:indexPath];
    
    cell.imageView.contentMode = UIViewContentModeScaleToFill;
    
    NSString *imageURl = self.imageList[indexPath.row];
    NSURL *url = [ToolUtils getImageUrlWtihString:imageURl width:cell.imageView.frame.size.width height:cell.imageView.frame.size.height];
    [cell.imageView sd_setImageWithURL:url];

    cell.imageView.layer.cornerRadius = cell.bounds.size.height/2;
    cell.imageView.layer.masksToBounds = YES;
    
    return cell;
}

@end
