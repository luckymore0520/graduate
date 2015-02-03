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


-(void)prepareToPlayWithUrl:(NSURL*)url
{
    //2.创建播放器（注意：一个AVAudioPlayer只能播放一个url）
    self.audioplayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
    //3.缓冲
    [self.audioplayer prepareToPlay];
    mediaPlayController.state = READY;
    self.url = url;
    //4.播放
}

- (void)play
{
    [self.audioplayer play];
    mediaPlayController.state = PLAY;
}

- (void) pause
{
    [self.audioplayer pause];
    mediaPlayController.state = PAUSE;

}

- (void)stop
{
    [self.audioplayer stop];
    mediaPlayController.state = STOP;
    
}
@end
