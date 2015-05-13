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
#import "UIImageView+WebCache.h"

@interface NoteDetailViewController ()
<
NoteDetailViewDelegate,
NoteDetailMaskDelegate,
MJPhotoViewDelegate
>

@property (nonatomic) NSNumber *noteID;

@property (nonatomic, getter=isNavigationBarHidden) BOOL navigationBarHidden;

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
    self.noteDetailBrowserlView.frame = self.view.bounds;
}

- (void)dealloc
{
    [self removeObserver:self.noteDetailMask forKeyPath:@"viewStyle"];
}

#pragma mark - action
- (void)closeSelf
{
    if (self.noteDetailMask.viewStyle == NoteDetailViewSingleStyle) {
        //close big image browser
        self.noteDetailMask.viewStyle = NoteDetailViewThumbStyle;
        
        //scroll thumb view to current view
        [self.noteDetailView scrollToIndexVisiable:self.noteDetailBrowserlView.currentPageIndex animated:NO completion:^(CGRect endFrame, UIView *view) {
            
            //show transition animation
            CGRect frameInSelf = [self.view convertRect:endFrame fromView:view];
            [UIView animateWithDuration:.3 animations:^{
                self.noteDetailBrowserlView.frame = frameInSelf;
            } completion:^(BOOL finished) {
                [self.view sendSubviewToBack:self.noteDetailBrowserlView];
            }];
        }];

    }else{
        [super closeSelf];
    }
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
    
    //temp mask
    NSString *url = @"http://pic.wenwen.soso.com/p/20090901/20090901103853-803999540.jpg";
    UIImageView *prototypeImageView = [[UIImageView alloc] initWithFrame:frameInSelf];
    [prototypeImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    prototypeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:prototypeImageView];
    [self.view bringSubviewToFront:self.noteDetailMask];
    
    CGFloat barHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    CGFloat navigationControllerHeight = CGRectGetHeight(self.navigationController.view.frame);

    //here show transition animation
    [UIView animateWithDuration:.3 delay:.1 options:UIViewAnimationOptionCurveLinear animations:^{
        prototypeImageView.frame = CGRectMake(0, -barHeight, CGRectGetWidth(self.view.frame), navigationControllerHeight);
    } completion:^(BOOL finished) {
        [self.view bringSubviewToFront:self.noteDetailBrowserlView];
        [self.view bringSubviewToFront:self.noteDetailMask];
        [prototypeImageView removeFromSuperview];
    }];
}

#pragma mark - MJPhotoViewDelegate
- (void)photoViewImageFinishLoad:(MJPhotoView *)photoView
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)photoViewSingleTap:(MJPhotoView *)photoView
{
    if (self.noteDetailMask.isPoppedView) {
        [self.noteDetailMask dismissPoppedView];
        return;
    }
    
    NSLog(@"hide or show bar");
    self.navigationBarHidden = !self.isNavigationBarHidden;
}

- (void)photoViewDidEndZoom:(MJPhotoView *)photoView
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

#pragma mark - setter && getter
- (void)setNavigationBarHidden:(BOOL)navigationBarHidden
{
    _navigationBarHidden = navigationBarHidden;
    
    [self.noteDetailMask setBottomBarHidden:self.navigationBarHidden];
    [self.navigationController setNavigationBarHidden:self.navigationBarHidden animated:YES];
}

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
        _noteDetailMask = [NoteDetailMask mask];
        _noteDetailMask.delegate = self;
    }
    return _noteDetailMask;
}
@end
