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
#import "MyTraceList.h"
#import "CircularProgressView.h"

@interface MainFunVC ()<CircularProgressDelegate>
@property (weak, nonatomic) IBOutlet UIView *shareView;


@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic,strong)MMain* main;

@property (weak, nonatomic) IBOutlet UIView *bottomVIew;
@property (nonatomic,strong)MPost* recommandPost;
//鸡汤
@property (weak, nonatomic) IBOutlet UILabel *sentenceLabel;
//推荐
@property (weak, nonatomic) IBOutlet UIButton *recommandBt;
//My day
@property (weak, nonatomic) IBOutlet UILabel *myDayLabel;
//还剩多少天
@property (weak, nonatomic) IBOutlet UILabel *remainDayLabel;

@property (weak, nonatomic) IBOutlet UILabel *singerLabel;

@property (weak, nonatomic) IBOutlet UILabel *SongAndSingerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
@property (nonatomic,strong)NSMutableArray* mainList;
@property (weak, nonatomic) IBOutlet UIView *middleTextView;
@property (nonatomic,strong)CircularProgressView* progressView;
//播放按钮在父类中控制
@end

@implementation MainFunVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCircle];
    [self adjustView];

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
            _main.img_ = trace.pictureUrl;
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

- (void)adjustView
{
    if ([[UIScreen mainScreen]bounds].size.width<350) {
        self.view.transform = CGAffineTransformMakeScale(0.854, 0.854);
    } else {
        if (_main&&_main.days_.integerValue-_main.days_.integerValue/10*10==1) {
            self.sentenceLabel.transform = CGAffineTransformMakeTranslation(-10, 0);
            self.myDayLabel.transform = CGAffineTransformMakeTranslation(-10, 0);
        }
    }
    [self.shareView setHidden:YES];
}

- (void)addCircle
{
    UIColor *backColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
    UIColor *progressColor = [UIColor colorWithRed:2/255.0 green:150/255.0 blue:244/255.0 alpha:1];
    
    //alloc CircularProgressView instance
    self.progressView = [[CircularProgressView alloc] initWithFrame:CGRectMake(16, 13, 47.5, 47.5) backColor:backColor progressColor:progressColor lineWidth:2 audioPath:nil];
    //set CircularProgressView delegate
    self.progressView.delegate = self;
    //add CircularProgressView
    [self.bottomVIew addSubview:self.progressView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.shareView setHidden:YES];
}

//判断改天音乐是否有下载
- (void) setMusic:(Trace*)traceOfToday
{
    
    if (traceOfToday.songUrl&&[ToolUtils getCurrentDay].intValue==traceOfToday.myDay.intValue) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        [_SongAndSingerLabel setText:[NSString stringWithFormat:@"%@",traceOfToday.songName]];
        [_singerLabel setText:traceOfToday.singer];
        [self loadMusic:[documentsDirectoryURL URLByAppendingPathComponent:traceOfToday.songUrl]];
        
    } else if (!traceOfToday.songUrl){
        if ([ToolUtils getCurrentDay].intValue==traceOfToday.myDay.intValue) {
            NSString *thePath=[[NSBundle mainBundle] pathForResource:@"泡沫" ofType:@"mp3"];
            [_SongAndSingerLabel setText:[NSString stringWithFormat:@"泡沫"]];
            [_singerLabel setText:[NSString stringWithFormat:@"邓紫棋"]];
            [self loadMusic:[NSURL fileURLWithPath:thePath]];
        }
        MMusic* music = [_main.music_ firstObject];
        ApiHelper* api = [[ApiHelper alloc]init];
        api.fileId = music.title_;
        if ([ToolUtils getCurrentDay].intValue==traceOfToday.myDay.intValue) {
            [api download:self url:[ToolUtils getImageUrlWtihString:music.file_].absoluteString];
        } else if ([ToolUtils connectedToNetWork]) {
            [api download:self url:[ToolUtils getImageUrlWtihString:music.file_].absoluteString];
        }
        
    }
}
//该方法用于根据接口获取的数据更新界面
- (void)initView
{
    [_sentenceLabel setText:_main.content_];
    
    
    [_myDayLabel setText: [NSString stringWithFormat:@"MY %d DAYS LEFT",_main.daysLeft_.integerValue]];
    if (_main.days_.integerValue<10) {
        [_remainDayLabel setText:[NSString stringWithFormat:@"0%d",_main.days_.integerValue]];

    } else {
        [_remainDayLabel setText:[NSString stringWithFormat:@"%d",_main.days_.integerValue]];

    }
    [self.imgView sd_setImageWithURL:[ToolUtils getImageUrlWtihString:_main.img_] placeholderImage:[UIImage imageNamed:@"首页1.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"下载完啦 ！！！！！！");
//        [self.imgView setImage:image];
    }];
    
    [self.imgView sd_setImageWithURL:[ToolUtils getImageUrlWtihString:_main.img_] placeholderImage:[UIImage imageNamed:@"首页1.png"]];
    [self adjustView];
    
}

- (void)loadMusic:(NSURL *)path
{
    [super loadMusic:path progressView:self.progressView];
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
        if (!_main) {
            _main = [mainList.index_ firstObject];
        }
        [self initView];
        [ToolUtils setCurrentDay:_main.days_];
        _mainList = mainList.index_;
        for (MMain* main in mainList.index_) {
            
            
            
            NSString* myDay = [NSString stringWithFormat:@"%d",main.days_.integerValue];
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
                                      stringWithFormat:@"%d",main.days_.integerValue];
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
                [self setMusic:traceOfToday];
            } else {
                [self saveDay:main musicUrl:nil];
            }

        }
        [[MyTraceList getInstance]updateTraces];

    } else if ([names isEqualToString:@"download"])
    {

        NSURL* url = [data objectForKey:@"path"];
        if (url) {
            [self saveMusic:[data objectForKey:@"fileid"] musicUrl:[data objectForKey:@"filename"]];
        }
    } else if ([names isEqualToString:@"MIndexPost"])
    {
        _recommandPost = [MPost objectWithKeyValues:data];
//        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:_recommandPost.title_];
//        NSRange contentRange = {0,[content length]};
//        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
//        [self.recommandBt.titleLabel setAttributedText:content];
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
        [_SongAndSingerLabel setText:[NSString stringWithFormat:@"泡沫"]];
        [_singerLabel setText:@"邓紫棋"];
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
    trace.date = myDay.date_;
    trace.musicFile = music.file_;
    BOOL isSaveSuccess=[helper.managedObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error:%@",error);
    }else{
        NSLog(@"Save successful!");
        
        ApiHelper* api = [[ApiHelper alloc]init];
        api.fileId = music.title_;
        if ([ToolUtils getCurrentDay].intValue==myDay.days_.intValue) {
            [api download:self url:[ToolUtils getImageUrlWtihString:music.file_].absoluteString];
        } else if ([ToolUtils connectedToNetWork]) {
            [api download:self url:[ToolUtils getImageUrlWtihString:music.file_].absoluteString];
        }
    }
}



#pragma mark -ButtonAction
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
- (IBAction)share:(id)sender {
    [self.shareView setHidden:NO];
    CGFloat height = self.shareView.frame.size.height;
    CGRect frame = self.shareView.frame;
    frame.origin.y = frame.origin.y -height;
    [UIView animateWithDuration:0.3 animations:^{
        self.shareView.frame = frame;
    }];
}


- (IBAction)closeShare:(id)sender {
    [self.shareView setHidden:YES];
    CGFloat height = self.shareView.frame.size.height;
    CGRect frame = self.shareView.frame;
    frame.origin.y = frame.origin.y +height;
    [UIView animateWithDuration:0.3 animations:^{
        self.shareView.frame = frame;
    } completion:^(BOOL finished) {
    }] ;
    
}



- (IBAction)saveToAlubm:(id)sender {
    CGFloat height = self.shareView.frame.size.height;
    CGRect frame = self.shareView.frame;
    frame.origin.y = frame.origin.y +height;
    [UIView animateWithDuration:0.3 animations:^{
        self.shareView.frame = frame;
    } completion:^(BOOL finished) {
        [self screenShots];
    }] ;
}

-(void)screenShots
{
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions) {
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    }
    else
    {
        UIGraphicsBeginImageContext(imageSize);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow * window in [[UIApplication sharedApplication] windows]) {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            CGContextTranslateCTM(context, -[window bounds].size.width*[[window layer] anchorPoint].x, -[window bounds].size.height*[[window layer] anchorPoint].y);
            [[window layer] renderInContext:context];
            
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    NSLog(@"Suceeded!");
    [ToolUtils showToast:@"图片已保存至相册" toView:self.view];

}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark -cycleViewDelegate

@end
