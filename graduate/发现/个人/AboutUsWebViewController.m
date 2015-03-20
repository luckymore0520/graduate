//
//  AboutUsWebViewController.m
//  graduate
//
//  Created by TracyLin on 15/3/19.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "AboutUsWebViewController.h"

@interface AboutUsWebViewController ()

@end

@implementation AboutUsWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView setDelegate:(id)self];
    NSString *aboutUrl = [ToolUtils getAboutUrl];
    if(aboutUrl){
//        self.url = [NSURL URLWithString:aboutUrl];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:aboutUrl]]];
    }
    self.title = @"关于我们";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @" ";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController setNavigationBarHidden:NO];
    NSLog(@"%@dd",self.navigationItem.backBarButtonItem);
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
