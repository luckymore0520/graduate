//
//  Trace+TraceHandle.m
//  graduate
//
//  Created by luck-mac on 15/1/26.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "Trace+TraceHandle.h"

@implementation Trace (TraceHandle)

- (BOOL) addIntoDataSource:(id)sender
{
    CoreDataHelper* helper = [CoreDataHelper getInstance];
    Trace* trace=(Trace *)[NSEntityDescription insertNewObjectForEntityForName:@"Trace" inManagedObjectContext:helper.managedObjectContext];
//    @property (nonatomic, retain) NSDate * date;
//    @property (nonatomic, retain) NSString * songName;
//    @property (nonatomic, retain) NSString * songUrl;
//    @property (nonatomic, retain) NSString * pictureUrl;
//    @property (nonatomic, retain) NSString * note;
    
    trace.date = self.date;
    trace.songName = self.songName;
    trace.songUrl = self.songUrl;
    trace.pictureUrl = self.pictureUrl;
    trace.note = self.note;
    
    
    NSError* error;
    BOOL isSaveSuccess=[helper.managedObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error:%@",error);
    }else{
        NSLog(@"Save successful!");
    }
    return isSaveSuccess;
}

- (NSArray*) query:(id)sender
{
    CoreDataHelper* helper = [CoreDataHelper getInstance];
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* trace=[NSEntityDescription entityForName:@"Trace" inManagedObjectContext:helper.managedObjectContext];
    [request setEntity:trace];
    //    NSSortDescriptor* sortDescriptor=[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    //    NSArray* sortDescriptions=[[NSArray alloc] initWithObjects:sortDescriptor, nil];
    //    [request setSortDescriptors:sortDescriptions];
    //    [sortDescriptions release];
    //    [sortDescriptor release];
    request.predicate=sender;

    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[helper.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    NSLog(@"The count of entry: %i",[mutableFetchResult count]);
    for (Trace* trace in mutableFetchResult) {
        NSLog(@"date:%@----songName:%@------songUrl:%@",trace.date.description,trace.songName,trace.songName);
    }
    return mutableFetchResult;
}
- (BOOL) update:(id)sender
{
    return YES;
}
- (BOOL) del:(id)sender
{
    return YES;
}
@end
