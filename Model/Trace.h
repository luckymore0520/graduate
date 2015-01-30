//
//  Trace.h
//  graduate
//
//  Created by luck-mac on 15/1/30.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Trace : NSManagedObject

@property (nonatomic, retain) NSString * myday;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * pictureUrl;
@property (nonatomic, retain) NSNumber * remainday;
@property (nonatomic, retain) NSString * singer;
@property (nonatomic, retain) NSString * songName;
@property (nonatomic, retain) NSString * songUrl;
@property (nonatomic, retain) NSString * content;

@end