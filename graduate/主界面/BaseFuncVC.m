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
@interface BaseFuncVC ()

@end

@implementation BaseFuncVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
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
    // Do any additional setup after loading the view.
}

- (void)initViews
{
    if (self.view.frame.size.width<350) {
        self.scale = 0.854;
        self.view.transform = CGAffineTransformMakeScale(0.854, 0.854);
    }
}

-(void)closeSelf{
    if([self.navigationController viewControllers].count>0){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [[self.navigationItem.leftBarButtonItems objectAtIndex:0] hidesBackButton];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self waitingEnd];
    for (UITextField* field in self.textFields) {
        field.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.maskView setHidden:YES];
    [self.maskView removeFromSuperview];
    [self.waitingView setHidden:YES];
    [self.waitingView removeFromSuperview];
}


- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    keyboardHeight = keyboardSize.height;
    ///keyboardWasShown = YES;
}

- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    // keyboardWasShown = NO;
    keyboardHeight = keyboardSize.height;
    
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadMusic:(NSURL*)path
{
    if (path==nil) {
        [self.musicBt setImage:[UIImage imageNamed:@"3停止键"] forState:UIControlStateNormal];
        [self.musicBt setTag:SHOULDSTOP];
        return;
    }
    self.musicUrl = path;
    MediaPlayController* controller = [MediaPlayController getInstance];
    self.controller = controller;
    if ([controller.url.absoluteString isEqualToString:path.absoluteString]) {
        [self.musicBt setImage:[UIImage imageNamed:@"4-暂停键"] forState:UIControlStateNormal];
        [self.musicBt setTag:controller.state];
        return;
    }
    if (controller.state!=PLAY) {
        [controller prepareToPlayWithUrl:path];
        [controller play];
        [self.musicBt setTitle:@"暂停" forState:UIControlStateNormal];
        [self.musicBt setTag:controller.state];
    } else {
        [self.musicBt setImage:[UIImage imageNamed:@"3停止键"] forState:UIControlStateNormal];
        [self.musicBt setTag:SHOULDSTOP];
    }
    
}

- (void)loadMusic:(NSURL*)path progressView:(CircularProgressView*)progress
{
    if (path==nil) {
        
        [self.musicBt setImage:[UIImage imageNamed:@"3停止键"] forState:UIControlStateNormal];
        
        [self.musicBt setTag:SHOULDSTOP];
        return;
    }
    self.musicUrl = path;
    MediaPlayController* controller = [MediaPlayController getInstance];
    self.controller = controller;
    self.controller.progressView = progress;
    if ([controller.url.absoluteString isEqualToString:path.absoluteString]) {
        [self.musicBt setImage:[UIImage imageNamed:@"4-暂停键"] forState:UIControlStateNormal];
        [self.musicBt setTag:controller.state];
        return;
    }
    if (controller.state!=PLAY) {
        [controller prepareToPlayWithUrl:path];
        [controller play];
        [self.musicBt setImage:[UIImage imageNamed:@"4-暂停键"] forState:UIControlStateNormal];
        [self.musicBt setTag:controller.state];
    } else {
        [self.musicBt setImage:[UIImage imageNamed:@"3停止键"] forState:UIControlStateNormal];
        [self.musicBt setTag:SHOULDSTOP];
    }

}
- (void)downloadMusic
{
    
}
- (IBAction)controlMusic:(id)sender {
    
    
    switch (self.musicBt.tag) {
        case READY:
            if (self.musicUrl) {
                [[MediaPlayController getInstance]play];
                [self.musicBt setImage:[UIImage imageNamed:@"4-暂停键"] forState:UIControlStateNormal];
                [_musicBt setTag:PLAY];

            } else if (!self.musicUrl) {
                [self downloadMusic];
                return;
                
            }
            break;
        case PLAY:
            [[MediaPlayController getInstance]pause];
            [self.musicBt setImage:[UIImage imageNamed:@"2播放键"] forState:UIControlStateNormal];
            [_musicBt setTag:READY];
            break;
        case SHOULDSTOP:
            [[MediaPlayController getInstance]stop];
            [self.musicBt setImage:[UIImage imageNamed:@"2播放键"] forState:UIControlStateNormal];
//            [self loadMusic:self.musicUrl];
            [_controller prepareToPlayWithUrl:self.musicUrl];
            [_musicBt setTag:READY];
            break;
        default:
            break;
    }
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
    int offset = frame.origin.y - (self.view.frame.size.height - 280);//键盘高度216
    NSLog(@"offset is %d",offset);
    NSTimeInterval animationDuration = 0.30f;
    if (offset>0&& textField.frame.origin.y > offset) {
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
}

- (void)showError:(NSError *)error functionName:(NSString *)names
{
    [self waitingEnd];
    [ToolUtils showMessage:@"网络请求失败"];
}



- (void)addRightButton:(NSString*)title action:(SEL)action img:(NSString*)img
{
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (img) {
        [button setBackgroundImage:[UIImage imageNamed:img] forState:UIControlStateNormal];

    }
    
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *myAddButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = myAddButton;
}



- (void) waiting:(NSString*)msg
{
    [self addMask];
    if (!self.waitingView) {
        CGRect frame = CGRectMake(110, 200, 100, 100);
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
        if (self.scale==1) {
            [self.view addSubview:self.maskView];
        } else {
            [self.navigationController.view addSubview:self.maskView];
        }
        
    }
    [self.maskView setHidden:NO];
}


- (void)removeMask
{
    [self.maskView setHidden:YES];
//    [self.maskView removeFromSuperview];
}




@end
