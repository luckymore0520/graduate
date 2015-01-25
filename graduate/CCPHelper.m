//
//  CCPHelper.m
//  MobileNJU_2.5
//
//  Created by luck-mac on 14/11/7.
//  Copyright (c) 2014年 nju.excalibur. All rights reserved.
//

#import "CCPHelper.h"
#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64.h"
@implementation CCPHelper
- (void) getMainAccount
{
    NSString* timestamp = [self getTimestamp];
    NSString* sig = [self getSig:MAIN_ACCOUNT token:MAIN_TOKEN timestamp:timestamp];
    NSString* urlStr = [NSString stringWithFormat:@"%@AccountInfo?sig=%@",BASEURL,sig];
    NSURL* url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[self getMainAuthorization:timestamp] forHTTPHeaderField:@"Authorization"];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) createSubAccount:(NSString*) userId
{
    if ([userId isEqualToString:[ToolUtils getIdentify]]) {
        _method = @"createSubAccount";
        
    } else {
        _method = @"createAnotherSubAccount";
    }
    NSString* timestamp = [self getTimestamp];
    NSString* sig = [self getSig:MAIN_ACCOUNT token:MAIN_TOKEN timestamp:timestamp];
    NSString* urlStr = [NSString stringWithFormat:@"%@SubAccounts?sig=%@",BASEURL,sig];
    NSURL* url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[self getMainAuthorization:timestamp] forHTTPHeaderField:@"Authorization"];
    NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:APP_ID,@"appId",userId,@"friendlyName" ,nil];
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSData* postData = jsonData;
    [request setHTTPBody:postData];
    [NSURLConnection connectionWithRequest:request delegate:self];
}





-(void) querySubAccount:(NSString*) userId
{
    if ([userId isEqualToString:[ToolUtils getIdentify]]) {
        _method = @"querySubAccount";

    } else {
        _method = @"queryAnotherSubAccount";
    }
    NSString* timestamp = [self getTimestamp];
    NSString* sig = [self getSig:MAIN_ACCOUNT token:MAIN_TOKEN timestamp:timestamp];
    NSString* urlStr = [NSString stringWithFormat:@"%@QuerySubAccountByName?sig=%@",BASEURL,sig];
    NSURL* url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[self getMainAuthorization:timestamp] forHTTPHeaderField:@"Authorization"];
    NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:APP_ID,@"appId",userId,@"friendlyName" ,nil];
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSData* postData = jsonData;
    [request setHTTPBody:postData];
    [NSURLConnection connectionWithRequest:request delegate:self];
}




-(void) queryMyGroup
{
    [self queryForSubAccount:@"Member/QueryGroup" info:nil methodName: @"queryMyGroup"];
}

- (void)createGroup:(NSDictionary*)groupInfo
{
    [self queryForSubAccount:@"Group/CreateGroup" info:groupInfo     methodName:@"createGroup"];
}


- (void)queryGroupMember:(NSString*) groupId
{
    [self queryForSubAccount:@"Member/QueryMember" info:[NSDictionary dictionaryWithObjectsAndKeys:groupId,@"groupId", nil] methodName:@"queryGroupMember"];
}

- (void) searchGroup:(NSDictionary*)searchInfo
{
    [self queryForSubAccount:@"Group/SearchPublicGroups" info:searchInfo methodName:@"searchGroup"];
}

- (void)joinGroup:(NSDictionary *)joinInfo
{
    [self queryForSubAccount:@"Group/JoinGroup" info:joinInfo methodName:@"joinGroup"];
}

- (void) queryForSubAccount:(NSString*)query info:(NSDictionary*)info methodName:(NSString*)methodName
{
    _method = methodName;
    NSString* timestamp = [self getTimestamp];
    NSString* subAccounts = [[ToolUtils getSubAccount]objectForKey:@"subAccountSid"];
    NSString* subToken = [[ToolUtils getSubAccount]objectForKey:@"subToken"];
    NSString* sig = [self getSig:subAccounts   token:subToken timestamp:timestamp];
    NSString* urlStr = [NSString stringWithFormat:@"%@SubAccounts/%@/%@?sig=%@",BASEURLWITHNOACCOUNTS,subAccounts,query,sig];
    NSLog(@"%@",urlStr);
    NSURL* url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[self getSubAccountAuthorization:timestamp subAccount:subAccounts] forHTTPHeaderField:@"Authorization"];
    if (info) {
        NSError* error;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
        NSData* postData = jsonData;
        [request setHTTPBody:postData];
    }
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}
//根据sid和当前时间字符串获取一个Authorization编码
//- (NSString *)getAuthorization:(NSString *)timestamp
//{
//    NSString *authorizationString = [NSString stringWithFormat:@"%@:%@",self.subAccountSid,timestamp];
//    return [ASIHTTPRequest base64forData:[authorizationString dataUsingEncoding:NSUTF8StringEncoding]];
//}

//根据sid和当前时间字符串获取一个Authorization编码
- (NSString *)getMainAuthorization:(NSString *)timestamp
{
    NSString *authorizationString = [NSString stringWithFormat:@"%@:%@",MAIN_ACCOUNT,timestamp];
    NSData* data = [authorizationString dataUsingEncoding:NSUTF8StringEncoding];
    NSData* encodeData = [GTMBase64 encodeData:data];
    NSString* encodeResult = [[NSString alloc] initWithData:encodeData encoding:NSUTF8StringEncoding];
    return encodeResult;
}

- (NSString *)getSubAccountAuthorization:(NSString *)timestamp subAccount:(NSString*)subAccount
{
    NSString *authorizationString = [NSString stringWithFormat:@"%@:%@",subAccount,timestamp];
    NSData* data = [authorizationString dataUsingEncoding:NSUTF8StringEncoding];
    NSData* encodeData = [GTMBase64 encodeData:data];
    NSString* encodeResult = [[NSString alloc] initWithData:encodeData encoding:NSUTF8StringEncoding];
    return encodeResult;
}

//得到当前时间的字符串
- (NSString *)getTimestamp
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}

//获取sig编码
- (NSString *)getSig:(NSString*) account  token:(NSString*) token timestamp:(NSString *)timestamp
{
    NSString *sigString = [NSString stringWithFormat:@"%@%@%@", account, token, timestamp];
    const char *cStr = [sigString UTF8String];
	unsigned char result[16];
	CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
	return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
}




- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!data) {
        return;
    }
    NSError* error;
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (resultDict) {
        [_delegate reveiveData:resultDict method:_method];
        NSLog(@"%@",resultDict.description);
    }
}




- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSLog(@"response");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
}

@end
