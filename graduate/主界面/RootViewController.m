//
//  RootViewController.m
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "RootViewController.h"
#import "ToolUtils.h"
#import "MAOFlipViewController.h"
@interface RootViewController ()<MAOFlipViewControllerDelegate>
@property(nonatomic,strong) NSArray* childrenVCs;
@property (nonatomic) MAOFlipViewController *flipViewController;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.childrenVCs = [NSArray arrayWithObjects:@"MainFun",@"Subject",@"Other", nil];
    // Do any additional setup after loading the view, typically from a nib.
    self.flipViewController = [[MAOFlipViewController alloc]init];
    self.flipViewController.flipState  = FLIPUPANDDOWN;
    self.flipViewController.delegate = self;
    [self addChildViewController:self.flipViewController];
    self.flipViewController.view.frame = self.view.frame;
    [self.view addSubview:self.flipViewController.view];
    [self.flipViewController didMoveToParentViewController:self];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MAOFlipViewControllerDelegate

- (UIViewController*)flipViewController:(MAOFlipViewController *)flipViewController contentIndex:(NSUInteger)contentIndex
{
    //新規作成
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:[self.childrenVCs objectAtIndex:contentIndex]];
    return vc;
}

- (NSUInteger)numberOfFlipViewControllerContents
{
    return self.childrenVCs.count;
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
