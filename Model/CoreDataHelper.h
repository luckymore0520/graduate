//
//  CoreDataHelper.h
//  graduate
//
//  Created by luck-mac on 15/1/26.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataHelper : NSObject
@property(strong,nonatomic,readonly)NSManagedObjectModel* managedObjectModel;
@property(strong,nonatomic,readonly)NSManagedObjectContext* managedObjectContext;
@property(strong,nonatomic,readonly)NSPersistentStoreCoordinator* persistentStoreCoordinator;
+(CoreDataHelper *)getInstance;

@end
@protocol DataHandleDelegate <NSObject>
- (BOOL) addIntoDataSource:(id)sender;
- (NSArray*) query:(id)sender;
- (BOOL) update:(id)sender;
- (BOOL) del:(id)sender;
@end
