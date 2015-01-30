//
//  ToolUtils.m
//  udows hy
//
//  Created by Stephen Zhuang on 14-3-19.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "ToolUtils.h"
#import <CommonCrypto/CommonDigest.h> 

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
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@&w=%.0f&h=%.0f",PICURL,urlString , width , height]];
}



+ (BOOL)checkTel:(NSString *)str showAlert:(BOOL)show

{
    
    if ([str length] == 0) {
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


+(NSDictionary*)getUserInfomation
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfomation"];

}
+(void)setUserInfomation:(NSDictionary*)userInfo
{
    [self setUserId:[userInfo objectForKey:@"id_"]];
    [self setVerify:[userInfo objectForKey:@"verify_"]];
    [[NSUserDefaults standardUserDefaults]setObject:userInfo forKey:@"userInfomation"];
    [[NSUserDefaults standardUserDefaults]synchronize];
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


+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}


@end
