//
//  BaseFuncVC.m
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "BaseFuncVC.h"
#import "MobClick.h"
#define DEFAULTBACKICON @"1-返回键"
#import "WKNavigationViewController.h"
#import "LoginVC.h"
@interface BaseFuncVC ()
@property (nonatomic,assign)BOOL hasJumpedAway;
@property (nonatomic,strong)FlipPresentAnimation* presentAnimation;
@end

@implementation BaseFuncVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _presentAnimation = [FlipPresentAnimation new];
    keyboardHeight = MAX([[ToolUtils getKeyboardHeight] floatValue], 240);
    if([self.navigationController.navigationBar
        respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar  setBackgroundImage:[[UIImage imageNamed:@"7-台头"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]   forBarMetrics:UIBarMetricsDefault];
        //        [self.navigationController.navigationBar setBackgroundColor:RGB(143, 60, 133)];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                         [UIColor colorWithRed:1 green:1 blue:1 alpha:1], NSForegroundColorAttributeName,
                                                                         [UIColor colorWithRed:1 green:1 blue:1 alpha:1], UITextAttributeTextShadowColor,
                                                                         [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
                                                                         UITextAttributeTextShadowOffset,
                                                                         [UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:20.0],
                                                                         UITextAttributeFont,
                                                                         nil]];
        
        if([self.navigationController respondsToSelector:@selector(backIcons)]){
            _backIcons=[self.navigationController performSelector:@selector(backIcons)];
        }
        if([self.navigationController viewControllers].count>1){
            UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
            NSString *iconname=DEFAULTBACKICON;
            if(_backIcons!=nil && _backIcons.count>0){
                if ([self.navigationController viewControllers].count-2<_backIcons.count) {
                    iconname=[_backIcons objectAtIndex:[self.navigationController viewControllers].count-2];
                }else{
                    iconname=[_backIcons objectAtIndex:_backIcons.count-1 ];
                }
            }
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",iconname]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *myAddButton = [[UIBarButtonItem alloc] initWithCustomView:button];
            NSArray *myButtonArray = [[NSArray alloc] initWithObjects: myAddButton, nil];
            self.navigationItem.leftBarButtonItems = myButtonArray;
        }
    }
    [self.navigationController.navigationBar setAlpha:1];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.scale = 1;
    [self initViews];
    _hasJumpedAway = NO;
    [self registerForKeyboardNotifications];
    // Do any additional setup after loading the view.
}



- (void)initViews
{
    if (self.scale==1&&self.view.frame.size.width<350) {
        self.scale = 0.854;
        self.view.transform = CGAffineTransformMakeScale(self.scale, self.scale);
    }
}

-(void)closeSelf{
    if([self.navigationController viewControllers].count>1){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
        }];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self waitingEnd];
    for (UITextField* field in self.textFields) {
        field.delegate = self;
    }
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden];
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden];
    [self registerForKeyboardNotifications];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.maskView setHidden:YES];
    self.maskView = nil;
    [self.maskView removeFromSuperview];
    [self.waitingView setHidden:YES];
    [self.waitingView removeFromSuperview];
    self.waitingView = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    keyboardHeight = keyboardSize.height>=240?keyboardSize.height:240;
    [ToolUtils setKeyboardHeight:[NSNumber numberWithDouble:keyboardHeight]];
}

- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    // keyboardWasShown = NO;
    keyboardHeight = keyboardSize.height>=240?keyboardSize.height:240;
    [ToolUtils setKeyboardHeight:[NSNumber numberWithDouble:keyboardHeight]];
    
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark -textFieldDelegate
//开始编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGRect frame;
    if (_keyButtons.count>0) {
        UIButton* button = [_keyButtons firstObject];
        frame= button.frame;
    } else {
        frame = textField.frame;
    }
    
    int offset = frame.origin.y - (self.view.frame.size.height - MAX(keyboardHeight, 240));//键盘高度216
    NSLog(@"offset is %d",offset);
    if (textField.inputAccessoryView) {
        offset = offset+ textField.inputAccessoryView.frame.size.height;
    }
    NSTimeInterval animationDuration = 0.30f;
    CGFloat y = [self.view convertRect:textField.frame toView:nil].origin.y-self.navigationController.navigationBar.frame.size.height-20;
    if (offset>0&&  y > offset) {
        [UIView animateWithDuration:animationDuration animations:^{
            self.view.transform = CGAffineTransformMake(self.scale, 0, 0, self.scale, 0.0, -offset);
        }];
    }
   

    [self addMaskBt];
    
    return YES;
}


//增加遮罩按钮，点击键盘弹回
- (void)addMaskBt
{
    if (self.maskBt) {
        [self.maskBt setHidden:YES];
        [self.maskBt removeFromSuperview];
    }
    self.maskBt = [[UIButton alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.maskBt];
    [self.maskBt addTarget:self action:@selector(resignAll) forControlEvents:UIControlEventTouchUpInside];
    for (UITextField* textField in self.textFields) {
        [self.view bringSubviewToFront:textField];
    }
    
    for (UIButton* button in self.keyButtons) {
        [self.view bringSubviewToFront:button];
    }
}
- (void)resignAll

{
    for (UITextField* textField in self.textFields) {
        [textField resignFirstResponder];
    }
    [self animationReturn];
}


- (void)animationReturn
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView animateWithDuration:animationDuration animations:^{
        self.view.transform = CGAffineTransformMake(self.scale, 0, 0, self.scale, 0, 0);
    }];
    [self.maskBt setHidden:YES];
    [self.maskBt removeFromSuperview];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self animationReturn];
    [textField resignFirstResponder];
    return YES;
}


- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    
}

- (void)showAlert:(NSString *)alert functionName:(NSString *)names
{
    NSLog(@"%@",names);
    [self waitingEnd];
    [ToolUtils showMessage:alert];
    if ([alert isEqualToString:@"登录验证失败"]&&!self.hasJumpedAway) {
        self.hasJumpedAway = YES;
        [ToolUtils setHasLogin:NO];
        [ToolUtils setUserId:nil];
        [ToolUtils setVerify:nil];
        [ToolUtils setUserInfo:nil];
        [ToolUtils setUserInfomation:nil];
        UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"User" bundle:nil];
        LoginVC* _rootVC = (LoginVC*)[myStoryBoard instantiateViewControllerWithIdentifier:@"login"];
        WKNavigationViewController* nav = [[WKNavigationViewController alloc]initWithRootViewController:_rootVC];
        [nav setNavigationBarHidden:YES];
        [[[UIApplication sharedApplication].delegate window] setRootViewController:nav];
    }
    
}

- (void)showError:(NSError *)error functionName:(NSString *)names
{
    [self waitingEnd];
    [ToolUtils showMessage:@"网络请求失败"];
}


- (void)addLeftButton:(NSString*)title action:(SEL)action img:(NSString*)img
{
    
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, title==nil?44:70, 44)];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    button.titleLabel.textAlignment = UITextAlignmentRight;
    button.titleLabel.font = [UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:16.0];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (img) {
        [button setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
        
    }
    
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *myAddButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = myAddButton;
}

- (void)addRightButton:(NSString*)title action:(SEL)action img:(NSString*)img
{
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, title==nil?44:70, 44)];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    button.titleLabel.textAlignment = UITextAlignmentRight;
    button.titleLabel.font = [UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:16.0];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (img) {
        [button setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];

    }
    
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *myAddButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = myAddButton;
}



- (void) waiting:(NSString*)msg
{
    [self addMask];
    if (!self.waitingView) {
        CGFloat width = [[UIScreen mainScreen]bounds].size.width;
        CGFloat height = [[UIScreen mainScreen]bounds].size.height;
        CGRect frame = CGRectMake((width-100)/2, (height-100)/2, 100, 100);
        self.waitingView = [[[NSBundle mainBundle] loadNibNamed:@"WaitingView" owner:self options:nil] firstObject];
        self.waitingView.layer.cornerRadius=15;
        [self.waitingView setClipsToBounds:YES];
        self.waitingView.frame = frame;
    }
    [self.navigationController.view addSubview:self.waitingView];
    [self.waitingView.msgLbel setText:msg];
    [self.navigationController.view bringSubviewToFront:self.waitingView];
}


- (void) waitingEnd
{
    [self removeMask];
    [self.waitingView setHidden:YES];
    [self.waitingView removeFromSuperview];
}


- (void)addMask
{
    if (!self.maskView) {
        self.maskView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
        [self.maskView setAlpha:0.5];
        [self.maskView setBackgroundColor:[UIColor blackColor]];
        [self.navigationController.view addSubview:self.maskView];
    }
    [self.maskView setHidden:NO];
}


- (void)removeMask
{
    [self.maskView setHidden:YES];
//    [self.maskView removeFromSuperview];
}


#pragma mark -UIViewControllerTransitionDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.presentAnimation.presenting = YES;
    return self.presentAnimation;
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.presentAnimation.presenting = NO;
    return self.presentAnimation;
}
@end
