//
//  GodNoteViewController.m
//  graduate
//
//  Created by yixiaoluo on 15/4/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "GodNoteViewController.h"
#import "GodNoteView.h"
#import "SubjectModel.h"
#import "GodNoteRequestManger.h"

@interface GodNoteViewController ()
<
GodNoteViewDelegate
>

@property (nonatomic) NSInteger currentIndex;

@property (nonatomic) NSMutableArray *allSubjectViews;

@property (nonatomic) NSMutableArray *allSubjectModels;
@property (nonatomic) AdModel *adModel;

@end

@implementation GodNoteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getDataSourceCompletion:^{
       //reload the first tab with data from server
        GodNoteView *firstSubjectView = self.allSubjectViews[0];
        firstSubjectView 
    }];
}

#pragma mark - get Data source
- (void)getDataSourceCompletion:(dispatch_block_t)completion
{
    [GodNoteRequestManger getAllSubjectCompletion:^(NSArray *subjectModels, AdModel *adModel) {
        [self.allSubjectModels removeAllObjects];
        [self.allSubjectModels addObjectsFromArray:subjectModels];
        
        self.adModel = adModel;
        if (completion) {
            completion();
        }
    } failure:^(NSString *errorString) {
        [self showDetailViewController:self sender:nil];
    }];
}

#pragma mark - GodNoteViewDataSource
- (NSString *)godNoteViewRequestAPI
{
    SubjectModel *model = self.allSubjectModels[self.currentIndex];
    return self.currentAPI;
}

- (NSMutableArray *)allSubjectViews
{
    if (!_allSubjectViews) {
        _allSubjectViews = [NSMutableArray array];
    }
    return _allSubjectViews;
}

@end
