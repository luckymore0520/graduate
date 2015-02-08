//
//  MyTraceList.m
//  graduate
//
//  Created by luck-mac on 15/2/6.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MyTraceList.h"

@implementation MyTraceList

MyTraceList* tracelist = nil;

+(MyTraceList *)getInstance
{
    @synchronized(self){
        if(tracelist == nil){
            tracelist = [[self alloc] init];
        }
    }
    
    return tracelist;
}


- (NSMutableArray*)getMyTraces
{
    NSMutableArray* traceList = [NSMutableArray arrayWithArray: [CoreDataHelper query:[NSPredicate predicateWithFormat:@"user=%@",[ToolUtils getUserid]] tableName:@"Trace"]];
    NSMutableArray* futureDays = [[NSMutableArray alloc]init];
    
    for (Trace* trace in traceList) {
        if (trace.myDay.integerValue>[ToolUtils getCurrentDay].integerValue) {
            [futureDays addObject:trace];
        }
    }
    [traceList removeObjectsInArray:futureDays];
    [traceList sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString* a = ((Trace*)obj1).myDay;
        NSString* b = ((Trace*)obj2).myDay;
        return  b.integerValue<a.integerValue;
    }];
    return traceList;
}


- (void)updateTraces
{
    
    NSMutableArray* traceList = [self getMyTraces];
    Trace* trace = [traceList firstObject];
    NSInteger earlistDay = trace.myDay.integerValue;
    if (earlistDay>1) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString* traceDate = trace.date;
        NSDate *date = [dateFormatter dateFromString:trace.date];
        NSTimeInterval secondsPerDay1 = 24*60*60;
        NSDate *firstDay = [date addTimeInterval:-secondsPerDay1*(earlistDay-1)];
        NSString* firstDayStr = [dateFormatter stringFromDate:firstDay];
        [[[MFootprint alloc]init]load:self date:firstDayStr type:1 days:earlistDay-1];
    }
    
}


- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MFootprint"]) {
        MMainList* mainList = [MMainList objectWithKeyValues:data];
        for (MMain* main in mainList.index_) {
            NSString* myDay = [NSString stringWithFormat:@"%d",main.days_.integerValue];
            UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 500)];
            [imgView sd_setImageWithURL:[ToolUtils getImageUrlWtihString:main.imgZj_ width:[[UIScreen mainScreen]bounds].size.width*2 height:0] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"下图完成 足迹图 From APPDELEGATE");
            }];
            [self saveDay:main musicUrl:nil];
        }
    } else if ([names isEqualToString:@"download"])
    {
        
        NSURL* url = [data objectForKey:@"path"];
        if (url) {
            [self saveMusic:[data objectForKey:@"fileid"] musicUrl:[data objectForKey:@"filename"]];
        }
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
        }    }
}






@end
