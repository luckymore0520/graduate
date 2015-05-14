//
//  MediaReusableView.m
//  graduate
//
//  Created by yixiaoluo on 15/5/14.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "VideoReusableView.h"

@implementation VideoReusableView

- (void)awakeFromNib {
    // Initialization code
}

- (void)loadVideoWithURL:(NSURL *)videoURL
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:videoURL]];
}

@end
