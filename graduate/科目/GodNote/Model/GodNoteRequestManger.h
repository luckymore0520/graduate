//
//  GodNoteRequestManger.h
//  graduate
//
//  Created by yixiaoluo on 15/4/26.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GodNoteRequestManger : NSObject

+ (void)getNoteWithNoteID:(NSNumber *)nid
               completion:(void(^)(NSArray *models))completion
                  failure:(void(^)(NSString *errorString))failure;

@end
