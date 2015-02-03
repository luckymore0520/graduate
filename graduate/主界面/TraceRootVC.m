//
//  TraceRootVC.m
//  graduate
//
//  Created by luck-mac on 15/1/26.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "TraceRootVC.h"
#import "MyTraceVC.h"
#import "QCSlideSwitchView.h"
#import "CoreDataHelper.h"
@interface TraceRootVC ()<QCSlideSwitchViewDelegate>
@property (weak, nonatomic) IBOutlet QCSlideSwitchView *slideSwitchView;
@property (nonatomic,strong)NSMutableArray* traceVCs;
@property (nonatomic,strong)NSMutableArray* traceList;
@property (nonatomic,strong)NSMutableArray* questionList;
@end

@implementation TraceRootVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    

    
    
    self.title = @"滑动切换视图";
    self.slideSwitchView.tabItemNormalColor = [QCSlideSwitchView colorFromHexRGB:@"868686"];
    self.slideSwitchView.tabItemSelectedColor = [QCSlideSwitchView colorFromHexRGB:@"bb0b15"];
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow.png"]
                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    self.slideSwitchView.slideSwitchViewDelegate = self;
    
    
    _traceVCs = [[NSMutableArray alloc]init];
    
    _traceList = [NSMutableArray arrayWithArray: [CoreDataHelper query:[NSPredicate predicateWithFormat:@"user=%@",[ToolUtils getUserid]] tableName:@"Trace"]];

    
    
//    NSMutableArray* futureDays = [[NSMutableArray alloc]init];
//    
//    for (Trace* trace in _traceList) {
//        if (trace.myDay.integerValue>[ToolUtils getCurrentDay].integerValue) {
//            [futureDays addObject:trace];
//        }
//    }
//    [_traceList removeObjectsInArray:futureDays];
    
    
    [self.traceList sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString* a = ((Trace*)obj1).myDay;
        NSString* b = ((Trace*)obj2).myDay;
        return  b.integerValue<a.integerValue;
    }];
    
    for (Trace* trace in self.traceList) {
        MyTraceVC* traceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"trace_wide"];
        traceVC.shoudUpdate = self.shoudUpdate;
        traceVC.trace = trace;
        [_traceVCs addObject:traceVC];
        traceVC.title = [NSString stringWithFormat:@"第%i天",trace.myDay.integerValue];
    }
    
    
    
    [self.slideSwitchView buildUI];
}



- (void)viewWillAppear:(BOOL)animated
{
   
//    [self reloadViewControllers];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -QCSlideViewDelegate

- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    // you can set the best you can do it ;
    return _traceVCs.count;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    return [_traceVCs objectAtIndex:number];
}

//- (void)slideSwitchView:(QCSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
//{
//    QCViewController *drawerController = (QCViewController *)self.navigationController.mm_drawerController;
//    [drawerController panGestureCallback:panParam];
//}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{
//    QCListViewController *vc = nil;
//    if (number == 0) {
//        vc = self.vc1;
//    } else if (number == 1) {
//        vc = self.vc2;
//    } else if (number == 2) {
//        vc = self.vc3;
//    } else if (number == 3) {
//        vc = self.vc4;
//    } else if (number == 4) {
//        vc = self.vc5;
//    } else if (number == 5) {
//        vc = self.vc6;
//    }
//    [vc viewDidCurrentView];
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
