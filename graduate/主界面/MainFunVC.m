//
//  MainFunVC.m
//  graduate
//
//  Created by luck-mac on 15/1/23.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MainFunVC.h"
#import "ArticleDetailVC.h"

@interface MainFunVC ()

@end

@implementation MainFunVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated
{
    [self loadMusic];
}

- (IBAction)goToDetail:(id)sender {
    UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"Articles" bundle:nil];
    UINavigationController* _rootVC = (UINavigationController*)[myStoryBoard instantiateViewControllerWithIdentifier:@"navi"];
    ArticleDetailVC* _detailVC = (ArticleDetailVC*)[myStoryBoard instantiateViewControllerWithIdentifier:@"detail"];
    [_rootVC pushViewController:_detailVC animated:NO];
    [self presentViewController:_rootVC animated:YES completion:^{

    }];
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
