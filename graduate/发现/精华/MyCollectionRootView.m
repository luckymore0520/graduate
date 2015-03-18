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
#import "MEssenceCollect.h"
@interface MyCollectionRootView ()<QCSlideSwitchViewDelegate>
@property (weak, nonatomic) IBOutlet QCSlideSwitchView *slideSwitchView;
@property (nonatomic,strong) NSArray* typeArray;
@property (nonatomic,strong) NSMutableArray* removeArray;
@property (nonatomic) BOOL selectedMode;
@property (nonatomic,strong) NSMutableArray* myControllers;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBarLocation;
@property (nonatomic)int count;

@end

@implementation MyCollectionRootView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"我的收藏"];
    _removeArray = [[NSMutableArray alloc]init];
    self.slideSwitchView.tabItemNormalColor = [QCSlideSwitchView colorFromHexRGB:@"868686"];
    self.slideSwitchView.tabItemSelectedColor = [QCSlideSwitchView colorFromHexRGB:@"bb0b15"];
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow.png"]
                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    self.slideSwitchView.buttonNormalImages = @[@"全部",@"视频",@"音频",@"文档"];
    self.slideSwitchView.slideSwitchViewDelegate = self;
    self.slideSwitchView.shadowColor = [UIColor colorWithHex:0x429dd7];
    self.typeArray = @[@-1,@0,@1,@2];
    _myControllers = [[NSMutableArray alloc]init];
    for (NSNumber* number in self.typeArray) {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"EssenceStoryboard" bundle:nil];
        EssenceListViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"essenceList"];
        vc.type = [number integerValue];
        vc.parentVC = self;
        vc.isMyCollection = YES;
        [_myControllers addObject:vc];
    }
    [self.slideSwitchView buildUI];
    _count = 0;
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
    return _myControllers[number];
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    
}


- (void)setSelectedMode:(BOOL)selectedMode
{
    _selectedMode = selectedMode;
    if (selectedMode) {
        [UIView animateWithDuration:0.3 animations:^{
            _toolBarLocation.constant = 0;
            [self.view layoutIfNeeded];
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            _toolBarLocation.constant = -45;
            [self.view layoutIfNeeded];
        }];
    }
    _removeArray = [[NSMutableArray alloc]init];
    for (EssenceListViewController* listView in self.myControllers) {
        [listView setSelectedMode:_selectedMode];
    }
}
- (IBAction)selectAll:(id)sender {
    UIButton* button = (UIButton*)sender;
    [button setSelected:!button.selected];
    [(EssenceListViewController*)_slideSwitchView.currentVC selectAll:((UIButton*)sender).selected];
}

- (IBAction)ensureDelete:(id)sender {
    for (NSString* str in self.removeArray) {
        MEssenceCollect* collect = [[MEssenceCollect alloc]init];
        [collect load:self id:str type:0];
    }
}

- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    _count++;
    if (_count == self.removeArray.count) {
        [self.removeArray removeAllObjects];
        for (EssenceListViewController* vc in self.myControllers) {
            [vc reloadData];
        }
    }
}


- (void)selectCollection:(NSString *)essenceId isSelected:(BOOL)isSelected
{
    if (isSelected&& ![_removeArray containsObject:essenceId]) {
        [_removeArray addObject:essenceId];
    } else if (!isSelected && [_removeArray containsObject:essenceId])
    {
        [_removeArray removeObject:essenceId];
    }
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
