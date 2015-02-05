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

+ (CGFloat)getHeight:(NSString*) content
{
    UIFont *font = [UIFont systemFontOfSize:18];
    CGSize size = CGSizeMake([[UIScreen mainScreen]applicationFrame].size.width,2000);
    CGSize labelsize = [content sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    return labelsize.height;
   
}

@end
