//
//  GodNoteRequestManger.m
//  graduate
//
//  Created by yixiaoluo on 15/4/26.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "GodNoteRequestManger.h"
#import "AFHTTPRequestOperationManager.h"

#define BASEURL @"http://s4.smartjiangsu.com:8080/gs/mobile"

@implementation GodNoteRequestManger

+ (void)getNoteWithNoteID:(NSNumber *)nid
               completion:(void(^)(NSArray *models))completion
                  failure:(void(^)(NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *url = [BASEURL stringByAppendingFormat:@"?id=%@", nid];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation.request.URL.absoluteString);
        
        if (completion) {
            completion(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (failure) {
            failure(error.localizedDescription);
        }
    }];
}

@end
