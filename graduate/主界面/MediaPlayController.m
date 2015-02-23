//
//  MediaPlayController.m
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MediaPlayController.h"

@implementation MediaPlayController
MediaPlayController* mediaPlayController = nil;

+(MediaPlayController *)getInstance
{
    @synchronized(self){
        if(mediaPlayController == nil){
            mediaPlayController = [[self alloc] init];
        }
    }

    return mediaPlayController;
}

- (void)setProgressView:(CircularProgressView *)progressView
{
    _progressView = progressView;
    progressView.player = self.audioplayer;
}


-(void)prepareToPlayWithUrl:(NSURL*)url
{
    //2.创建播放器（注意：一个AVAudioPlayer只能播放一个url）
    self.audioplayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
    self.progressView.player = self.audioplayer;
    //3.缓冲
    [self.audioplayer prepareToPlay];
    self.audioplayer.delegate = self;
    mediaPlayController.state = READY;
    self.url = url;
    //4.播放
}

- (void)play
{
    if (self.progressView) {
        [self.progressView play];

    } else {
        [self.audioplayer play];
    }
    mediaPlayController.state = PLAY;
}

- (void) pause
{
    if (self.progressView) {
        [self.progressView pause];
    } else {
        [self.audioplayer pause];
    }
    mediaPlayController.state = PAUSE;

}

- (void)stop
{
    if (self.progressView) {
        [self.progressView revert];
    } else {
        [self.audioplayer stop];
    }
    mediaPlayController.state = STOP;
    
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
    [player play];
}
@end
