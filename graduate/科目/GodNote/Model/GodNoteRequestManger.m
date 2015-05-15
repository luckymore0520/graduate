//
//  GodNoteRequestManger.m
//  graduate
//
//  Created by yixiaoluo on 15/4/26.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "GodNoteRequestManger.h"
#import "SubjectModel.h"
#import "NetWorkEngine.h"
#import "AdModel.h"

@implementation GodNoteRequestManger

+ (void)getAllNotesIn:(SubjectModel *)model
           completion:(dispatch_block_t)completion
              failure:(void (^)(NSString *errorString))failure
{
    [[NetWorkEngine sharedEngine] GET:@{@"type":model.subjectID} methodName:@"MNoteBookList" forPage:1 limitPage:2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //get the advertisement
        AdModel *ad = [[AdModel alloc] init];
        ad.adTitle = responseObject[@"adTitle_"];
        ad.adURL = responseObject[@"adUrl_"];
        ad.adImageURL = responseObject[@"adImage_"];
        model.adModel = ad;
        
//        //get all notes
//        NSArray *notes = responseObject[@"notes_"];
//        [notes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            [model.subjectBooks addObject:[SubjectNote fromDictionary:obj]];
//        }];
        
        if (completion) {
            completion();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error.localizedDescription);
        }
    }];
}
@end
