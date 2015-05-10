//
//  GodNoteRequestManger.h
//  graduate
//
//  Created by yixiaoluo on 15/4/26.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdModel.h"
#import "ApiHelper.h"

typedef void(^GetAllSubjectCompletion)(NSArray *subjectModels, AdModel *adModel);
typedef void(^Failure)(NSString *errorString);
typedef dispatch_block_t Success;

@class SubjectModel;
@interface GodNoteRequestManger : NSObject
<
ApiDelegate
>
+ (instancetype)sharedManager;

//requests
- (void)getAllNotesIn:(SubjectModel *)model completion:(Success)completion failure:(Failure)failure;

@end

@interface GodNoteRequest : ApiHelper

- (ApiHelper *)getAllSubject:(id<ApiDelegate>)delegate withType:(NSNumber *)type;

@end
