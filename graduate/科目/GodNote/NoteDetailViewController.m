//
//  NoteDetailViewController.m
//  graduate
//
//  Created by yixiaoluo on 15/5/10.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "NoteDetailViewController.h"
#import "NoteDetailView.h"
#import "NoteDetailBrowserView.h"
#import "MJPhoto.h"
#import "NoteDetailMask.h"

@interface NoteDetailViewController ()
<
NoteDetailViewDelegate,
NoteDetailMaskDelegate,
MJPhotoViewDelegate
>

@property (nonatomic) NSNumber *noteID;

@property (nonatomic) NoteDetailView *noteDetailView;
@property (nonatomic) NoteDetailBrowserView *noteDetailBrowserlView;
@property (nonatomic) NoteDetailMask *noteDetailMask;

@end

@implementation NoteDetailViewController

- (instancetype)initWithNoteID:(NSNumber *)noteID
{
    self = [super initWithNibName:nil bundle:nil];
    self.noteID = noteID;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.noteDetailBrowserlView];
    [self.view addSubview:self.noteDetailView];
    [self.view addSubview:self.noteDetailMask];
    
    [self addObserver:self.noteDetailMask forKeyPath:@"viewStyle" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.noteDetailView.frame = (CGRect){self.view.bounds.origin, {CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - BottomBarHeight}};
    self.noteDetailMask.frame = self.view.bounds;
}

- (void)dealloc
{
    [self removeObserver:self.noteDetailMask forKeyPath:@"viewStyle"];
}

#pragma mark - observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"viewStyle"]) {
        NoteDetailViewStyle style = [change[NSKeyValueChangeNewKey] integerValue];
        //update navigation bar
        switch (style) {
            case NoteDetailViewThumbStyle:
                
                break;
            case NoteDetailViewSingleStyle:

                break;
                
            default:
                break;
        }
    }
}

#pragma mark - NoteDetailMaskDelegate
- (void)noteDetailMaskDidSelectAttention:(NoteDetailMask *)bar//爱心
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)noteDetailMaskDidSelectComment:(NoteDetailMask *)bar//评论
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)noteDetailMaskDidSelectRemark:(NoteDetailMask *)bar//添加备注
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)noteDetailMaskDidSelectNotice:(NoteDetailMask *)bar//只看重点
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)noteDetailMaskDidSelectShare:(NoteDetailMask *)bar//分享
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

#pragma mark - NoteDetailViewDelegate
- (void)noteDetailView:(NoteDetailView *)noteDetailView didSelectItem:(id)item fromRect:(CGRect)frame
{
    CGRect frameInSelf = [self.view convertRect:frame fromView:noteDetailView];
    NSLog(@" noteDetailView cell: %@", NSStringFromCGRect(frameInSelf));
    
    self.noteDetailMask.viewStyle = NoteDetailViewSingleStyle;
    
    //here show transition animation
    self.noteDetailBrowserlView.frame = frameInSelf;
    [self.view bringSubviewToFront:self.noteDetailBrowserlView];
    
    [UIView animateWithDuration:.3 animations:^{
        CGFloat barHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
        CGFloat navigationControllerHeight = CGRectGetHeight(self.navigationController.view.frame);
        self.noteDetailBrowserlView.frame = CGRectMake(0, -barHeight, CGRectGetWidth(self.view.frame), navigationControllerHeight);
    } completion:^(BOOL finished) {

    }];
}

#pragma mark - MJPhotoViewDelegate
- (void)photoViewImageFinishLoad:(MJPhotoView *)photoView
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)photoViewSingleTap:(MJPhotoView *)photoView
{
    NSLog(@"hide or show bar");
    self.noteDetailMask.viewStyle = NoteDetailViewThumbStyle;
    
    //scroll thumb view to current view
    [self.noteDetailView scrollToIndexVisiable:photoView.photo.index animated:NO completion:^(CGRect endFrame, UIView *view) {
       
        //show transition animation
        CGRect frameInSelf = [self.view convertRect:endFrame fromView:view];
        [UIView animateWithDuration:.3 animations:^{
            self.noteDetailBrowserlView.frame = frameInSelf;
        } completion:^(BOOL finished) {
            [self.view sendSubviewToBack:self.noteDetailBrowserlView];
        }];
    }];

}

- (void)photoViewDidEndZoom:(MJPhotoView *)photoView
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

#pragma mark - setter && getter
- (NoteDetailView *)noteDetailView
{
    if (!_noteDetailView) {
        _noteDetailView = [[NoteDetailView alloc] init];
        _noteDetailView.backgroundColor = [UIColor yellowColor];
        _noteDetailView.delegate = self;
    }
    return _noteDetailView;
}

- (NoteDetailBrowserView *)noteDetailBrowserlView
{
    if (!_noteDetailBrowserlView) {
        _noteDetailBrowserlView = [[NoteDetailBrowserView alloc] init];
        _noteDetailBrowserlView.backgroundColor = [UIColor orangeColor];
        _noteDetailBrowserlView.delegate = self;
    }
    return _noteDetailBrowserlView;
}

- (NoteDetailMask *)noteDetailMask
{
    if (!_noteDetailMask) {
        _noteDetailMask = [[NoteDetailMask alloc] init];
        _noteDetailMask.delegate = self;
    }
    return _noteDetailMask;
}
@end
