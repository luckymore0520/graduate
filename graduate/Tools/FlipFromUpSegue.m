//
//  FlipFromUpSegue.m
//  graduate
//
//  Created by luck-mac on 15/1/23.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "FlipFromUpSegue.h"
#import "ToolUtils.h"
@implementation FlipFromUpSegue
- (void)perform
{
    if (transitioning) {
        return;
    }
    transitioning=YES;
    UIViewController * svc = self.sourceViewController;
    UIViewController * dvc = self.destinationViewController;
    [svc.view addSubview:dvc.view];
    [dvc.view setFrame:svc.view.frame];
    dvc.view.transform = CGAffineTransformMakeTranslation(0, -dvc.view.frame.size.height);
    [UIView animateWithDuration:1.0
                     animations:^{
                         dvc.view.transform = CGAffineTransformMakeTranslation(0, 0);
                     }
                     completion:^(BOOL finished) {
                      //                        [dvc.view removeFromSuperview];
                         [dvc.view removeFromSuperview];
                         if ([ToolUtils getFirstUse]) {
                             [svc dismissViewControllerAnimated:NO completion:^{
                             }];
                         } else {
                             [svc presentViewController:dvc animated:NO completion:^{
                             }];
                             [ToolUtils setFirstUse:@"No"];
                         }
                         transitioning = NO;
//                         [svc.view.window setRootViewController:dvc];
//                         [svc.view.window makeKeyAndVisible];
                     }];


}
@end
