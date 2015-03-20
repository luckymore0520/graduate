//
//  VIPWebViewController.m
//  graduate
//
//  Created by TracyLin on 15/3/19.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "VIPWebViewController.h"

@interface VIPWebViewController ()

@end

@implementation VIPWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.viewWebView setDelegate:(id)self];
    if (self.url) {
        [self.viewWebView loadRequest:[NSURLRequest requestWithURL:self.url]];
    }
    [self.navigationController setNavigationBarHidden:NO];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
