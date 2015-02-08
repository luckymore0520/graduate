//
//  BBSDetail.h
//  MobileNJU
//
//  Created by luck-mac on 14-5-29.
//  Copyright (c) 2014年 Stephen Zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFuncVC.h"
@interface EssenceDetailWebViewController:BaseFuncVC
@property (nonatomic,strong)NSURL* url;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (void)timer;
@end
