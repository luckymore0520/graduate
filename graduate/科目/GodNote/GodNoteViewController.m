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
#import "GodNoteHeader.h"

@interface GodNoteViewController ()
<
GodNoteViewDelete
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
        //layout all subject view
        for (NSInteger i = 0; i < self.allSubjectModels.count; i++) {
            GodNoteView *view = [[GodNoteView alloc] init];
            view.delegate = self;
            [self.allSubjectViews addObject:view];
        }
        
       //reload the first tab with data from server
        if (self.allSubjectViews.count > 0 && self.allSubjectViews.count > 0) {
            GodNoteView *firstSubjectView = self.allSubjectViews[0];
            [firstSubjectView reloadViewWithSubjectModel:self.allSubjectModels[0]];
        }
    }];
}

#pragma mark - GodNoteViewDelete
- (void)noteView:(GodNoteView *)noteView didSelectItem:(SubjectNote *)note
{
    
}

#pragma mark - GodNoteHeaderDelegate
- (void)noteHeader:(GodNoteHeader *)header didSelectItem:(SubjectModel *)sModel
{

}

- (void)noteHeader:(GodNoteHeader *)header didSelectAdvertisementWithURL:(NSString *)adURL
{

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

#pragma mark - setter && getter
- (NSMutableArray *)allSubjectViews
{
    if (!_allSubjectViews) {
        _allSubjectViews = [NSMutableArray array];
    }
    return _allSubjectViews;
}

@end
