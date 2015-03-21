//
//  ToolUtils.m
//  udows hy
//
//  Created by Stephen Zhuang on 14-3-19.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "ToolUtils.h"
#import <CommonCrypto/CommonDigest.h> 
#import "Reachability.h"
@implementation ToolUtils

+ (instancetype) sharedToolUtils
{
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}



+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}



+ (NSURL *)getImageUrlWtihString:(NSString *)urlString
{
    if (urlString == nil || [urlString isEqualToString:@""]) {
        return [NSURL URLWithString:@""];
    }
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,urlString]];
}

+ (NSURL *)getImageUrlWtihString:(NSString *)urlString width:(CGFloat)width height:(CGFloat)height
{
    if (urlString == nil || [urlString isEqualToString:@""]) {
        return [NSURL URLWithString:@""];
    }
    
    if (height!=0) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@&w=%.0f&h=%.0f",PICURL,urlString , width , height]];
    } else {
        NSLog(@"%@%@&w=%.0f",PICURL,urlString , width);
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@&w=%.0f",PICURL,urlString , width]];
    }
    
  
}




+ (BOOL)checkTel:(NSString *)str showAlert:(BOOL)show

{
    
    if ([str length] != 11) {
        if (show) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"请输入正确的电话号码", nil) message:NSLocalizedString(@"电话号码不能为空", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        }
      
        
        return NO;
        
    }
    
    //1[0-9]{10}
    
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    
    //    NSString *regex = @"[0-9]{11}";
    
    NSString *regex = @"^0{0,1}(13[0-9]|15[0-9]|18[0-9])[0-9]{8}|(?:0(?:10|2[0-57-9]|[3-9]\\d{2}))?\\d{7,8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        if (show) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的电话号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        }
       
        
        return NO;
        
    }
    
    
    
    return YES;
    
}

+ (void)showMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}


+(void)showMessage:(NSString *)message title:(NSString*)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}


+ (BOOL)checkTextRange:(NSString *)text min:(NSInteger)min max:(NSInteger)max
{
    if (text.length < min || text.length > max) {
        //        NSString *message = [NSString stringWithFormat:@"长度应在%i-%i位之间", min , max];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //        [alert show];
        return NO;
    } else {
        return YES;
    }
}

+ (BOOL)checkEmail:(NSString *)email
{
    NSString *emailRegex=@"^\\w+((\\-\\w+)|(\\.\\w+))*@[A-Za-z0-9]+((\\.|\\-)[A-Za-z0-9]+)*.[A-Za-z0-9]+$";
    NSPredicate *emailTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    BOOL isEmail=[emailTest evaluateWithObject:email];
    return isEmail;
}



+ (NSString *)checkUrl:(NSString *)url
{
    
    if (url.length >= 4 && [[url substringToIndex:4] isEqualToString:@"http"]) {
        return url;
    } else {
        url = [NSString stringWithFormat:@"http://%@" ,url];
        return url;
    }
}

+ (void)setUserInfo:(NSDictionary *)userInfo
{
    [[NSUserDefaults standardUserDefaults]setObject:userInfo forKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (NSDictionary *)getUserInfo
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
}

+ (NSString *)getIdentify
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"identify"];
}


+ (void)setIdentify:(NSString *)openId
{
    [[NSUserDefaults standardUserDefaults]setObject:openId forKey:@"identify"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}


+ (NSString*)getFirstUse
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"firstUse"];

}
+ (void)setFirstUse:(NSString*)firstUse
{
    [[NSUserDefaults standardUserDefaults]setObject:firstUse forKey:@"firstUse"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


+ (void) setSubAccount:(NSDictionary*)subAccount
{
    [[NSUserDefaults standardUserDefaults]setObject:subAccount forKey:@"subAccount"];
    [[NSUserDefaults standardUserDefaults]synchronize];

}


+ (NSDictionary*) getSubAccount
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"subAccount"];
}

+ (NSNumber*)getCurrentDay
{
    
    NSNumber* current = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentDay"];
//    NSDate* today = [NSDate date];
//    NSDate* currentDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentDate"];
    return current;

}
+ (void) setCurrentDay:(NSNumber*) currentDay
{
    NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
    [defaults setObject:currentDay forKey:@"currentDay"];
//    [[NSUserDefaults standardUserDefaults]setObject:[NSDate date] forKey:@"currentDate"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:[NSDate date]];
    [defaults setObject:destDateString forKey:@"currentDate"];
    [defaults synchronize];
}

+ (NSString *)getCurrentDate
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"currentDate"];
}

+ (void)setMySubjects:(NSDictionary*)subjects
{
    [[NSUserDefaults standardUserDefaults]setObject:subjects forKey:@"mySubjects"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


+ (NSDictionary*)getMySubjects
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"mySubjects"];
}


//登陆凭证
+(NSString*)getVerify
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"verify"];
}


+(void)setVerify:(NSString*)verify;
{
    [[NSUserDefaults standardUserDefaults]setObject:verify forKey:@"verify"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}



//用户id
+(NSString*)getUserid
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
}


+(void)setUserId:(NSString*)userid;
{
    [[NSUserDefaults standardUserDefaults]setObject:userid forKey:@"userid"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


//设备id
+(NSString*)getDeviceId
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"deviceid"];
}


+(void)setDeviceId:(NSString*)deviceid
{
    [[NSUserDefaults standardUserDefaults]setObject:deviceid forKey:@"deviceid"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(NSString*)getLastUpdateTime
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"lastUpdateTime"];

}
+(void)setLastUpdateTime:(NSString*)lastUpdateTime
{
    NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
    [defaults setObject:lastUpdateTime forKey:@"lastUpdateTime"];
    [defaults synchronize];
}

+(NSDictionary*)getUserInfomation
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfomation"];

}

+(NSString*)getKeyboardHeight
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"keyboard"];
}
+(void)setKeyboardHeight:(NSNumber*)keyboardHeight
{
    NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
    [defaults setObject:keyboardHeight forKey:@"keyboard"];
    [defaults synchronize];
}
+(void)setUserInfomation:(NSDictionary*)userInfo
{
    NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[userInfo objectForKey:@"id_"] forKey:@"userid"];
    [defaults setObject:[userInfo objectForKey:@"verify_"] forKey:@"verify"];
    [defaults setObject:[userInfo objectForKey:@"startDay_"] forKey:@"currentDay"];
    [defaults setObject:userInfo forKey:@"userInfomation"];
//    [[NSUserDefaults standardUserDefaults]setObject:userInfo forKey:@"userInfomation"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
    [defaults synchronize];
}


+(BOOL)getHasLogin
{
    return [[NSUserDefaults standardUserDefaults]boolForKey:@"hasLogin"];

}
+(void)setHasLogin:(BOOL)hasLogin
{
    [[NSUserDefaults standardUserDefaults]setBool :hasLogin forKey:@"hasLogin"];
    [[NSUserDefaults standardUserDefaults]synchronize];

}
+(NSString*)recommandDay
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"recommandDay"];

}
+(void)setRecommandDay:(NSString*)day
{
    [[NSUserDefaults standardUserDefaults]setObject :day forKey:@"recommandDay"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(BOOL)getNotFirstLogin
{
    return [[NSUserDefaults standardUserDefaults]boolForKey:@"firstLogin"];
}

+(void)setNotFirstLogin:(BOOL)firstLogin
{
    [[NSUserDefaults standardUserDefaults]setBool:firstLogin forKey:@"firstLogin"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}





+ (void)save:(NSData*) data name:(NSString*)fileName;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];   // 保存文件的名称
    NSLog(@"saveTo %@",filePath);
    if ([data writeToFile: filePath    atomically:YES]) {
        NSLog(@"图片保存成功");
    } else {
        NSLog(@"图片保存失败");
    }
    
}

+ (NSData*) loadData:(NSString*)fileName;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];   // 保存文件的名称
    NSLog(@"loadFrom %@",filePath);

    if (filePath) {
        return [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
    }
    return nil;
}

+(BOOL)deleteFile:(NSString*) fileName {
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@"no  have");
        return NO ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"dele success");
            return YES;
        }else {
            NSLog(@"dele fail");
            return NO;
        }
    }
}

+ (BOOL)connectToInternet
{
    
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
        
    struct sockaddr_storage zeroAddress;
        
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.ss_len = sizeof(zeroAddress);
    zeroAddress.ss_family = AF_INET;
        
        // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);

    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
    {
        return NO;
    }
        //根据获得的连接标志进行判断
        
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable&&!needsConnection) ? YES : NO;
    
}

//检查当前网络连接是否正常
+(BOOL)connectedToNetWork
{
    if ([[Reachability reachabilityForInternetConnection]isReachableViaWiFi]) {
        NSLog(@"连接wifi");
        return YES;
    }
    return NO;
}

+(BOOL)ignoreNetwork
{
    return [[NSUserDefaults standardUserDefaults]boolForKey:@"ignore"];
}
+(void)setIgnoreNetwork:(BOOL)ignore
{
    [[NSUserDefaults standardUserDefaults]setBool:ignore forKey:@"ignore"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


+ (NSString*)getToken
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];

}
+ (void)setToken:(NSString*)token
{
    [[NSUserDefaults standardUserDefaults]setObject:token forKey:@"token"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (NSString*)getWeixinCode
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"weixinCode"];
    
}
+ (void)setWeixinCode:(NSString *)weixinCode
{
    [[NSUserDefaults standardUserDefaults]setObject:weixinCode forKey:@"weixinCode"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(void)showError:(NSString*)msg toView:(UIView*)view
{
    [MBProgressHUD showError:msg toView:view];
}
+(void)showToast:(NSString*)msg toView:(UIView*)view

{
    if (view.superview) {
        [MBProgressHUD showSuccess:msg toView:view.superview];
    } else {
        [MBProgressHUD showSuccess:msg toView:view];
    }
}
////检查网络连接类型
//-(void)checkNetworktype:(id)sender{
//    NSString *connectionKind;
//    if ([self connectedToNetWork]) {
//        hostReach = [Reachability reachabilityWithHostName:@"www.google.com"];
//        switch ([hostReach currentReachabilityStatus]) {
//            case NotReachable:
//                connectionKind = @"没有网络链接";
//                break;
//            case ReachableViaWiFi:
//                connectionKind = @"当前使用的网络类型是WIFI";
//                break;
//            case ReachableVia3G:
//                connectionKind = @"当前使用的网络链接类型是WWAN（3G）";
//                break;
//            case ReachableVia2G:
//                connectionKind = @"当前使用的网络链接类型是WWAN（2G）";
//                break;
//            default:
//                break;
//        }
//    }else {
//        connectionKind = @"没有网络链接";
//    }
//}
+(NSString *)weixinAppkey
{
    return @"wx94e1ad5c4ece12a3";
}
+(NSString *)weixinSecretKey
{
    return @"905e00558f9ce2d0ee020d1ff4240473";
}
+(NSString *)qqAppid
{
    return @"1104165369";
}
+(NSString *)weiboAppid
{
    return @"77238273";
}
//默认日记内容  联系我们  关于我们的URL
+(NSString *)getDiaryDefault
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"diarydefault"];
}
+(void)setDiaryDefault:(NSString *)content
{
    [[NSUserDefaults standardUserDefaults]setObject:content forKey:@"diarydefault"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
+(NSString *)getAboutUrl
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"abouturl"];
}
+(void)setAboutUrl:(NSString *)url
{
    [[NSUserDefaults standardUserDefaults]setObject:url forKey:@"abouturl"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
+(NSString *)getContactUrl
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"contacturl"];
}
+(void)setContactUrl:(NSString *)url
{
    [[NSUserDefaults standardUserDefaults]setObject:url forKey:@"contacturl"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


@end
