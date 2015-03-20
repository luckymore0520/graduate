//
//  EssenceRootViewController.m
//  graduate
//
//  Created by luck-mac on 15/2/18.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "EssenceRootViewController.h"
#import "QCSlideSwitchView.h"
#import "EssenceListViewController.h"
#import "MKeys.h"
#import "MRecommendKeys.h"
#import "WKUITextField.h"
#define SEARCH 1
#define BROWNSE 2
@interface EssenceRootViewController ()<QCSlideSwitchViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet QCSlideSwitchView *slideSwitchView;
@property (nonatomic,strong)NSArray* typeArray;
@property (weak, nonatomic) IBOutlet UITableView *searchTable;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic,strong)NSMutableArray* searchArray;
@property (nonatomic,assign) int state;
@end

@implementation EssenceRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title = @"精华";
    
    self.slideSwitchView.tabItemNormalColor = [QCSlideSwitchView colorFromHexRGB:@"868686"];
    self.slideSwitchView.tabItemSelectedColor = [QCSlideSwitchView colorFromHexRGB:@"bb0b15"];
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow.png"]
                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    self.slideSwitchView.buttonNormalImages = @[@"英语",@"政治",@"数学",@"专业",@"真题"];
//    self.slideSwitchView.buttonSelectedImages = @[@"最新触发",@"资讯触发",@"资料触发",@"真题触发"];
    self.slideSwitchView.slideSwitchViewDelegate = self;
    self.slideSwitchView.shadowColor = [UIColor colorWithHex:0x429dd7];
    self.typeArray = @[@1,@2,@3,@4,@5];
    [self.slideSwitchView buildUI];
    [self addRightButton:nil action:@selector(search) img:@"搜索图标"];
    self.searchTextField.layer.borderColor = [UIColor colorOfBorder].CGColor;
    self.searchTextField.delegate = self;
    self.searchTextField.layer.borderWidth = 1;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:nil];
    _state = BROWNSE;
    [self setExtraCellLineHidden:self.searchTable];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (_state == SEARCH) {
        [self.navigationController setNavigationBarHidden:YES];
    } else {
        [self.navigationController setNavigationBarHidden:NO];
    }
}

- (void)textChange:(id)notif
{
    if (_state==SEARCH) {
        [_searchTable setHidden:NO];
        if (self.searchTextField.text.length>0) {
            [[[MRecommendKeys alloc]init]load:self key:self.searchTextField.text];
        } else {
        }

    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.text.length>0) {
        [self searchResult:nil];
    }
    return YES;
}

- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MRecommendKeys"])
    {
        
        MKeys* keys = [MKeys objectWithKeyValues:data];
        if (keys.key_.count>0) {
            self.searchArray = keys.key_;
            [self.searchTable reloadData];
        }
        
    }
}

- (IBAction)cancelSearch:(id)sender {
    _state = BROWNSE;
    ((EssenceListViewController*)[_slideSwitchView currentVC]).key = nil;
    [((EssenceListViewController*)[_slideSwitchView currentVC]) reloadData];
    [self.searchTextField resignFirstResponder];
    [self.searchTable setHidden:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.searchView.transform  = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        [self.navigationController setNavigationBarHidden:NO];
    }];
}
- (IBAction)searchResult:(id)sender {
    [_searchTextField resignFirstResponder];
    [_searchTable setHidden:YES];
    EssenceListViewController* current = (EssenceListViewController*)[_slideSwitchView currentVC];
    current.key = self.searchTextField.text;
    [current reloadData];
}



- (void)search
{
    _state = SEARCH;
    [self.searchTable setHidden:NO];
    [self.navigationController setNavigationBarHidden:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.searchView.transform  = CGAffineTransformMakeTranslation(0, 64);
//        [self.view setNeedsLayout];
    } completion:^(BOOL finished) {
        [self.view bringSubviewToFront:self.searchView];
        [self.searchTextField becomeFirstResponder];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    
}


#pragma mark - QCSlideViewDelegate

- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    return 5;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    EssenceListViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"essenceList"];
    vc.type = [[_typeArray objectAtIndex:number] integerValue];
    vc.parentVC = self;
    return vc;
}



- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    
}


#pragma mark -UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* searchCell = [tableView dequeueReusableCellWithIdentifier:@"tips"];
    [searchCell.textLabel setText:[self.searchArray objectAtIndex:indexPath.row]];
    return searchCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchArray.count == 0 ) {
        self.searchTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.searchTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return self.searchArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* key = [self.searchArray objectAtIndex:indexPath.row];
    self.searchTextField.text = key;
}

- (void)addMaskAtNavigation
{
    if (!self.navigationMaskView) {
        CGRect frame = [[UIScreen mainScreen]bounds];
        frame.size.height = 108;
        self.navigationMaskView = [[UIView alloc]initWithFrame:frame];
        [self.navigationMaskView setAlpha:0.5];
        [self.navigationMaskView setBackgroundColor:[UIColor blackColor]];
        [self.navigationController.view addSubview:self.navigationMaskView];
    }
    [self.navigationMaskView setHidden:NO];
}


- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
@end
