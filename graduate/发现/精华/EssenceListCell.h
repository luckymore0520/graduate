//
//  EssenceListCell.h
//  graduate
//
//  Created by luck-mac on 15/2/6.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EssenceListCellDelegate
- (void) selectCollection:(NSString*)essenceId isSelected:(BOOL)isSelected;
@end
@interface EssenceListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingSpace;
@property (nonatomic,strong)NSString* essenceId;
@property (nonatomic,weak)id<EssenceListCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *essenceTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *essenceTypeImage;
@property (weak, nonatomic) IBOutlet UILabel *essenceSourceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *essenceIsVipLabel;
@property (weak, nonatomic) IBOutlet UILabel *essenceTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIImageView *essenceDownloadBt;
@property (nonatomic)BOOL selectedMode;
- (void) setSelect:(BOOL)isSelected;
@end
