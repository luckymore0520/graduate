//
//  MainFunVC.m
//  graduate
//
//  Created by luck-mac on 15/1/23.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MainFunVC.h"
#import "ArticleDetailVC.h"
#import "CoreDataHelper.h"
#import "Trace.h"



#import "MIndex.h"
#import "MMain.h"
#import "MIndexPost.h"
#import "MPost.h"
#import "MMainList.h"
@interface MainFunVC ()


@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic,strong)MMain* main;
@property (nonatomic,strong)MPost* recommandPost;
//鸡汤
@property (weak, nonatomic) IBOutlet UILabel *sentenceLabel;
//推荐
@property (weak, nonatomic) IBOutlet UIButton *recommandBt;
//My day
@property (weak, nonatomic) IBOutlet UILabel *myDayLabel;
//还剩多少天
@property (weak, nonatomic) IBOutlet UILabel *remainDayLabel;


@property (weak, nonatomic) IBOutlet UILabel *SongAndSingerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
@property (nonatomic,strong)NSMutableArray* mainList;
//播放按钮在父类中控制
@end

@implementation MainFunVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

-  (void)viewWillAppear:(BOOL)animated
{
    if ([ToolUtils getFirstUse]&&_main==nil) {
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
        
        NSString* myDay = [NSString stringWithFormat:@"%d",[ToolUtils getCurrentDay].integerValue];
        NSArray* array = [CoreDataHelper query:[NSPredicate predicateWithFormat:@"myDay=%@ and user=%@",myDay,[ToolUtils getUserid]] tableName:@"Trace"];
        if (array.count==0) {
            [_imgView setImage:[UIImage imageNamed:@"首页1.png"]];
        } else {
            Trace* trace = [array firstObject];
            _main = [[MMain alloc]init];
            _main.content_ = trace.content;
            _main.days_ = [NSNumber numberWithInteger:trace.myDay.integerValue];
            _main.daysLeft_ = trace.remainday;
            MMusic* music = [[MMusic alloc]init];
            music.title_ = trace.songName;
            music.singer_ = trace.singer;
            music.file_ = trace.songUrl;
            _main.music_ = [[NSMutableArray alloc]initWithObjects:music, nil];
            [self initView];
            [self setMusic:trace];
            [_imgView sd_setImageWithURL:[ToolUtils getImageUrlWtihString:trace.pictureUrl] placeholderImage:[UIImage imageNamed:@"首页1.png"]];
        }
        [[[MIndex alloc]init]load:self date:nil type:1 days:0];
        MIndexPost* post = [[MIndexPost alloc]init];
        [post load:self date:nil];
    }

}

//判断改天音乐是否有下载
- (void) setMusic:(Trace*)traceOfToday
{
    
    if (traceOfToday.songUrl&&[ToolUtils getCurrentDay].intValue==traceOfToday.myDay.intValue) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        [_SongAndSingerLabel setText:[NSString stringWithFormat:@"%@-%@",traceOfToday.songName,traceOfToday.singer]];
        
        [self loadMusic:[documentsDirectoryURL URLByAppendingPathComponent:traceOfToday.songUrl]];
        
    } else if (!traceOfToday.songUrl){
        if ([ToolUtils getCurrentDay].intValue==traceOfToday.myDay.intValue) {
            NSString *thePath=[[NSBundle mainBundle] pathForResource:@"泡沫" ofType:@"mp3"];
            [_SongAndSingerLabel setText:[NSString stringWithFormat:@"泡沫-邓紫棋"]];
            [self loadMusic:[NSURL fileURLWithPath:thePath]];
        }
        MMusic* music = [_main.music_ firstObject];
        ApiHelper* api = [[ApiHelper alloc]init];
        api.fileId = music.title_;
        [api download:self url:[ToolUtils getImageUrlWtihString:music.file_].absoluteString];
    }
}
//该方法用于根据接口获取的数据更新界面
- (void)initView
{
    [_sentenceLabel setText:_main.content_];
    [_myDayLabel setText: [NSString stringWithFormat:@"我的%d天",_main.days_.integerValue]];
    [_remainDayLabel setText:[NSString stringWithFormat:@"还剩%d天",_main.daysLeft_.integerValue]];
    [self.imgView sd_setImageWithURL:[ToolUtils getImageUrlWtihString:_main.img_] placeholderImage:[UIImage imageNamed:@"首页1.png"]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            NSString* myDay = [NSString stringWithFormat:@"%d",main.days_.integerValue];
            NSArray* array = [CoreDataHelper query:[NSPredicate predicateWithFormat:@"myDay=%@ and user=%@",myDay,[ToolUtils getUserid]] tableName:@"Trace"];
            [_backImgView sd_setImageWithURL:[ToolUtils getImageUrlWtihString:main.img_ width:self.view.frame.size.width height:0] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"下图完成 首页图");
            }];
            [_backImgView sd_setImageWithURL:[ToolUtils getImageUrlWtihString:main.imgGn_ width:self.view.frame.size.width height:0] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"下图完成 功能图");
            }];
            [_backImgView sd_setImageWithURL:[ToolUtils getImageUrlWtihString:main.imgZj_ width:self.view.frame.size.width height:0] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"下图完成 足迹图");
            }];
            //若CoreData里有该条数据，检验是否下载音乐，未下载播放默认音乐并下载
            if (array.count!=0) {
                Trace* traceOfToday = [array firstObject];
                [self setMusic:traceOfToday];
            } else {
                [self saveDay:main musicUrl:nil];
            }

        }
    } else if ([names isEqualToString:@"download"])
    {

        NSURL* url = [data objectForKey:@"path"];
        if (url) {
            [self saveMusic:[data objectForKey:@"fileid"] musicUrl:[data objectForKey:@"filename"]];
        }
    } else if ([names isEqualToString:@"MIndexPost"])
    {
        _recommandPost = [MPost objectWithKeyValues:data];
        [_recommandBt setTitle:_recommandPost.title_ forState:UIControlStateNormal];
    }
}


- (void)saveMusic:(NSString*)musicTitle musicUrl:(NSString*)musicUrl
{
    NSError* error;
    CoreDataHelper* helper = [CoreDataHelper getInstance];
    NSArray* array = [CoreDataHelper query:[NSPredicate predicateWithFormat:@"songName=%@",musicTitle] tableName:@"Trace"];
    for (Trace* trace in array) {
        trace.songUrl = musicUrl;
        BOOL isSaveSuccess=[helper.managedObjectContext save:&error];
        if (!isSaveSuccess) {
            NSLog(@"Error:%@",error);
        }else{
            NSLog(@"Save successful! Music:%@",musicTitle);
        }
    }
}

- (void)saveDay:(MMain*)myDay musicUrl:(NSString*)url
{
    NSError* error;
    CoreDataHelper* helper = [CoreDataHelper getInstance];
    if (myDay==_main) {
        NSString *defaultPath=[[NSBundle mainBundle] pathForResource:@"泡沫" ofType:@"mp3"];
        [_SongAndSingerLabel setText:[NSString stringWithFormat:@"泡沫-邓紫棋"]];
        [self loadMusic:[NSURL fileURLWithPath:defaultPath]];
    }
    MMusic* music = [myDay.music_ firstObject];
    Trace* trace=(Trace *)[NSEntityDescription insertNewObjectForEntityForName:@"Trace" inManagedObjectContext:helper.managedObjectContext];
    trace.songName = music.title_;
    trace.pictureUrl =myDay.img_;
    trace.content = myDay.content_;
    trace.myDay = [NSString
                        stringWithFormat:@"%d",myDay.days_.integerValue];
    trace.remainday = myDay.daysLeft_;
    trace.pictureUrlForSubject = myDay.imgGn_;
    trace.pictureUrlForTrace = myDay.imgZj_;
    trace.user  = [ToolUtils getUserid];
    trace.singer = music.singer_;
    BOOL isSaveSuccess=[helper.managedObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error:%@",error);
    }else{
        NSLog(@"Save successful!");
        ApiHelper* api = [[ApiHelper alloc]init];
        api.fileId = music.title_;
//        if (_isDownloading) {
//            return;
//        }
        [api download:self url:[ToolUtils getImageUrlWtihString:music.file_].absoluteString];
//        _isDownloading = YES;
    }
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
