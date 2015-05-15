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
#import "NoteBookModel.h"

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

@property (nonatomic) NSArray *noteBookList;//datasource

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
    
    [self transitionToViewStyle:NoteDetailViewThumbStyle];
    
    [self.noteDetailMask addObserver:self forKeyPath:@"viewStyle" options:NSKeyValueObservingOptionNew context:nil];
    
    [self getAllNoteBooks];
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

#pragma mark - request
- (void)getAllNoteBooks
{
    //you should get the data from server
    
    
    //prepare demo text
    //you should get it from server
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"NoteList" ofType:@"txt"];
    NSString *textString = [[NSString alloc] initWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
    NSData *textData = [textString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSArray *allNotes = [NSJSONSerialization JSONObjectWithData:textData options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        NSLog(@"parse %@", error);
    }
    
    NSMutableArray *demoArray = [NSMutableArray array];
    [allNotes enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        [demoArray addObject:[NoteBookModel fromDictionary:obj]];
    }];
    
    self.noteBookList = demoArray;
    
    //NOTE! they contain the same datasource
    [self.noteDetailView reloadViewWithNoteBooks:self.noteBookList];
    [self.noteDetailBrowserlView reloadViewWithNoteBooks:self.noteBookList];
}

#pragma mark - UINavigationItems
- (void)transitionToViewStyle:(NoteDetailViewStyle)style
{
    //make right navigation items hide or show
    NSArray *allItems = [self buildRightNaivgationBarItemsWithStyle:style];
    [self.navigationItem setRightBarButtonItems:allItems animated:YES];
}

#pragma mark - action
- (void)closeSelf
{
    if (self.noteDetailMask.viewStyle == NoteDetailViewSingleStyle) {
        //close big image browser
        self.noteDetailMask.viewStyle = NoteDetailViewThumbStyle;
        
        if (self.noteDetailMask.isPoppedView) {
            [self.noteDetailMask dismissPoppedView];
            return;
        }

        //scroll thumb view cell to visiable area
        [self.noteDetailView scrollToIndexVisiable:self.noteDetailBrowserlView.currentPageIndex animated:NO completion:^(UIImageView *imageView) {
            
            //show transition animation
            CGRect frameInSelf = [self.view convertRect:imageView.frame fromView:imageView.superview];
            
            UIImageView *imageViewInThumber = imageView;
            UIView *imageViewSuperView = imageViewInThumber.superview;
            CGRect originFrame = imageViewInThumber.frame;
            
            UIImageView *imageViewInSingle = [self.noteDetailBrowserlView currentPhotoView].imageView;
            CGRect originFramesInSelf = [self.view convertRect:imageViewInSingle.frame fromView:imageViewInSingle.superview];
            
            [imageViewInThumber removeFromSuperview];
            imageViewInThumber.frame = originFramesInSelf;
            [self.view addSubview:imageViewInThumber];
            
            [self.view sendSubviewToBack:self.noteDetailBrowserlView];

            [UIView animateWithDuration:.3 animations:^{
                imageViewInThumber.frame = frameInSelf;
            } completion:^(BOOL finished) {
                [imageViewInThumber removeFromSuperview];
                [imageViewSuperView addSubview:imageViewInThumber];
                imageViewInThumber.frame = originFrame;
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
        //transition navigation bar
        [self transitionToViewStyle:style];
        [self.noteDetailMask transitionToViewStyle:style];
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
- (void)noteDetailView:(NoteDetailView *)noteDetailView didSelectItemAtIndex:(NSInteger)itemIndex imageView:(UIImageView *)imageView{
    
    self.noteDetailMask.viewStyle = NoteDetailViewSingleStyle;
    
    //prepare new view
    [self.noteDetailBrowserlView startBrowsingFromPage:itemIndex];

    CGRect frameInSelf = [self.view convertRect:imageView.frame fromView:imageView.superview];
    self.noteDetailBrowserlView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageViewInBrowser = self.noteDetailBrowserlView.currentPhotoView.imageView;
    UIView *imageViewSuperView = imageViewInBrowser.superview;
    CGRect originFrame = imageViewInBrowser.frame;
    CGRect originFramesInSelf = [self.view convertRect:originFrame fromView:imageViewSuperView];
    
    [self.view bringSubviewToFront:self.noteDetailBrowserlView];

    [imageViewInBrowser removeFromSuperview];
    imageViewInBrowser.frame = frameInSelf;
    [self.view addSubview:imageViewInBrowser];
    
    [self.view bringSubviewToFront:self.noteDetailMask];
    
    [UIView animateWithDuration:.3 animations:^{
        imageViewInBrowser.frame = originFramesInSelf;
    } completion:^(BOOL finished) {
        [imageViewInBrowser removeFromSuperview];
        [imageViewSuperView addSubview:imageViewInBrowser];
        imageViewInBrowser.frame = originFrame;
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

- (NSArray *)buildRightNaivgationBarItemsWithStyle:(NoteDetailViewStyle)style
{
    NSMutableArray *array = [NSMutableArray array];
    
    UIBarButtonItem *(^getAButton)(NSString *imageName, NSString *title) = ^(NSString *imageName, NSString *title) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, 0, 60, 44)];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        return [[UIBarButtonItem alloc] initWithCustomView:button];
    };
    
    switch (style) {
        case NoteDetailViewThumbStyle: {
            break;
        }
        case NoteDetailViewSingleStyle: {
            [array addObject:getAButton(@"关于我们", @"")];
            [array addObject:getAButton(@"关于我们", @"旋转")];
            [array addObject:getAButton(@"关于我们", @"重点")];
            break;
        }
        default: {
            break;
        }
    }
    
    return array;
}

- (NoteDetailView *)noteDetailView
{
    if (!_noteDetailView) {
        _noteDetailView = [[NoteDetailView alloc] init];
        _noteDetailView.delegate = self;
    }
    return _noteDetailView;
}

- (NoteDetailBrowserView *)noteDetailBrowserlView
{
    if (!_noteDetailBrowserlView) {
        _noteDetailBrowserlView = [[NoteDetailBrowserView alloc] init];
        _noteDetailBrowserlView.backgroundColor = [UIColor blackColor];
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
