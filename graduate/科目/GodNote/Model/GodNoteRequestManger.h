//
//  GodNoteRequestManger.h
//  graduate
//
//  Created by yixiaoluo on 15/4/26.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdModel.h"

@interface GodNoteRequestManger : NSObject

+ (void)getAllSubjectCompletion:(void(^)(NSArray *subjectModels, AdModel *adModel))completion
                  failure:(void(^)(NSString *errorString))failure;

@end
