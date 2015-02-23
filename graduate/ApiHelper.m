//
//  ApiHelper.m
//  MobileNJU_2.5
//
//  Created by luck-mac on 14-10-17.
//  Copyright (c) 2014年 nju.excalibur. All rights reserved.
//

#import "ApiHelper.h"
#import "GTMBase64.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLRequestSerialization.h"
#import "AFURLSessionManager.h"
@implementation ApiHelper

- (instancetype)init
{
    _pageCount = -1;
    _page = -1;
    return self;
}
- (ApiHelper *)download:(id<ApiDelegate>)delegate url:(NSString *)url
{
    
    NSLog(@"歌曲下载%@",url);
//    if (![ToolUtils connectedToNetWork]&&![ToolUtils ignoreNetwork]) {
//        return nil;
//    }
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:response.suggestedFilename];
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:_fileId];   // 保存文件的名称
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        [delegate dispos:[NSDictionary dictionaryWithObjectsAndKeys:filePath,@"path",response.suggestedFilename,@"filename",_fileId,@"fileid", nil] functionName:@"download"];
    }];
    [downloadTask resume];
    return self;
}

//调用接口 get 方法名 参数 代理
- (ApiHelper*)load:(NSString *)method params:(NSDictionary *)params delegate:(id<ApiDelegate>)delegate
{
    if (![ToolUtils connectToInternet]) {
        return self;
    }
    _delegate = delegate;
    _name = method;
    _params = params;
    NSDictionary* dictionary = [self generateParams:params method:method];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:BASEURL parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation.request.URL.absoluteString);
        
        [self handleData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.delegate showError:error functionName:_name];
    }];
    return self;
}


- (NSDictionary*)generateParams:(NSDictionary*)initDic method:(NSString*)method
{
    NSMutableDictionary* dictionary;
    if (initDic) {
       dictionary = [[NSMutableDictionary alloc]initWithDictionary:initDic];
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
    
    if (_page>=0) {
        [dictionary setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"page"];
    }
    if (_pageCount>0) {
        [dictionary setObject:[NSString stringWithFormat:@"%d",_pageCount] forKey:@"limit"];
    }
    return dictionary;
}

//调用接口post 方法名 参数 代理
- (ApiHelper *)post:(NSString *)method params:(NSDictionary *)params delegate:(id<ApiDelegate>)delegate
{
    
    _delegate = delegate;
    _name = method;
    _params = params;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:BASEURL parameters:[self generateParams:params method:method] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation.request.URL.absoluteString);
        [self handleData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    return self;
}


- (void) handleData:(id)responseObject
{
    NSError* error = [[NSError alloc]init];
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
    if (resultDict) {
        if ([[resultDict objectForKey:@"errorCode"]integerValue]==0) {
            if ([resultDict objectForKey:@"data"]) {
                if (!self.object) {
                    [_delegate dispos:[resultDict objectForKey:@"data"] functionName:_name];
                } else {
                    [_delegate dispos:[resultDict objectForKey:@"data"] functionName:_name object:self.object];
                }
            } else {
                [_delegate showAlert:@"网络请求错误，请重试" functionName:_name];
            }
        } else {
            [_delegate showAlert:[resultDict objectForKey:@"errorMsg"] functionName:_name];
        }
    }
}


- (ApiHelper*)setPage:(NSInteger)page limit:(NSInteger) limit
{
    _page = page;
    _pageCount = limit;
    return self;
}



@end

