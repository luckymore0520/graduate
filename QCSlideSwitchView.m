//
//  QCSlideSwitchView.m
//  QCSliderTableView
//
//  Created by “ 邵鹏 on 14-4-16.
//  Copyright (c) 2014年 Scasy. All rights reserved.
//


#import "QCSlideSwitchView.h"

static const CGFloat kHeightOfTopScrollView = 44.0f;
static const CGFloat kWidthOfButtonMargin = 0.0f;
static const NSUInteger kTagOfRightSideButton = 999;

@implementation QCSlideSwitchView

#pragma mark - 初始化参数

- (void)initValues
{
    //创建顶部可滑动的tab
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, kHeightOfTopScrollView)];
    _topScrollView.delegate = self;
    _topScrollView.backgroundColor = [UIColor clearColor];
    _topScrollView.pagingEnabled = NO;
    _topScrollView.showsHorizontalScrollIndicator = NO;
    _topScrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_topScrollView];
    _userSelectedChannelID = 100;
    
    //创建主滚动视图
    _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kHeightOfTopScrollView, self.bounds.size.width, self.bounds.size.height - kHeightOfTopScrollView)];
    _rootScrollView.delegate = self;
    _rootScrollView.pagingEnabled = YES;
    _rootScrollView.userInteractionEnabled = YES;
    _rootScrollView.bounces = NO;
    _rootScrollView.showsHorizontalScrollIndicator = NO;
    _rootScrollView.showsVerticalScrollIndicator = NO;
    _rootScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    _userContentOffsetX = 0;
    [_rootScrollView.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];
    [self addSubview:_rootScrollView];
    
    _viewArray = [[NSMutableArray alloc] init];
    
    _isBuildUI = NO;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initValues];
    }
    return self;
}

#pragma mark getter/setter

- (void)setRigthSideButton:(UIButton *)rigthSideButton
{
    UIButton *button = (UIButton *)[self viewWithTag:kTagOfRightSideButton];
    [button removeFromSuperview];
    rigthSideButton.tag = kTagOfRightSideButton;
    _rigthSideButton = rigthSideButton;
    [self addSubview:_rigthSideButton];
    
}

#pragma mark - 创建控件

//当横竖屏切换时可通过此方法调整布局
- (void)layoutSubviews
{
    //创建完子视图UI才需要调整布局
    if (_isBuildUI) {
        //如果有设置右侧视图，缩小顶部滚动视图的宽度以适应按钮
        if (self.rigthSideButton.bounds.size.width > 0) {
            _rigthSideButton.frame = CGRectMake(self.bounds.size.width - self.rigthSideButton.bounds.size.width, 0,
                                                _rigthSideButton.bounds.size.width, _topScrollView.bounds.size.height);
            
            _topScrollView.frame = CGRectMake(0, 0,
                                              self.bounds.size.width - self.rigthSideButton.bounds.size.width, kHeightOfTopScrollView);
        }
        
        //更新主视图的总宽度
        _rootScrollView.contentSize = CGSizeMake(self.bounds.size.width * [_viewArray count], 0);
        
        //更新主视图各个子视图的宽度
        for (int i = 0; i < [_viewArray count]; i++) {
            UIViewController *listVC = _viewArray[i];
            listVC.view.frame = CGRectMake(0+_rootScrollView.bounds.size.width*i, 0,
                                           _rootScrollView.bounds.size.width, _rootScrollView.bounds.size.height);
        }
        
        //滚动到选中的视图
        [_rootScrollView setContentOffset:CGPointMake((_userSelectedChannelID - 100)*self.bounds.size.width, 0) animated:NO];
        
        //调整顶部滚动视图选中按钮位置
        UIButton *button = (UIButton *)[_topScrollView viewWithTag:_userSelectedChannelID];
        [self adjustScrollViewContentX:button];
    }
}

/*!
 * @method 创建子视图UI
 * @abstract
 * @discussion
 * @param
 * @result
 */
- (void)buildUI
{
    NSUInteger number = [self.slideSwitchViewDelegate numberOfTab:self];
    
    for (int i=0; i<number; i++) {
        UIViewController *vc = [self.slideSwitchViewDelegate slideSwitchView:self viewOfTab:i];
        [_viewArray addObject:vc];
        [_rootScrollView addSubview:vc.view];
        NSLog(@"%@",[vc.view class]);
    }
    [self createNameButtons];
    
    //选中第一个view
    if (self.slideSwitchViewDelegate && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:didselectTab:)]) {
        [self.slideSwitchViewDelegate slideSwitchView:self didselectTab:_userSelectedChannelID - 100];
    }
    
    _isBuildUI = YES;
    
    //创建完子视图UI才需要调整布局
    [self setNeedsLayout];
}

- (void)selectVCAtIndex:(NSInteger)index
{
    UIButton *button = (UIButton *)[_topScrollView viewWithTag:index+100];
    [self selectNameButton:button];
    [self.slideSwitchViewDelegate slideSwitchView:self didselectTab:index];
}
/*!
 * @method 初始化顶部tab的各个按钮
 * @abstract
 * @discussion
 * @param
 * @result
 */
- (void)createNameButtons
{
    
    _shadowImageView = [[UIView alloc] init];
    [_shadowImageView setBackgroundColor:self.shadowColor];
    [_topScrollView addSubview:_shadowImageView];
    
    //顶部tabbar的总长度
    CGFloat topScrollViewContentWidth = kWidthOfButtonMargin;
    //每个tab偏移量
    CGFloat xOffset = kWidthOfButtonMargin;
    if (!_buttonNormalImages) {
        CGFloat width = [[UIScreen mainScreen]bounds].size.width/3;
        for (int i = 0; i < [_viewArray count]; i++) {
            UIViewController *vc = _viewArray[i];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            topScrollViewContentWidth += kWidthOfButtonMargin+width;
            //设置按钮尺寸
            [button setFrame:CGRectMake(xOffset,0,
                                        width, kHeightOfTopScrollView)];
            //计算下一个tab的x偏移量
            xOffset += width + kWidthOfButtonMargin;
            [button setTag:i+100];
            if (i == 0) {
                _shadowImageView.frame = CGRectMake(kWidthOfButtonMargin, 0, width, _shadowImage.size.height);
                button.selected = YES;
            }
            [button setTitle:vc.title forState:UIControlStateNormal];
            button.titleLabel.font =  [UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:15.0];
            [button setTitleColor:self.tabItemNormalColor forState:UIControlStateNormal];
            [button setTitleColor:self.tabItemSelectedColor forState:UIControlStateSelected];
            [button setBackgroundImage:self.tabItemNormalBackgroundImage forState:UIControlStateNormal];
            [button setBackgroundImage:self.tabItemSelectedBackgroundImage forState:UIControlStateSelected];
            [button addTarget:self action:@selector(selectNameButton:) forControlEvents:UIControlEventTouchUpInside];
            [_topScrollView addSubview:button];
            if (i==0) {
                button.transform = CGAffineTransformMakeScale(1.1, 1.1);
            }
        }
        _topScrollView.contentSize = CGSizeMake(topScrollViewContentWidth, kHeightOfTopScrollView);

    } else {
        CGFloat width = [[UIScreen mainScreen]bounds].size.width/_buttonNormalImages.count;
        for (int i = 0 ; i < _buttonNormalImages.count ; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            CGRect frame = CGRectMake(i*width, 0, width, kHeightOfTopScrollView);
            button.frame = frame;
            [button setImage:[UIImage imageNamed:_buttonNormalImages[i]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:_buttonSelectedImages[i]] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(selectNameButton:) forControlEvents:UIControlEventTouchUpInside];
            [button setTag:i+100];
            if (i == 0) {
                _shadowImageView.frame = CGRectMake( 0,kHeightOfTopScrollView-2, self.frame.size.width/_buttonNormalImages.count, 2);
                button.selected = YES;
            }
            [_topScrollView addSubview:button];
        }
        [_topScrollView setScrollEnabled:NO];
        _topScrollView.contentSize = CGSizeMake(self.frame.size.width, kHeightOfTopScrollView);

    }
    
    //设置顶部滚动视图的内容总尺寸
}


#pragma mark - 顶部滚动视图逻辑方法

/*!
 * @method 选中tab时间
 * @abstract
 * @discussion
 * @param 按钮
 * @result
 */
- (void)selectNameButton:(UIButton *)sender
{
    //如果点击的tab文字显示不全，调整滚动视图x坐标使用使tab文字显示全
    [self adjustScrollViewContentX:sender];
    
    //如果更换按钮
    if (sender.tag != _userSelectedChannelID) {
        //取之前的按钮
        UIButton *lastButton = (UIButton *)[_topScrollView viewWithTag:_userSelectedChannelID];
        lastButton.transform = CGAffineTransformMakeScale(1, 1);

        lastButton.selected = NO;
        //赋值按钮ID
        _userSelectedChannelID = sender.tag;
    }
    
    //按钮选中状态
    if (!sender.selected) {
        sender.selected = YES;
        sender.transform = CGAffineTransformMakeScale(1.1, 1.1);
        [UIView animateWithDuration:0.25 animations:^{
            
            [_shadowImageView setFrame:CGRectMake(sender.frame.origin.x, kHeightOfTopScrollView-2, sender.frame.size.width, 2)];
            
        } completion:^(BOOL finished) {
            if (finished) {
                //设置新页出现
                if (!_isRootScroll) {
                    [_rootScrollView setContentOffset:CGPointMake((sender.tag - 100)*self.bounds.size.width, 0) animated:YES];
                }
                _isRootScroll = NO;
                
                if (self.slideSwitchViewDelegate && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:didselectTab:)]) {
                    [self.slideSwitchViewDelegate slideSwitchView:self didselectTab:_userSelectedChannelID - 100];
                }
            }
        }];
        
    }
    //重复点击选中按钮
    else {
        
    }
}

/*!
 * @method 调整顶部滚动视图x位置
 * @abstract
 * @discussion
 * @param
 * @result
 */
- (void)adjustScrollViewContentX:(UIButton *)sender
{
    CGFloat margin = kWidthOfButtonMargin;
    if (!_buttonNormalImages) {
        margin = [[UIScreen mainScreen]bounds].size.width/3;
    }
    if (_viewArray.count==1) {
        return;
    }
    //如果 当前显示的最后一个tab文字超出右边界
    if (sender.frame.origin.x - _topScrollView.contentOffset.x > self.bounds.size.width - (margin+sender.bounds.size.width)) {
        //向左滚动视图，显示完整tab文字
        [_topScrollView setContentOffset:CGPointMake(sender.frame.origin.x - (_topScrollView.bounds.size.width- (margin+sender.bounds.size.width)), 0)  animated:YES];
    } else
    
    //如果 （tab的文字坐标 - 当前滚动视图左边界所在整个视图的x坐标） < 按钮的隔间 ，代表tab文字已超出边界
    if (sender.frame.origin.x - _topScrollView.contentOffset.x < margin) {
        //向右滚动视图（tab文字的x坐标 - 按钮间隔 = 新的滚动视图左边界在整个视图的x坐标），使文字显示完整
        [_topScrollView setContentOffset:CGPointMake(sender.frame.origin.x - margin, 0)  animated:YES];
    }
}

#pragma mark 主视图逻辑方法

//滚动视图开始时
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == _rootScrollView) {
        _userContentOffsetX = scrollView.contentOffset.x;
    }
}

//滚动视图结束
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _rootScrollView) {
        //判断用户是否左滚动还是右滚动
        if (_userContentOffsetX < scrollView.contentOffset.x) {
            _isLeftScroll = YES;
        }
        else {
            _isLeftScroll = NO;
        }
    }
}

//滚动视图释放滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _rootScrollView) {
        _isRootScroll = YES;
        //调整顶部滑条按钮状态
        int tag = round(scrollView.contentOffset.x/self.frame.size.width) +100;
        UIButton *button = (UIButton *)[_topScrollView viewWithTag:tag];
        [self selectNameButton:button];
        
        [self.slideSwitchViewDelegate slideSwitchView:self didselectTab:tag-100];
        
    }
}

//传递滑动事件给下一层
-(void)scrollHandlePan:(UIPanGestureRecognizer*) panParam
{
    //当滑道左边界时，传递滑动事件给代理
    if(_rootScrollView.contentOffset.x <= 0) {
        if (self.slideSwitchViewDelegate
            && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:panLeftEdge:)]) {
            [self.slideSwitchViewDelegate slideSwitchView:self panLeftEdge:panParam];
        }
    } else if(_rootScrollView.contentOffset.x >= _rootScrollView.contentSize.width - _rootScrollView.bounds.size.width) {
        if (self.slideSwitchViewDelegate
            && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:panRightEdge:)]) {
            [self.slideSwitchViewDelegate slideSwitchView:self panRightEdge:panParam];
        }
    }
}

- (UIViewController*) currentVC
{
    int current = round(_rootScrollView.contentOffset.x/self.frame.size.width);
    return _viewArray[current];
}
#pragma mark - 工具方法

/*!
 * @method 通过16进制计算颜色
 * @abstract
 * @discussion
 * @param 16机制
 * @result 颜色对象
 */
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

@end

