//
//  AboutUsWebViewController.h
//  graduate
//
//  Created by TracyLin on 15/3/19.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolUtils.h"
#import "EssenceDetailWebViewController.h"
@interface AboutUsWebViewController : EssenceDetailWebViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic,strong) NSURL *url;
@end
