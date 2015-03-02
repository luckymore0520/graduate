//
//  MAOFlipViewController.m
//  MAOFlipViewController
//
//  Created by Mao Nishi on 2014/05/06.
//  Copyright (c) 2014年 Mao Nishi. All rights reserved.
//

#import "MAOFlipViewController.h"
#import "ToolUtils.h"
#import "SubjectVC.h"
#import "MainFunVC.h"
#import "OtherFuncVCViewController.h"
#import "MyQuestionVC.h"
@interface MAOFlipViewController ()<FlipInteactionDelegate, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>
@property (nonatomic) MAOFlipInteraction *flipInteraction;
@property (nonatomic) MAOFlipTransition *flipTransition;
@property (nonatomic) BOOL firstShow;
@property (nonatomic,strong)UIViewController* snapVC;
@end

@implementation MAOFlipViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIViewController *c = [self.delegate flipViewController:self contentIndex:0];
    if (c) {
        //ジェスチャーイベント設定
        UIViewController *snapVC = [self.delegate flipViewController:self contentIndex:0];
        self.flipInteraction = MAOFlipInteraction.new;
        self.flipInteraction.delegate = self;
        self.flipNavigationController = [[WKNavigationViewController alloc]initWithRootViewController:c];
        UIViewController* nextVC = [self nextViewController];
        [self.flipNavigationController pushViewController:nextVC animated:NO];
        [self.flipInteraction setView:nextVC.view];
        self.flipNavigationController.delegate = self;
        [self.flipNavigationController.navigationBar setHidden:YES];
        [self addChildViewController:self.flipNavigationController];
        self.flipNavigationController.view.frame = self.view.frame;
        [self.view addSubview:self.flipNavigationController.view];
        [self.flipNavigationController didMoveToParentViewController:self];
        [self.view addSubview:snapVC.view];
        [self addChildViewController:snapVC];
        self.snapVC = snapVC;
    }
    _firstShow = YES;
}

- (void) viewWillAppear:(BOOL)animated
{
    self.snapVC.view.frame = self.view.frame;
}
- (void) viewDidAppear:(BOOL)animated
{
    if (_firstShow) {
        _firstShow = NO;
        double delayInSeconds = 1.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.snapVC.view.transform = CGAffineTransformMakeTranslation(0, -self.view.frame.size.height);
                             } completion:^(BOOL finished) {
                                 [self.snapVC.view removeFromSuperview];
                                 [self.snapVC removeFromParentViewController];
                                 
                             }
             ];
        });
    }
}

#pragma mark - FlipInteractionDelegate
//画面遷移開始
- (void)interactionPushBeganAtPoint:(CGPoint)point
{
    UIViewController *c = [self nextViewController];
    if (!c) {
        return;
    }
    [self.flipInteraction setView:c.view];//インタラクション対象viewの設定。遷移先のview
    [self.flipNavigationController pushViewController:c animated:YES];
}

- (void)pushViewController:(UIViewController*)controller animated:(BOOL)animated
{
    self.flipTransition.ignoreContext  = YES;
    if ([self isMainPage:controller]) {
        [self.flipInteraction setView:controller.view];
    }
    [self.flipNavigationController pushViewController:controller animated:animated];
}



- (void)interactionPopBeganAtPoint:(CGPoint)point
{
    if ([self isMainPage:[self.flipNavigationController topViewController]]) {
        [self.flipNavigationController popViewControllerAnimated:YES];
    }
}

- (UIViewController*)nextViewController
{
    //既に存在している場合は一つ次のviewController取り出し
    NSInteger targetIndex = self.flipNavigationController.viewControllers.count;
    
    //予定枚数を超えている場合はなし
    if ([self.delegate numberOfFlipViewControllerContents] <= targetIndex) {
        return nil;
    }
    
    UIViewController *c = [self.delegate flipViewController:self contentIndex:(targetIndex)];
    return c;
}

- (void)completePopInteraction
{
    //インタラクション対象のviewを設定する
//    UIViewController *c = [self.flipNavigationController.viewControllers lastObject];
//    [self.flipInteraction setView:c.view];
}

#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    return self.flipInteraction;
}



- (id <UIViewControllerAnimatedTransitioning>)navigationController:
(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    
    
    
    
    if ([toVC class]==[SubjectVC class]) {
        ((SubjectVC*)toVC).parentVC =  self;
    }
    if ([toVC class]==[OtherFuncVCViewController class]) {
        [((OtherFuncVCViewController*)toVC).backImageView setHidden:NO];
    }
    [navigationController setNavigationBarHidden:[self isMainPage:toVC]];
    if ([self isMainPage:toVC]&&[self isMainPage:fromVC]) {
        if (!self.flipTransition) {
            self.flipTransition = [[MAOFlipTransition alloc]init];
        }
        if (operation == UINavigationControllerOperationPush) {
            UIViewController *c = [self.delegate flipViewController:self contentIndex:0];
            if (c) {
                [self.flipInteraction setView:c.view];
            }
            self.flipTransition.presenting = YES;
        }else{
            self.flipTransition.interaction = self.flipInteraction;
            self.flipTransition.presenting = NO;
        }
        return self.flipTransition;
    }
    return nil;
}

/*
 设置rootViewController的NavigationBar 不可见
 */
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController class]==[MyQuestionVC class]) {
        [navigationController setNavigationBarHidden:NO];
    }
}


- (BOOL)isMainPage:(UIViewController*)toVC
{
    return [toVC class]==[MainFunVC class]||[toVC class]==[SubjectVC class]||[toVC class]==[OtherFuncVCViewController class];
}

@end