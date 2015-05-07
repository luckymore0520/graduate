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

+ (void)getAllSubjectCompletion:(void(^)(NSArray *subjectModels, AdModel *adModel))completion
                        failure:(void(^)(NSString *errorString))failure;
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *url = [BASEURL stringByAppendingFormat:@"?id=%@", @1];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation.request.URL.absoluteString);
        if ([responseObject[@"errorCode"] integerValue] == 0) {
            //get the advertisement
            AdModel *ad = [[AdModel alloc] init];
            ad.adTitle = responseObject[@"adTitle_"];
            ad.adURL = responseObject[@"adUrl_"];
#warning Check the field charater yixiaoluo
            ad.adImageURL = responseObject[@"adImage_"];
            
            //get all subjects
            //here
            
            if (completion) {
                completion(responseObject, ad);
            }
        }else{
            if (failure) {
                failure(@"返回数据失败");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (failure) {
            failure(error.localizedDescription);
        }
    }];
}

@end
