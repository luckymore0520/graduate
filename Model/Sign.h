//
//  Sign.h
//  graduate
//
//  Created by luck-mac on 15/2/4.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Sign : NSManagedObject

@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * userid;
@property (nonatomic, retain) NSString* myDay;
@property (nonatomic,retain)NSNumber* isUpload;
@end
