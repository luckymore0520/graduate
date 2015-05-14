//
//  MediaReusableView.h
//  graduate
//
//  Created by yixiaoluo on 15/5/14.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (void)loadVideoWithURL:(NSURL *)videoURL;

@end
