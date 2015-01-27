//
//  ChatCenterPostCell.h
//  graduate
//
//  Created by Sylar on 26/1/15.
//  Copyright (c) 2015 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatCenterPostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *postAltasImageView;
@property (weak, nonatomic) IBOutlet UILabel *postNickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postGenderLabel;
@property (weak, nonatomic) IBOutlet UILabel *postRepliedLabel;
@property (weak, nonatomic) IBOutlet UILabel *postIntervalLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *postContextLabel;

@end
