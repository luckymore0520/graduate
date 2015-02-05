//
//  BaseFuncVC.m
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "BaseFuncVC.h"

@interface BaseFuncVC ()

@end

@implementation BaseFuncVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (UITextField* field in self.textFields) {
        field.delegate = self;
    }
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
    self.musicUrl = path;
    MediaPlayController* controller = [MediaPlayController getInstance];
    _controller = controller;
    if ([controller.url.absoluteString isEqualToString:path.absoluteString]) {
        [self.musicBt setTitle:@"暂停" forState:UIControlStateNormal];
        [self.musicBt setTag:controller.state];
        return;
    }
    if (controller.state!=PLAY) {
        [controller prepareToPlayWithUrl:path];
        [controller play];
        [self.musicBt setTitle:@"暂停" forState:UIControlStateNormal];
        [self.musicBt setTag:controller.state];
    } else {
        [self.musicBt setTitle:@"停止" forState:UIControlStateNormal];
        [self.musicBt setTag:SHOULDSTOP];
    }
}


- (IBAction)controlMusic:(id)sender {
    switch (self.musicBt.tag) {
        case READY:
            [[MediaPlayController getInstance]play];
            [_musicBt setTitle:@"暂停" forState:UIControlStateNormal];
            [_musicBt setTag:PLAY];
            break;
        case PLAY:
            [[MediaPlayController getInstance]pause];
            [_musicBt setTitle:@"开始" forState:UIControlStateNormal];
            [_musicBt setTag:READY];
            break;
        case SHOULDSTOP:
            [[MediaPlayController getInstance]stop];
            [_musicBt setTitle:@"开始" forState:UIControlStateNormal];
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
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        self.view.frame = rect;
    }
    [UIView commitAnimations];
    [self addMaskBt];
    
       return YES;
}


//增加遮罩按钮，点击键盘弹回
- (void)addMaskBt
{
    if (self.maskBt) {
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
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
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
    [ToolUtils showMessage:alert];
}

- (void)showError:(NSError *)error functionName:(NSString *)names
{
    [ToolUtils showMessage:[error description]];
}



- (void)addRightButton:(NSString*)title action:(SEL)action img:(NSString*)img
{
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    if (img) {
        [button setBackgroundImage:[UIImage imageNamed:img] forState:UIControlStateNormal];

    }
    
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *myAddButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = myAddButton;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)addMask
{
    if (!self.maskView) {
        self.maskView = [[UIView alloc]initWithFrame:self.view.frame];
        [self.maskView setAlpha:0.5];
        [self.maskView setBackgroundColor:[UIColor blackColor]];
    }
    [self.view addSubview:self.maskView];

}
- (void)removeMask
{
    [self.maskView removeFromSuperview];
}
@end
