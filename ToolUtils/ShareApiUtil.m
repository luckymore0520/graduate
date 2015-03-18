//
//  ShareApiUtil.m
//  graduate
//
//  Created by TracyLin on 15/3/18.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "ShareApiUtil.h"

@implementation ShareApiUtil

+(void)qqShare:(NSString *)title description:(NSString *)description imageUrl:(NSString *)imageUrl shareUrl:(NSString *)shareUrl from:(id)from
{
    //    //分享图预览图URL地址
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:shareUrl]
                                title: title
                                description:description
                                previewImageURL:[NSURL URLWithString:imageUrl]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
    //将内容分享到qzone
    //QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
}


+(void)weixinShare:(NSString *)title description:(NSString *)description imageUrl:(NSString *)imageUrl shareUrl:(NSString *)shareUrl scene:(int)scene
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:[UIImage imageNamed:imageUrl]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
     ext.webpageUrl = shareUrl;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}

+(void)weiboShare:(NSString *)title description:(NSString *)description imageUrl:(NSString *)imageUrl shareUrl:(NSString *)shareUrl
{
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = KREDIRECTURL;
    authRequest.scope = @"all";
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[ShareApiUtil messageToShareForWeibo:title description:description imageUrl:imageUrl shareUrl:shareUrl] authInfo:authRequest access_token:[ToolUtils getToken]];
    request.userInfo = @{@"ShareMessageFrom": @"EssenceDetailViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
}


+(WBMessageObject *)messageToShareForWeibo:(NSString *)title description:(NSString *)description imageUrl:(NSString *)imageUrl shareUrl:(NSString *)shareUrl
{
    WBMessageObject *message = [WBMessageObject message];
    
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = @"identifier1";
    webpage.title = NSLocalizedString(title, nil);
    webpage.description = [NSString stringWithFormat:NSLocalizedString(description, nil), [[NSDate date] timeIntervalSince1970]];
    webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageUrl ofType:@"jpg"]];
    webpage.webpageUrl = shareUrl;
    message.mediaObject = webpage;
    return message;
}

+(void)showShareSuccessAlert
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"分享成功" message:@"分享成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}
@end
