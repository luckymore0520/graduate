//
//  TraceRootVC.m
//  graduate
//
//  Created by luck-mac on 15/1/26.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "TraceRootVC.h"
#import "MyTraceVC.h"
#import "MyTraceList.h"
#import "QCSlideSwitchView.h"
#import "CoreDataHelper.h"
@interface TraceRootVC ()<QCSlideSwitchViewDelegate,TraceDelegate>
@property (weak, nonatomic) IBOutlet QCSlideSwitchView *slideSwitchView;
@property (nonatomic,strong)NSMutableArray* traceVCs;
@property (nonatomic,strong)NSMutableArray* traceList;
@property (nonatomic,strong)NSMutableArray* questionList;
@end

@implementation TraceRootVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    

    
    
    self.title = @"我的研路";
    self.slideSwitchView.tabItemNormalColor = [QCSlideSwitchView colorFromHexRGB:@"333333"];
    self.slideSwitchView.tabItemSelectedColor = [QCSlideSwitchView colorFromHexRGB:@"1f76dc"];
    self.slideSwitchView.slideSwitchViewDelegate = self;
    
    
    _traceVCs = [[NSMutableArray alloc]init];
    _traceList = [[MyTraceList getInstance] getMyTracesIncludeToday:NO];
    for (Trace* trace in self.traceList) {
        MyTraceVC* traceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"trace_wide"];
        traceVC.shoudUpdate = self.shoudUpdate;
        traceVC.trace = trace;
        traceVC.myDelegate = self;
        [_traceVCs addObject:traceVC];
        traceVC.title = [NSString stringWithFormat:@"My %ld Day",(long)trace.myDay.integerValue];
    }
    if (self.traceVCs.count>0) {
        MyTraceVC* traceVC = [self.traceVCs lastObject];
        traceVC.title = @"Yesterday";
    } else {
        UIViewController* first = [self.storyboard instantiateViewControllerWithIdentifier:@"traceFirst"];
        [first setTitle:@"Yesterday"];
        [self.traceVCs addObject:first];
    }
    [self.slideSwitchView buildUI];
    
    [self.slideSwitchView selectVCAtIndex:self.traceVCs.count-1];
}



- (void)initViews
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_slideSwitchView.currentVC) {
        if ([_slideSwitchView.currentVC respondsToSelector:@selector(loadQuestion)]) {
            [((MyTraceVC*)_slideSwitchView.currentVC) loadQuestion];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -QCSlideViewDelegate

- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    return _traceVCs.count;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{

    return [_traceVCs objectAtIndex:number];
}


- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    if (self.traceVCs.count>1) {
        MyTraceVC* myTrace =  (MyTraceVC*)[_traceVCs objectAtIndex:number];
        myTrace.isInView = YES;
    }
}


#pragma mark -TraceDelegate
- (void)pushDetailVC:(UIViewController *)detail
{
    [self.navigationController pushViewController:detail animated:YES];
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
