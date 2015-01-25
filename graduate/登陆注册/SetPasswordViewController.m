//
//  SetPasswordViewController.m
//  graduate
//
//  Created by luck-mac on 15/1/23.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "SetPasswordViewController.h"
#import "MainFunVC.h"
@interface SetPasswordViewController ()

@end

@implementation SetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)complete:(id)sender {
    UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"Func" bundle:nil];
    
    
    MainFunVC* _rootVC = (MainFunVC*)[myStoryBoard instantiateViewControllerWithIdentifier:@"MainFun"];
    [self.navigationController presentViewController:_rootVC animated:YES completion:^{
        [self.navigationController popToRootViewControllerAnimated:NO];
        [self.view.window setRootViewController:_rootVC];
        [self.view.window makeKeyAndVisible];
    }];
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
