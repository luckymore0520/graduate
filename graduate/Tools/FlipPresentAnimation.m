//
//  FlipPresentAnimation.m
//  graduate
//
//  Created by luck-mac on 15/2/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "FlipPresentAnimation.h"

@implementation FlipPresentAnimation
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    if (_presenting) {
        // 1. Get controllers from transition context
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

        // 2. Set init frame for toVC
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
        toVC.view.frame = CGRectOffset(finalFrame, screenBounds.size.width, 0);
        
        // 3. Add toVC's view to containerView
        UIView *containerView = [transitionContext containerView];
        [containerView addSubview:toVC.view];
        
        // 4. Do animate now
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        [UIView animateWithDuration:duration animations:^{
            toVC.view.frame = finalFrame;
            fromVC.view.frame = CGRectOffset(finalFrame, -screenBounds.size.width, 0);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];

    } else {
        // 1. Get controllers from transition context
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        // 2. Set init frame for fromVC
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        CGRect initFrame = [transitionContext initialFrameForViewController:fromVC];
        CGRect finalFrame = CGRectOffset(initFrame, screenBounds.size.width, 0);
        
        // 3. Add target view to the container, and move it to back.
        UIView *containerView = [transitionContext containerView];
        [containerView addSubview:toVC.view];
        [containerView sendSubviewToBack:toVC.view];
        
        // 4. Do animate now
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        [UIView animateWithDuration:duration animations:^{
            fromVC.view.frame = finalFrame;
            toVC.view.frame = initFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];

    }
}
@end
