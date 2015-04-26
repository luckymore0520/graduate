//
//  GodNoteViewController.m
//  graduate
//
//  Created by yixiaoluo on 15/4/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "GodNoteViewController.h"
#import "GodNoteView.h"

@interface GodNoteViewController ()
<
GodNoteViewDelegate
>

@property (nonatomic) GodNoteView *godNoteView;

@property (nonatomic) NSString *currentAPI;

@end

@implementation GodNoteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.godNoteView = [[GodNoteView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.godNoteView];
}

#pragma mark - GodNoteViewDelegate
- (NSString *)godNoteViewRequestAPI
{
    return self.currentAPI;
}

@end
