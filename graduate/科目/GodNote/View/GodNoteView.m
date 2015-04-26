//
//  GodNoteView.m
//  graduate
//
//  Created by yixiaoluo on 15/4/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "GodNoteView.h"
#import "CourseModel.h"
#import "GodNoteRequestManger.h"

static NSString * const kGodNoteViewCellIdentifier = @"kGodNoteViewCellIdentifier";

@interface GodNoteView ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSMutableArray *dataSourceArray;

@end

@implementation GodNoteView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //init collection view
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kGodNoteViewCellIdentifier];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self addSubview:self.collectionView];
    }
    return self;
}

#pragma mark - getter &&  setter
- (NSMutableArray *)dataSourceArray
{
    if (_dataSourceArray == nil) {
        _dataSourceArray = [NSMutableArray array];
        [_dataSourceArray addObject:[CourseModel withCourseName:@"数学" andNotes:nil]];
        [_dataSourceArray addObject:[CourseModel withCourseName:@"政治" andNotes:nil]];
        [_dataSourceArray addObject:[CourseModel withCourseName:@"英语" andNotes:nil]];
    }
    return _dataSourceArray;
}

#pragma mark - actions
- (void)loadDataCompletion:(dispatch_block_t)completion;
{
    [GodNoteRequestManger getNoteWithNoteID:@1 completion:^(NSArray *models) {
        
        dispatch_async(dispatch_get_main_queue(), completion);
    } failure:^(NSString *errorString) {
        
        dispatch_async(dispatch_get_main_queue(), completion);
    }];
}

#pragma mark - UICollectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGodNoteViewCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor purpleColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return CGSizeMake(32, 50);
    }
    return CGSizeMake(50, 50);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    CourseModel *model = self.dataSourceArray[section];
    return model.courseNotes.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSourceArray.count;
}

@end
