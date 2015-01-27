//
//  ToolUtils.h
//  udows hy
//
//  Created by Stephen Zhuang on 14-3-19.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ToolUtils : NSObject
@property (nonatomic , strong) NSMutableArray *tagArray;
+ (instancetype) sharedToolUtils;
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (BOOL)checkTel:(NSString *)str;
+ (BOOL)checkEmail:(NSString *)email;
+ (void)showMessage:(NSString *)message;
+ (BOOL)checkTextRange:(NSString *)text min:(NSInteger)min max:(NSInteger)max;


+ (void) setUserInfo:(NSDictionary*)userInfo;
+ (NSDictionary*) getUserInfo;


+ (void) setSubAccount:(NSDictionary*)subAccount;
+ (NSDictionary*) getSubAccount;


//第三方登陆唯一标识
+ (NSString*)getIdentify;
+ (void)setIdentify:(NSString*)openId;

//是否第一次使用，若第一次使用 返回的应该为nil
+ (NSString*)getFirstUse;
+ (void)setFirstUse:(NSString*)firstUse;

//已使用天数
+ (NSNumber*)getCurrentDay;
+ (void) setCurrentDay:(NSNumber*) currentDay;

//我的科目
+ (void)setMySubjects:(NSDictionary*)subjects;
+ (NSDictionary*)getMySubjects;
@end
