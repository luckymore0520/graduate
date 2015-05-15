//
//  ImagesReusableView.h
//  graduate
//
//  Created by yixiaoluo on 15/5/14.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kImageCellIdentifier = @"kImageCellIdentifier";
static CGFloat const kPadding = 5;

@interface ImagesReusableView : UICollectionReusableView
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>

@property (readonly, nonatomic) NSArray *imageList;
@property (readonly, nonatomic) UICollectionView *collectionView;

- (void)reloadViewWithArray:(NSArray *)array;//MediaImageModel array

@end
