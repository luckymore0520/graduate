//
//  MediaPlayVC.m
//  graduate
//
//  Created by luck-mac on 15/1/23.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MediaPlayVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import "LoginVC.h"
#import "MGetWelcome.h"
#import "MReturn.h"
#import "RootViewController.h"
#import "MUser.h"


@interface MediaPlayVC ()<ApiDelegate>
@property (weak, nonatomic) IBOutlet UIView *mediaView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic,strong)MPMoviePlayerController* moviePlayer;
@property (weak, nonatomic) IBOutlet UIButton *jumpButton;
@property (nonatomic,strong)RootViewController* rootVC;
@property (nonatomic,strong)NSTimer* timer;
@end

@implementation MediaPlayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(play) name:@"ENTERFOREGROUND" object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)play
{
    [_moviePlayer play];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!self.moviePlayer) {
        if([ToolUtils connectToInternet]){
            MGetWelcome* getWelcome = [[MGetWelcome alloc]init];
            [getWelcome load:self];
        }
        NSString *thePath=[[NSBundle mainBundle] pathForResource:@"Movie" ofType:@"mp4"];
        NSURL *theurl=[NSURL fileURLWithPath:thePath];
        self.moviePlayer=[[MPMoviePlayerController alloc] initWithContentURL:theurl];
        [self.moviePlayer.view setFrame:self.mediaView.frame];
        [self.moviePlayer prepareToPlay];
        [self.moviePlayer setShouldAutoplay:YES]; // And other options you can look through the documentation.
        [self.mediaView addSubview:self.moviePlayer.view];
        [self.moviePlayer.view setUserInteractionEnabled:NO];
        self.moviePlayer.controlStyle = MPMovieControlStyleNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    }
    [self.moviePlayer play];
}

- (IBAction)goToLogin:(id)sender {
    [self.moviePlayer stop];
    self.moviePlayer = nil;
    if([ToolUtils getHasLogin]){
        UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"Func" bundle:nil];
//        self.rootVC =(RootViewController*)[myStoryBoard instantiateViewControllerWithIdentifier:@"root"];
        [self.navigationController pushViewController:(RootViewController*)[myStoryBoard instantiateViewControllerWithIdentifier:@"root"] animated:YES];
//        self.rootVC = (LoginVC*)[userSB instantiateViewControllerWithIdentifier:@"login"];
    }else{
        UIStoryboard *userSB ;
        userSB = [UIStoryboard storyboardWithName:@"User" bundle:nil];
        [self.navigationController pushViewController:(LoginVC*)[userSB instantiateViewControllerWithIdentifier:@"login"] animated:YES];
    }
}

- (IBAction)showJumpButton:(id)sender {
    [_jumpButton setHidden:NO];
}

-(void) movieFinish:(id)object
{
    [_nextButton setHidden:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dispos:(NSDictionary*) data functionName:(NSString*)names
{
    if ([names isEqualToString:@"MGetWelcomePage"]) {
        MUser* user = [MUser objectWithKeyValues:data];
        if([user.verify_ length]){
            [ToolUtils setUserInfomation:user.keyValues];
            [ToolUtils setDiaryDefault:user.diaryDefault_];
            [ToolUtils setAboutUrl:user.aboutusUrl_];
            [ToolUtils setContactUrl:user.contactUrl_];

            [ToolUtils setHasLogin:YES];
        }
//        NSLog(@"%@",user);
    }
    
}
- (void)showError:(NSError*) error functionName:(NSString*)names
{
    [ToolUtils showMessage:error.description];
}
- (void) showAlert:(NSString*) alert
{
    [ToolUtils showMessage:alert];
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
