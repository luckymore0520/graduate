//
//  PostDetailsReplyCell.h
//  graduate
//
//  Created by Sylar on 27/1/15.
//  Copyright (c) 2015 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostDetailsReplyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *replyImageView;
@property (weak, nonatomic) IBOutlet UILabel *replyAuthorLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyGenderLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyIntervalLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@end
