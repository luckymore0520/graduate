//
//  MainFunVC.m
//  graduate
//
//  Created by luck-mac on 15/1/23.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MainFunVC.h"
#import "ArticleDetailVC.h"
#import "Trace.h"
#import "Trace+TraceHandle.h"
@interface MainFunVC ()
//鸡汤
@property (weak, nonatomic) IBOutlet UILabel *sentenceLabel;
//推荐
@property (weak, nonatomic) IBOutlet UIButton *recommandBt;
//My day
@property (weak, nonatomic) IBOutlet UILabel *myDayLabel;
//还剩多少天
@property (weak, nonatomic) IBOutlet UILabel *remainDayLabel;


//播放按钮在父类中控制

@end

@implementation MainFunVC

- (void)viewDidLoad {
    [super viewDidLoad];
#warning 此处调用获取主页信息的接口，并下载音乐
//
//    CoreDataHelper* helper = [CoreDataHelper getInstance];
//    Trace* trace=(Trace *)[NSEntityDescription insertNewObjectForEntityForName:@"Trace" inManagedObjectContext:helper.managedObjectContext];
//    
//    
//    trace.songName = @"平凡之路";
//    trace.songUrl = @"平凡之路";
//    trace.pictureUrl =@"111";
//    trace.note = @"22222222";
//    trace.date = [NSNumber numberWithInt:1];
//    
//    NSError* error;
//    BOOL isSaveSuccess=[helper.managedObjectContext save:&error];
//    if (!isSaveSuccess) {
//        NSLog(@"Error:%@",error);
//    }else{
//        NSLog(@"Save successful!");
//    }
//
//    [trace query:[NSPredicate predicateWithFormat:@"date==%i",1]];
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated
{
    [self loadMusic];
}

//该方法用于根据接口获取的数据更新界面
- (void)initView
{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark ButtonAction
//前往推荐帖子详情
- (IBAction)goToDetail:(id)sender {
    UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"Articles" bundle:nil];
    UINavigationController* _rootVC = (UINavigationController*)[myStoryBoard instantiateViewControllerWithIdentifier:@"navi"];
#warning 此处需要设置详情页面的信息
    ArticleDetailVC* _detailVC = (ArticleDetailVC*)[myStoryBoard instantiateViewControllerWithIdentifier:@"detail"];
    [_rootVC pushViewController:_detailVC animated:NO];
    [self presentViewController:_rootVC animated:YES completion:^{
        
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
