//
//  NetWorkEngine.m
//  graduate
//
//  Created by yixiaoluo on 15/5/15.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "NetWorkEngine.h"
#import "ToolUtils.h"
#import "ApiHelper.h"

@implementation NetWorkEngine

+ (instancetype)sharedEngine{
    static NetWorkEngine *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] initWithBaseURL:nil];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    return manager;
}

- (NSDictionary*)generateParams:(NSDictionary*)initDic method:(NSString*)method
{
    if (![initDic isKindOfClass:[NSDictionary class]]) {
        return initDic;
    }
    
    NSMutableDictionary *dictionary;
    if (initDic) {
        dictionary = [initDic mutableCopy];
    } else {
        dictionary = [[NSMutableDictionary alloc]init];
    }
    
    [dictionary setObject:method forKey:@"methodno"];
    if ([ToolUtils getVerify]) {
        [dictionary setObject:[ToolUtils getVerify] forKey:@"verify"];
    }
    if ([ToolUtils getDeviceId]) {
        [dictionary setObject:[ToolUtils getDeviceId] forKey:@"deviceid"];
    }
    if ([ToolUtils getUserid]){
        [dictionary setObject:[ToolUtils getUserid] forKey:@"userid"];
    }

    return dictionary;
}

#pragma mark -
- (AFHTTPRequestOperation *)GET:(id)parameters
                     methodName:(NSString *)methodName
                        forPage:(NSInteger)page
                      limitPage:(NSInteger)limitPage
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
{
    parameters = [self generateParams:parameters method:methodName];
    
    [parameters setObject:@(page) forKey:@"page"];
    [parameters setObject:@(limitPage) forKey:@"limit"];

    AFHTTPRequestOperation *operation = [super GET:BASEURL parameters:parameters success:success failure:failure];
    
    return operation;
}

- (AFHTTPRequestOperation *)GET:(id)parameters
                     methodName:(NSString *)methodName
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    parameters = [self generateParams:parameters method:methodName];
    
    AFHTTPRequestOperation *operation = [super GET:BASEURL parameters:parameters success:success failure:failure];
    
    return operation;
}

- (AFHTTPRequestOperation *)POST:(id)parameters
                      methodName:(NSString *)methodName
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    parameters = [self generateParams:parameters method:methodName];

    AFHTTPRequestOperation *operation = [super POST:BASEURL parameters:parameters success:success failure:failure];
    
    return operation;
}

- (AFHTTPRequestOperation *)PUT:(id)parameters
                     methodName:(NSString *)methodName
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    parameters = [self generateParams:parameters method:methodName];

    AFHTTPRequestOperation *operation = [super PUT:BASEURL parameters:parameters success:success failure:failure];
    
    return operation;
}

- (AFHTTPRequestOperation *)PATCH:(id)parameters
                       methodName:(NSString *)methodName
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    parameters = [self generateParams:parameters method:methodName];

    AFHTTPRequestOperation *operation = [super PATCH:BASEURL parameters:parameters success:success failure:failure];
    
    return operation;
}

- (AFHTTPRequestOperation *)DELETE:(id)parameters
                        methodName:(NSString *)methodName
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    parameters = [self generateParams:parameters method:methodName];

    AFHTTPRequestOperation *operation = [super DELETE:BASEURL parameters:parameters success:success failure:failure];
    
    return operation;
}

#pragma mark - 
- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    void (^parsedSuccess)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject){
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject allKeys] containsObject:@"errorCode"] && [responseObject[@"errorCode"] integerValue] == 0) {
                if ([[responseObject allKeys] containsObject:@"data"] && responseObject[@"data"]) {
                    success(operation, responseObject[@"data"]);
                }else{
                    failure(operation, [NSError errorWithDomain:@"" code:202 userInfo:@{
                                                                                        NSLocalizedDescriptionKey:@"网络请求错误，请重试"
                                                                                        }]);
                }
                return;
            }
        }
        
        failure(operation, [NSError errorWithDomain:@"" code:203 userInfo:@{
                                                                            NSLocalizedDescriptionKey:responseObject[@"errorMsg"]
                                                                            }]);
    };
    
    return [super HTTPRequestOperationWithRequest:request success:parsedSuccess failure:failure];
}
@end
