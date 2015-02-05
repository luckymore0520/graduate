//
//  SelfOtherCell.h
//  graduate
//
//  Created by luck-mac on 15/2/5.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonGroup.h"
@interface SelfOtherCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImgView;
@property (weak, nonatomic) IBOutlet UILabel *cellNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailTipLabel;
@property (weak, nonatomic) IBOutlet UIButton *maleBt;
@property (weak, nonatomic) IBOutlet UIButton *femaleBt;
@property (weak, nonatomic) IBOutlet ButtonGroup *cellBtGroup;
@property (weak, nonatomic) IBOutlet UITextField *nickNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end
