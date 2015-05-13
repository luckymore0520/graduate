//
//  GodNoteViewController.m
//  graduate
//
//  Created by yixiaoluo on 15/4/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "GodNoteViewController.h"
#import "NoteDetailViewController.h"
#import "GodNoteView.h"
#import "SubjectModel.h"
#import "GodNoteRequestManger.h"
#import "GodNoteHeader.h"
#import "SubjectAdapter.h"
#import "GodNoteMacro.h"

@interface GodNoteViewController ()
<
GodNoteViewDelete,
GodNoteHeaderDelegate
>

@property (nonatomic) NSInteger currentIndex;

@property (nonatomic) GodNoteHeader *godNoteHeader;
@property (nonatomic) NSMutableArray *allSubjectViews;
@property (nonatomic) NSMutableArray *allSubjectModels;

@end

@implementation GodNoteViewController

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"大神笔记";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"大神榜" style:UIBarButtonItemStylePlain target:self action:@selector(displayGodRanking)];
    
    //build all subject models
    [self.allSubjectModels addObject:[SubjectAdapter buildAnEnglishSubject]];
    [self.allSubjectModels addObject:[SubjectAdapter buildAMathSubject]];
    [self.allSubjectModels addObject:[SubjectAdapter buildAPolitySubject]];
    
    //build all subject views
    for (NSInteger i = 0; i < self.allSubjectModels.count; i++) {
        GodNoteView *view = [[GodNoteView alloc] init];
        view.backgroundColor = RGBa(i, i*20, i*30, 1);
        view.delegate = self;
        [self.allSubjectViews addObject:view];
        
        [self.view addSubview:view];
    }
    
    //build header
    self.godNoteHeader = [[GodNoteHeader alloc] init];
    self.godNoteHeader.delegate = self;
    self.godNoteHeader.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.godNoteHeader];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat headerHeight = 60;
    self.godNoteHeader.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), headerHeight);
    for (UIView *view in self.allSubjectViews) {
        view.frame = CGRectMake(0, headerHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - headerHeight);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //reload the first tab with data from server
    [self displayViewAtIndex:0];
    
    SubjectModel *model = self.allSubjectModels[0];
    [self.godNoteHeader reloadViewWithAllSubjectModels:self.allSubjectModels
                                             andAdmdel:model.adModel];
}

#pragma mark - actions
- (void)displayViewAtIndex:(NSInteger)viewIndex
{
    if (viewIndex < self.allSubjectViews.count && viewIndex < self.allSubjectViews.count) {
        GodNoteView *noteView = self.allSubjectViews[viewIndex];
        [self.view bringSubviewToFront:noteView];
        
        SubjectModel *model = self.allSubjectModels[viewIndex];
        __weak typeof(self) weakSelf = self;
        [noteView reloadViewWithSubjectModel:self.allSubjectModels[viewIndex] completion:^{
            //refresh advertisement after get notes
            [weakSelf.godNoteHeader reloadViewWithAllSubjectModels:self.allSubjectModels
                                                         andAdmdel:model.adModel];
        }];
    }
}

#pragma mark - response
- (void)displayGodRanking
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

#pragma mark - GodNoteViewDelete
- (void)noteView:(GodNoteView *)noteView didSelectItem:(BookModel *)book
{
    NoteDetailViewController *detail = [[NoteDetailViewController alloc] initWithNoteID:book.bookID];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - GodNoteHeaderDelegate
- (void)noteHeader:(GodNoteHeader *)header didSelectItem:(SubjectModel *)sModel atIndex:(NSInteger)itemIndex
{
    //you can do some animation here
    [self displayViewAtIndex:itemIndex];
}

- (void)noteHeader:(GodNoteHeader *)header didSelectAdvertisementWithURL:(NSString *)adURL
{

}

- (void)noteHeaderDidCloseAdvertisement:(GodNoteHeader *)header
{

}

#pragma mark - setter && getter
- (NSMutableArray *)allSubjectViews
{
    if (!_allSubjectViews) {
        _allSubjectViews = [NSMutableArray array];
    }
    return _allSubjectViews;
}

- (NSMutableArray *)allSubjectModels
{
    if (!_allSubjectModels) {
        _allSubjectModels = [NSMutableArray array];
    }
    return _allSubjectModels;
}
@end
