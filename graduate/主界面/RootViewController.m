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
@property(nonatomic,strong) NSMutableArray* childrenViewControllers;
@property (nonatomic) MAOFlipViewController *flipViewController;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.childrenVCs = [NSArray arrayWithObjects:@"MainFun",@"Subject",@"Other", nil];
    self.childrenViewControllers = [[NSMutableArray alloc]init];
    for (NSString* str in _childrenVCs) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:str];
        [_childrenViewControllers addObject:vc];
    }
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
    if (contentIndex==0) {
        return [self.storyboard instantiateViewControllerWithIdentifier:_childrenVCs[0]];
    }
    return _childrenViewControllers[contentIndex];
}

- (NSUInteger)numberOfFlipViewControllerContents
{
    return self.childrenVCs.count;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
