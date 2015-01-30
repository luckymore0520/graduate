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


@interface MediaPlayVC ()<ApiDelegate>
@property (weak, nonatomic) IBOutlet UIView *mediaView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic,strong)MPMoviePlayerController* moviePlayer;
@property (nonatomic,strong)LoginVC* rootVC;
@end

@implementation MediaPlayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIStoryboard *userSB = [UIStoryboard storyboardWithName:@"User" bundle:nil];
    self.rootVC = (LoginVC*)[userSB instantiateViewControllerWithIdentifier:@"login"];
    // Do any additional setup after loading the view.
    
    MGetWelcome* getWelcome = [[MGetWelcome alloc]init];
    [getWelcome load:self];
}


- (IBAction)goToLogin:(id)sender {
    [self.navigationController pushViewController:self.rootVC animated:YES];
        
}

- (void) viewDidAppear:(BOOL)animated
{
    
    NSString *thePath=[[NSBundle mainBundle] pathForResource:@"myVideo" ofType:@"m4v"];
    NSLog(@"%@",thePath);
    NSURL *theurl=[NSURL fileURLWithPath:thePath];
    self.moviePlayer=[[MPMoviePlayerController alloc] initWithContentURL:theurl];
    [self.moviePlayer.view setFrame:self.mediaView.frame];
    [self.moviePlayer prepareToPlay];
    [self.moviePlayer setShouldAutoplay:NO]; // And other options you can look through the documentation.
    [self.mediaView addSubview:self.moviePlayer.view];
//    [self.moviePlayer setFullscreen:YES];
    [self.moviePlayer.view setUserInteractionEnabled:NO];
    self.moviePlayer.controlStyle = MPMovieControlStyleNone;
    for (UIView* type in [self.moviePlayer.backgroundView subviews]) {
        NSLog(@"%@",type.class);
    }
    
//    [[self.moviePlayer.backgroundView.superview subviews]objectAtIndex:2];
    [self.moviePlayer play];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dispos:(NSDictionary*) data functionName:(NSString*)names
{
    if ([names isEqualToString:@"MGetWelcomePage"]) {
        MReturn* ret = [MReturn objectWithKeyValues:data];
        NSLog(@"%@",ret.msg_);
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
