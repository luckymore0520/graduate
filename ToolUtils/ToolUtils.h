//
//  ToolUtils.h
//  udows hy
//
//  Created by Stephen Zhuang on 14-3-19.
//  Copyright (c) 2014年 ryan. All rights reserved.
//
#define SC_DEVICE_SIZE      [[UIScreen mainScreen] bounds].size

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#define PICURL @"http://114.215.196.179:8080/gs/download.do?id="
@interface ToolUtils : NSObject
@property (nonatomic , strong) NSMutableArray *tagArray;
+ (instancetype) sharedToolUtils;
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (BOOL)checkTel:(NSString *)str showAlert:(BOOL)show;
+ (BOOL)checkEmail:(NSString *)email;
+ (void)showMessage:(NSString *)message;
+ (BOOL)checkTextRange:(NSString *)text min:(NSInteger)min max:(NSInteger)max;


+ (void) setUserInfo:(NSDictionary*)userInfo;
+ (NSDictionary*) getUserInfo;


+ (void) setSubAccount:(NSDictionary*)subAccount;
+ (NSDictionary*) getSubAccount;



+ (NSURL *)getImageUrlWtihString:(NSString *)urlString;
+ (NSURL *)getImageUrlWtihString:(NSString *)urlString width:(CGFloat)width height:(CGFloat)height;



//第三方登陆唯一标识
+ (NSString*)getIdentify;
+ (void)setIdentify:(NSString*)openId;

+ (NSString*)getToken;
+ (void)setToken:(NSString*)token;

//微信code
+ (NSString*)getWeixinCode;
+ (void)setWeixinCode:(NSString*)weixinCode;

//是否第一次使用，若第一次使用 返回的应该为nil
+ (NSString*)getFirstUse;
+ (void)setFirstUse:(NSString*)firstUse;

//已使用天数
+ (NSNumber*)getCurrentDay;
+ (void) setCurrentDay:(NSNumber*) currentDay;

+ (NSString*)getCurrentDate;

//我的科目
+ (void)setMySubjects:(NSDictionary*)subjects;
+ (NSDictionary*)getMySubjects;

//登陆凭证
+(NSString*)getVerify;
+(void)setVerify:(NSString*)verify;

//用户id
+(NSString*)getUserid;
+(void)setUserId:(NSString*)userid;

//设备id
+(NSString*)getDeviceId;
+(void)setDeviceId:(NSString*)deviceid;

//用户信息
+(NSDictionary*)getUserInfomation;
+(void)setUserInfomation:(NSDictionary*)userInfo;

+(BOOL)getHasLogin;
+(void)setHasLogin:(BOOL)hasLogin;

//键盘高度
+(NSString*)getKeyboardHeight;
+(void)setKeyboardHeight:(NSNumber*)keyboardHeight;

+(NSString*)recommandDay;
+(void)setRecommandDay:(NSString*)day;

+(NSString*)getLastUpdateTime;
+(void)setLastUpdateTime:(NSString*)lastUpdateTime;

+ (NSString *)md5:(NSString *)str;
+ (void)save:(NSData*) data name:(NSString*)fileName;;

+ (NSData*) loadData:(NSString*)fileName;
+(BOOL)deleteFile:(NSString*) fileName ;
+(BOOL)connectToInternet;
+(BOOL)connectedToNetWork;
+(BOOL)ignoreNetwork;
+(void)setIgnoreNetwork:(BOOL)ignore;
+(void)showToast:(NSString*)msg toView:(UIView*)view;
+(void)showError:(NSString*)msg toView:(UIView*)view;
+(void)showMessage:(NSString *)message title:(NSString*)title;
//第三方服务信息
+(NSString *)weixinAppkey;
+(NSString *)weixinSecretKey;
+(NSString *)qqAppid;
+(NSString *)weiboAppid;

@end
