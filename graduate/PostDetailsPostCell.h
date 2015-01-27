//
//  PostDetailsPostCell.h
//  graduate
//
//  Created by Sylar on 27/1/15.
//  Copyright (c) 2015 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostDetailsPostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *postAltasImageView;
@property (weak, nonatomic) IBOutlet UILabel *postAuthorLabel;
@property (weak, nonatomic) IBOutlet UILabel *postGenderLabel;
@property (weak, nonatomic) IBOutlet UILabel *postIntervalLabel;
@property (weak, nonatomic) IBOutlet UILabel *postContextLabel;

@end
