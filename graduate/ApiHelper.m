//
//  ApiHelper.m
//  MobileNJU_2.5
//
//  Created by luck-mac on 14-10-17.
//  Copyright (c) 2014年 nju.excalibur. All rights reserved.
//

#import "ApiHelper.h"
#import "GTMBase64.h"
@implementation ApiHelper

- (instancetype)init
{
    _pageCount = -1;
    _page = -1;
    return self;
}
- (ApiHelper *)downloadImg:(id<ApiDelegate>)delegate imgUrl:(NSString *)imgUrl
{
    _delegate = delegate;
    _name = @"Download";
    myData = [NSMutableData dataWithData:    [self loadData:self.fileId]];
    if (myData) {
        [_delegate dispos:[NSDictionary
                           dictionaryWithObjectsAndKeys:myData,@"img", nil] functionName:_name];
    } else {
        NSURL* url = [NSURL URLWithString:imgUrl];
        NSURLRequest* request = [NSURLRequest requestWithURL:url
                                 
                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                                 
                                             timeoutInterval:60.0];
        [NSURLConnection connectionWithRequest:request delegate:self];

    }
    return self;
}

//调用接口 get 方法名 参数 代理
- (ApiHelper*)load:(NSString *)method params:(NSDictionary *)params delegate:(id<ApiDelegate>)delegate
{
    _delegate = delegate;
    _name = method;
    _params = params;
    NSURL* url = [self generateUrl:params method:method];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    [NSURLConnection connectionWithRequest:request delegate:self];
    return self;
}


//调用接口post 方法名 参数 代理
- (ApiHelper *)post:(NSString *)method params:(NSDictionary *)params delegate:(id<ApiDelegate>)delegate
{
    _delegate = delegate;
    _name = method;
    _params = params;
    NSURL* url = [self generatePostUrl:method];
    NSMutableString* postStr = [[NSMutableString alloc]init];
    for (NSString* key in params.keyEnumerator) {
        [postStr appendFormat:@"%@=%@&",key,[params objectForKey:key]];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    [request setHTTPMethod:@"POST"];
    NSData* postData = [postStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    [NSURLConnection connectionWithRequest:request delegate:self];
    return self;
}


//生成getUrl
-(NSURL*) generateUrl:(NSDictionary*)params method:(NSString*) method;
{
    
    NSMutableString* urlStr = [[NSMutableString alloc]initWithString:BASEURL];
    [urlStr appendFormat:@"%@=%@&",@"methodno",method];
//    
//    if ([DataHelper strByName:@"appid"]) {
//        [urlStr appendFormat:@"%@=%@&",@"appid",[DataHelper strByName:@"appid"]];
//    }
    
    
    if ([ToolUtils getVerify]) {
        [urlStr appendFormat:@"%@=%@&",@"verify",[ToolUtils getVerify]];
    }
    if ([ToolUtils getDeviceId]) {
        [urlStr appendFormat:@"%@=%@&",@"deviceid",[ToolUtils getDeviceId]];
        
    }
    if ([ToolUtils getUserid]){
        [urlStr appendFormat:@"%@=%@&",@"userid",[ToolUtils getUserid]];
    }
    
    if (_page>=0) {
        [urlStr appendFormat:@"%@=%d&",@"page",_page];
        
    }
    if (_pageCount>0) {
        [urlStr appendFormat:@"%@=%d&",@"limit",_pageCount];
    }
    for (NSString* key in params.keyEnumerator) {
        [urlStr appendFormat:@"%@=%@&",key,[[params objectForKey:key]stringByReplacingOccurrencesOfString:@" " withString:@""]];
    }
    NSLog(@"%@",urlStr);
    return [NSURL URLWithString:urlStr];
    
}

//生成post Url
-(NSURL*) generatePostUrl:(NSString*) method;
{
    
    NSMutableString* urlStr = [[NSMutableString alloc]initWithString:BASEURL];
    [urlStr appendFormat:@"%@=%@&",@"methodno",method];
    
    if ([ToolUtils getVerify]) {
        [urlStr appendFormat:@"%@=%@&",@"verify",[ToolUtils getVerify]];
    }
    if ([ToolUtils getDeviceId]) {
        [urlStr appendFormat:@"%@=%@&",@"deviceid",[ToolUtils getDeviceId]];
        
    }
    if ([ToolUtils getUserid]){
        [urlStr appendFormat:@"%@=%@&",@"userid",[ToolUtils getUserid]];
    }
    if (_page>=0) {
        [urlStr appendFormat:@"%@=%d&",@"page",_page];
        
    }
    if (_pageCount>0) {
        [urlStr appendFormat:@"%@=%d&",@"limit",_pageCount];
    }
    NSLog(@"%@",urlStr);
    return [NSURL URLWithString:urlStr];
}





- (ApiHelper *)load:(id<ApiDelegate>)delegate img:(UIImage *)img name:(NSString *)fileName
{
    
    _delegate = delegate;
    _name = @"MImgUpload";
    NSURL* url = [self generateUrl:[NSDictionary dictionaryWithObjectsAndKeys:fileName,@"filename", nil] method:@"MImgUpload"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    [request setHTTPMethod:@"POST"];
    NSData* originData =  UIImagePNGRepresentation(img);
    NSData* encodeData = [GTMBase64 encodeData:originData];
    NSString* encodeResult = [[NSString alloc] initWithData:encodeData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",encodeResult);
    NSString* postStr = [NSString stringWithFormat:@"img=%@",encodeResult];
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection connectionWithRequest:request delegate:self];
    return self;
}

- (ApiHelper*)setPage:(NSInteger)page limit:(NSInteger) limit
{
    _page = page;
    _pageCount = limit;
    return self;
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!data) {
        [_delegate showAlert:@"网络请求错误，请重试"];
        return;
    }
    
    if(myData==nil) {
        myData = [[NSMutableData alloc] initWithCapacity:2048];
    }
    [myData appendData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
    if ([_name isEqualToString:@"Download"]) {
        [self save:myData name:self.fileId];
        [_delegate dispos:[NSDictionary
                           dictionaryWithObjectsAndKeys:myData,@"img", nil] functionName:_name];
    } else {
        NSError* error = [[NSError alloc]init];
        NSString* str = [[NSString alloc] initWithData:myData  encoding:NSUTF8StringEncoding];
        _content = str;
        NSData* result = [_content dataUsingEncoding:NSUTF8StringEncoding];
        if (!result) {
            [_delegate showAlert:@"网络请求错误，请重试"];
            return;
        }
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
        if (resultDict) {
            _content = nil;
            if ([[resultDict objectForKey:@"errorCode"]integerValue]==0) {
                if ([resultDict objectForKey:@"data"]) {
                    [_delegate dispos:[resultDict objectForKey:@"data"] functionName:_name];
                } else {
                    [_delegate showAlert:@"网络请求错误，请重试"];
                }
            } else {
                [_delegate showAlert:[resultDict objectForKey:@"errorMsg"]];
            }
        }

    }
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSLog(@"response");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [_delegate showError:error functionName:_name];
}

- (void)save:(NSData*) data name:(NSString*)fileName;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];   // 保存文件的名称
    [data writeToFile: filePath    atomically:YES];
}

- (NSData*) loadData:(NSString*)fileName;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];   // 保存文件的名称
    
//    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
    if (filePath) {
        return [NSData dataWithContentsOfURL:[NSURL URLWithString:filePath]];
    }
    return nil;
}

@end

