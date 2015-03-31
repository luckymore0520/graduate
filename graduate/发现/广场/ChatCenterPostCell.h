//
//  ChatCenterPostCell.h
//  graduate
//
//  Created by Sylar on 26/1/15.
//  Copyright (c) 2015 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MComment.h"
#import "MPost.h"
#define MALE @"男生图标"
#define FEMALE @"女生图标"
@interface ChatCenterPostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *postAltasImageView;
@property (weak, nonatomic) IBOutlet UIImageView *postSexImageView;
@property (weak, nonatomic) IBOutlet UILabel *postNickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postGenderLabel;
@property (weak, nonatomic) IBOutlet UILabel *postRepliedLabel;
@property (weak, nonatomic) IBOutlet UILabel *postIntervalLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *postContextLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyBt;
@property (nonatomic,strong) MComment* comment;
@property (nonatomic,strong)MPost* post;
+ (CGFloat)getHeight:(NSString*) content hasConstraint:(BOOL)hasConstraint;
@end
