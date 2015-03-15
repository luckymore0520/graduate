//
//  MainFunVC.m
//  graduate
//
//  Created by luck-mac on 15/1/23.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MainFunVC.h"
#import "EssenceDetailViewController.h"
#import "EssenceDetailWebViewController.h"
#import "CoreDataHelper.h"
#import "Trace.h"
#import "WKUILabel.h"


#import "MIndex.h"
#import "MMain.h"
#import "MMainList.h"
#import "MyTraceList.h"

@interface MainFunVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic,strong)MMain* main;
//鸡汤
@property (weak, nonatomic) IBOutlet WKUILabel *sentenceLabel;
//My day
@property (weak, nonatomic) IBOutlet UILabel *remainDayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
@property (nonatomic,strong)NSMutableArray* mainList;
@property (weak, nonatomic) IBOutlet UIView *middleTextView;
@end

@implementation MainFunVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    if (_main==nil) {
        //判断是否过了一天
        NSString* lastDate = [ToolUtils getCurrentDate];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *destDateString = [dateFormatter stringFromDate:[NSDate date]];
        if (![lastDate isEqualToString:destDateString]) {
            NSDate *now= [dateFormatter dateFromString:destDateString];
            NSDate *last = [dateFormatter dateFromString:lastDate];
            double timeDiff = [now timeIntervalSinceDate:last ];
            NSInteger currentDay = [ToolUtils getCurrentDay].integerValue;
            currentDay = currentDay + timeDiff/86400;
            [ToolUtils setCurrentDay:[NSNumber numberWithInteger:currentDay]];
        }
        NSString* myDay = [NSString stringWithFormat:@"%ld",[ToolUtils getCurrentDay].integerValue];
        NSArray* array = [CoreDataHelper query:[NSPredicate predicateWithFormat:@"myDay=%@ and user=%@",myDay,[ToolUtils getUserid]] tableName:@"Trace"];
        if (array.count==0) {
            [_imgView setImage:[UIImage imageNamed:@"首页1.png"]];
        } else {
            Trace* trace = [array firstObject];
            _main = [[MMain alloc]init];
            _main.content_ = trace.content;
            _main.days_ = [NSNumber numberWithInteger:trace.myDay.integerValue];
            _main.daysLeft_ = trace.remainday;
            _main.img_ = trace.pictureUrl;
            MMusic* music = [[MMusic alloc]init];
            music.title_ = trace.songName;
            music.singer_ = trace.singer;
            music.file_ = trace.songUrl;
            _main.music_ = [[NSMutableArray alloc]initWithObjects:music, nil];
            [self initView];
            [_imgView sd_setImageWithURL:[ToolUtils getImageUrlWtihString:trace.pictureUrl] placeholderImage:[UIImage imageNamed:@"首页1.png"]];
        }
        [[[MIndex alloc]init]load:self date:nil type:1 days:0];
    }
}

//该方法用于根据接口获取的数据更新界面
- (void)initView
{
    [_sentenceLabel setText:_main.content_];
    CGSize size = _sentenceLabel.frame.size;
    size.height = size.height+10;
    _sentenceLabel.frame = CGRectMake(_sentenceLabel.frame.origin.x, _sentenceLabel.frame.origin.y, size.width, size.height);
    if (_main.daysLeft_.integerValue<10) {
        
        [_remainDayLabel setText:[NSString stringWithFormat:@"0%ld",_main.daysLeft_.integerValue]];
    } else {
        [_remainDayLabel setText:[NSString stringWithFormat:@"%ld",_main.daysLeft_.integerValue]];
    }
    [self.imgView sd_setImageWithURL:[ToolUtils getImageUrlWtihString:_main.img_] placeholderImage:[UIImage imageNamed:@"首页1.png"]];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -Apidelegate
- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MIndex"]) {
        MMainList* mainList = [MMainList objectWithKeyValues:data];
        _main = [mainList.index_ firstObject];
        [self initView];
        [ToolUtils setCurrentDay:_main.days_];
        _mainList = mainList.index_;
        for (MMain* main in mainList.index_) {
            NSString* myDay = [NSString stringWithFormat:@"%ld",main.days_.integerValue];
            NSArray* array = [CoreDataHelper query:[NSPredicate predicateWithFormat:@"myDay=%@ and user=%@",myDay,[ToolUtils getUserid]] tableName:@"Trace"];
            [_backImgView sd_setImageWithURL:[ToolUtils getImageUrlWtihString:main.img_ width:self.view.frame.size.width height:0] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"下图完成 首页图");
            }];
            UIImageView* traceImageView = [[UIImageView alloc]initWithFrame:_backImgView.frame];
            [traceImageView setHidden:YES];
            [self.view addSubview:traceImageView];
            [traceImageView sd_setImageWithURL:[ToolUtils getImageUrlWtihString:main.imgZj_ width:self.view.frame.size.width height:0] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"下图完成 足迹图");
                [traceImageView removeFromSuperview];
            }];
            UIImageView* funcImageView = [[UIImageView alloc]initWithFrame:_backImgView.frame];
            [funcImageView setHidden:YES];
            [self.view addSubview:funcImageView];
            [funcImageView sd_setImageWithURL:[ToolUtils getImageUrlWtihString:main.imgGn_ width:self.view.frame.size.width height:0] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"下图完成 功能图");
                [funcImageView removeFromSuperview];
            }];
            //若CoreData里有该条数据，检验是否下载音乐，未下载播放默认音乐并下载
            if (array.count!=0) {
                CoreDataHelper* helper = [CoreDataHelper getInstance];
                Trace* traceOfToday = [array firstObject];
                MMusic* music = [main.music_ firstObject];
                traceOfToday.songName = music.title_;
                traceOfToday.pictureUrl =main.img_;
                traceOfToday.myDay = [NSString
                                      stringWithFormat:@"%ld",main.days_.integerValue];
                traceOfToday.remainday = main.daysLeft_;
                traceOfToday.pictureUrlForSubject = main.imgGn_;
                traceOfToday.pictureUrlForTrace = main.imgZj_;
                traceOfToday.user  = [ToolUtils getUserid];
                traceOfToday.singer = music.singer_;
                traceOfToday.date = main.date_;
                traceOfToday.musicFile = music.file_;
                NSError* error;
                BOOL isSaveSuccess=[helper.managedObjectContext save:&error];
                if (!isSaveSuccess) {
                    NSLog(@"Error:%@",error);
                }else{
                    NSLog(@"Save successful!");
                }
            } else {
                [self saveDay:main musicUrl:nil];
            }

        }
        [[MyTraceList getInstance]updateTraces];
    }
}


- (void)saveDay:(MMain*)myDay musicUrl:(NSString*)url
{
    NSError* error;
    CoreDataHelper* helper = [CoreDataHelper getInstance];
    MMusic* music = [myDay.music_ firstObject];
    Trace* trace=(Trace *)[NSEntityDescription insertNewObjectForEntityForName:@"Trace" inManagedObjectContext:helper.managedObjectContext];
    trace.songName = music.title_;
    trace.pictureUrl =myDay.img_;
    trace.content = myDay.content_;
    trace.myDay = [NSString
                        stringWithFormat:@"%ld",myDay.days_.integerValue];
    trace.remainday = myDay.daysLeft_;
    trace.pictureUrlForSubject = myDay.imgGn_;
    trace.pictureUrlForTrace = myDay.imgZj_;
    trace.user  = [ToolUtils getUserid];
    trace.singer = music.singer_;
    trace.date = myDay.date_;
    trace.musicFile = music.file_;
    BOOL isSaveSuccess=[helper.managedObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error:%@",error);
    }else{
        NSLog(@"Save successful!");
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark -cycleViewDelegate

@end
