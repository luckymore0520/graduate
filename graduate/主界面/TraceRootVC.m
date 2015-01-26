//
//  TraceRootVC.m
//  graduate
//
//  Created by luck-mac on 15/1/26.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "TraceRootVC.h"
#import "MyTraceVC.h"
@interface TraceRootVC ()

@end

@implementation TraceRootVC


- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray* cvs = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < 10; i++ )
    {
        MyTraceVC* vc =[self.storyboard instantiateViewControllerWithIdentifier:@"trace"];
        UINavigationController* unvc = [[UINavigationController alloc]initWithRootViewController:vc];
        //        [unvc setNavigationBarHidden:YES];
        [cvs addObject:unvc];
    }
    self.viewControllers = cvs;
    [self reloadViewControllers];
}

- (void)viewWillAppear:(BOOL)animated
{
   
//    [self reloadViewControllers];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backToMain:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
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
