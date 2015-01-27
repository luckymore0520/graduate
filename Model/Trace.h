//
//  Trace.h
//  graduate
//
//  Created by luck-mac on 15/1/27.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Trace : NSManagedObject

@property (nonatomic, retain) NSNumber * date;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * pictureUrl;
@property (nonatomic, retain) NSString * songName;
@property (nonatomic, retain) NSString * songUrl;

@end
