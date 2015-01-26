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

- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
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



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadMusic
{
    MediaPlayController* controller = [MediaPlayController getInstance];
    if (controller.state!=PLAY) {
        NSString *thePath=[[NSBundle mainBundle] pathForResource:@"平凡之路" ofType:@"mp3"];
        NSLog(@"%@",thePath);
        NSURL *theurl=[NSURL fileURLWithPath:thePath];
        [controller prepareToPlayWithUrl:theurl];
        [self.musicBt setTitle:@"从头开始" forState:UIControlStateNormal];
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
            [self loadMusic];
            
            break;
        default:
            break;
    }
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
