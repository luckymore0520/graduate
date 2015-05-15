//
//  GodNoteRequestManger.h
//  graduate
//
//  Created by yixiaoluo on 15/4/26.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SubjectModel;
@interface GodNoteRequestManger : NSObject

//requests
+ (void)getAllNotesIn:(SubjectModel *)model
           completion:(dispatch_block_t)completion
              failure:(void (^)(NSString *errorString))failure;

@end
