//
//  ThirdPartyCallBackDelegate.m
//  graduate
//
//  Created by TracyLin on 15/3/18.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "ThirdPartyCallBackDelegate.h"
@interface ThirdPartyCallBackDelegate()<WeiboSDKDelegate,WXApiDelegate>

@end

@implementation ThirdPartyCallBackDelegate

//微博回调
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString* weiboId = [(WBAuthorizeResponse *)response userID];
        if (!weiboId) {
            return;
        }
        [ToolUtils setIdentify:weiboId];
        [ToolUtils setToken:[(WBAuthorizeResponse *)response accessToken]];
        
        NSLog(@"%@ Token---%@",[ToolUtils getToken],weiboId);
        [ToolUtils setUserInfo:nil];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"weiboLogin" object:nil];
    }else if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        if(response.statusCode == 0){
            [[NSNotificationCenter defaultCenter]postNotificationName:@"shareSuccess" object:nil];
        }    }
    
}

//微信回调
-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *temp = (SendAuthResp*)resp;
        NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
        //NSString *strMsg = [NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", temp.copy, temp.state, temp.errCode];
        if (temp.errCode== 0) {
            NSString *code = temp.code;
            NSLog(@"code%@",code);
            [ToolUtils setWeixinCode:temp.code];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"weixinLogin" object:nil];
        }
    }else if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if(resp.errCode == 0){
            [[NSNotificationCenter defaultCenter]postNotificationName:@"shareSuccess" object:nil];
        }
        
    }
}

@end
