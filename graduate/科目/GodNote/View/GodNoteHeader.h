//
//  GodNoteHeader.h
//  graduate
//
//  Created by yixiaoluo on 15/5/7.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GodNoteHeader, AdView, AdModel, SubjectModel;
@protocol GodNoteHeaderDelegate <NSObject>

@required
- (void)noteHeader:(GodNoteHeader *)header didSelectItem:(SubjectModel *)sModel atIndex:(NSInteger)itemIndex;
- (void)noteHeader:(GodNoteHeader *)header didSelectAdvertisementWithURL:(NSString *)adURL;
- (void)noteHeaderDidCloseAdvertisement:(GodNoteHeader *)header;

@end

@protocol AdViewDelegate <NSObject>

@required
- (void)adViewDidCloseAd:(AdView *)adView;
- (void)adViewDidTapped:(AdView *)adView;

@end

@interface GodNoteHeader : UIView

@property (weak, nonatomic) id<GodNoteHeaderDelegate> delegate;
@property (readonly, nonatomic) NSInteger currentSelectIndex;

- (void)reloadViewWithAllSubjectModels:(NSArray *)subjectModels
                             andAdmdel:(AdModel *)model;

@end

@interface SubjectTitleCell: UICollectionViewCell

@property (nonatomic) UILabel *titleLabel;

@end

@interface AdView : UIView

@property (weak, nonatomic) id<AdViewDelegate> delegate;

- (void)setImageURL:(NSString *)url;

@end