//
//  MyCollectionRootView.m
//  graduate
//
//  Created by luck-mac on 15/3/17.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MyCollectionRootView.h"
#import "EssenceListViewController.h"
#import "QCSlideSwitchView.h"
@interface MyCollectionRootView ()<QCSlideSwitchViewDelegate>
@property (weak, nonatomic) IBOutlet QCSlideSwitchView *slideSwitchView;
@property (nonatomic,strong) NSArray* typeArray;
@end

@implementation MyCollectionRootView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"我的收藏"];
    self.slideSwitchView.tabItemNormalColor = [QCSlideSwitchView colorFromHexRGB:@"868686"];
    self.slideSwitchView.tabItemSelectedColor = [QCSlideSwitchView colorFromHexRGB:@"bb0b15"];
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow.png"]
                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    self.slideSwitchView.buttonNormalImages = @[@"全部",@"视频",@"音频",@"文档"];
    self.slideSwitchView.slideSwitchViewDelegate = self;
    self.slideSwitchView.shadowColor = [UIColor colorWithHex:0x429dd7];
    self.typeArray = @[@-1,@0,@1,@2];
    [self.slideSwitchView buildUI];
}

- (void)initViews
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - QCSlideViewDelegate

- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    return 4;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"EssenceStoryboard" bundle:nil];
    EssenceListViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"essenceList"];
    vc.type = [[_typeArray objectAtIndex:number] integerValue];
    vc.parentVC = self;
    vc.isMyCollection = YES;
    return vc;
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
