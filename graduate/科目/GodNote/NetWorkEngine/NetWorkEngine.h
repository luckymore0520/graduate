//
//  NetWorkEngine.h
//  graduate
//
//  Created by yixiaoluo on 15/5/15.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface NetWorkEngine : AFHTTPRequestOperationManager

+ (instancetype)sharedEngine;

- (AFHTTPRequestOperation *)GET:(id)parameters
                     methodName:(NSString *)methodName
                        forPage:(NSInteger)page
                      limitPage:(NSInteger)limitPage
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)GET:(id)parameters
                     methodName:(NSString *)methodName
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)POST:(id)parameters
                      methodName:(NSString *)methodName
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)PUT:(id)parameters
                     methodName:(NSString *)methodName
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)PATCH:(id)parameters
                       methodName:(NSString *)methodName
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)DELETE:(id)parameters
                        methodName:(NSString *)methodName
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
