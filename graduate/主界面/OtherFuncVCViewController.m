//
//  OtherFuncVCViewController.m
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "OtherFuncVCViewController.h"
#import "SelfCenterViewController.h"
#import "FeedBackViewController.h"

@interface OtherFuncVCViewController ()

@end

@implementation OtherFuncVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goToSquare:(id)sender {
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"SquareStoryboard" bundle:nil];
    
    UIViewController* nextVC = [storyboard instantiateViewControllerWithIdentifier:@"square"];
    [self.navigationController pushViewController:nextVC animated:YES];
}
- (IBAction)goToFeedback:(id)sender {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"DiscoverStoryBoard" bundle:nil];
    
    SelfCenterViewController* nextVC = [storyboard instantiateViewControllerWithIdentifier:@"feedback"];
    [self.navigationController pushViewController:nextVC animated:YES];

}
- (IBAction)goToSelfCenter:(id)sender {
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"DiscoverStoryBoard" bundle:nil];
                                
    SelfCenterViewController* nextVC = [storyboard instantiateViewControllerWithIdentifier:@"selfCenter"];
    [self.navigationController pushViewController:nextVC animated:YES];

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
