//
//  MAOFlipTransition.h
//  MAOFlipViewController
//
//  Created by Mao Nishi on 2014/05/06.
//  Copyright (c) 2014年 Mao Nishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAOFlipInteraction.h"
#define FLIPUPANDDOWN 1
#define FLIPRIGHTANDRIGHT 2
@interface MAOFlipTransition : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) BOOL presenting;
@property (nonatomic,weak ) MAOFlipInteraction* interaction;
@property (nonatomic)NSInteger flipMode;
@end