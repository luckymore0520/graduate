//
//  MediaPlayController.h
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "CircularProgressView.h"
#define READY 1
#define PLAY 2
#define PAUSE 3
#define SHOULDSTOP 4
#define STOP 5

@interface MediaPlayController : NSObject<AVAudioPlayerDelegate>
+(MediaPlayController *)getInstance;
@property (nonatomic,strong)CircularProgressView* progressView;

@property(nonatomic,strong)AVAudioPlayer *audioplayer;
@property (nonatomic)NSInteger state;
@property (nonatomic,strong)NSURL* url;
-(void)prepareToPlayWithUrl:(NSURL*)url;
- (void)play;
- (void) pause;
- (void)stop;
@end
