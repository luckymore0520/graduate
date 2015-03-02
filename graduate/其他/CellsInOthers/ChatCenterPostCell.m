//
//  ChatCenterPostCell.m
//  graduate
//
//  Created by Sylar on 26/1/15.
//  Copyright (c) 2015 nju.excalibur. All rights reserved.
//

#import "ChatCenterPostCell.h"

@implementation ChatCenterPostCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getHeight:(NSString*) content hasConstraint:(BOOL)hasConstraint
{
    UIFont *font = [UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:14.0];
    CGSize size = CGSizeMake([[UIScreen mainScreen]applicationFrame].size.width-44,2000);
    CGSize labelsize = [content sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    if (hasConstraint) {
        CGSize oneLineSize = [@"a line" sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
        return oneLineSize.height*3<=labelsize.height?oneLineSize.height*3:labelsize.height;
    }
    return labelsize.height;
   
}

@end
